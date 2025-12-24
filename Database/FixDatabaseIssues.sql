-- =============================================
-- COMPREHENSIVE DATABASE REPAIR & CLEANUP
-- =============================================

USE KitapyurduDB;
GO

PRINT 'Starting Deep Clean and Repair...';

-- 1. DELETE GHOST DATA (Items pointing to non-existent books)
DELETE FROM Cart WHERE BookID NOT IN (SELECT BookID FROM Books);
DELETE FROM Favorites WHERE BookID NOT IN (SELECT BookID FROM Books);
DELETE FROM OrderDetails WHERE BookID NOT IN (SELECT BookID FROM Books);
DELETE FROM Reviews WHERE BookID NOT IN (SELECT BookID FROM Books);

PRINT '✓ Ghost items cleared.';

-- 2. REPAIR vw_BookDetails (Robust joins + Unicode)
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL DROP VIEW vw_BookDetails;
GO

CREATE VIEW vw_BookDetails
AS
SELECT 
    b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.CreatedDate, b.ImageURL, b.Publisher, b.PageCount, b.Language, b.SellerID,
    ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorFullName,
    a.Biography AS AuthorBiography,
    ISNULL(c.CategoryName, N'Genel') AS CategoryName,
    c.Description AS CategoryDescription,
    CASE 
        WHEN b.StockQuantity > 10 THEN N'Stokta Var'
        WHEN b.StockQuantity > 0 THEN N'Az Stokta'
        ELSE N'Stokta Yok'
    END AS StockStatus,
    ISNULL((SELECT COUNT(*) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalOrders,
    ISNULL((SELECT SUM(od.Quantity) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalSold,
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
FROM Books b
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT '✓ vw_BookDetails repaired.';

-- 3. REPAIR sp_GetUserCart
IF OBJECT_ID('sp_GetUserCart', 'P') IS NOT NULL DROP PROCEDURE sp_GetUserCart;
GO

CREATE PROCEDURE sp_GetUserCart
    @UserID INT
AS
BEGIN
    SELECT 
        c.CartID, c.Quantity, c.AddedDate,
        b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
        (c.Quantity * b.Price) AS SubTotal,
        ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName,
        ISNULL(cat.CategoryName, N'Genel') AS CategoryName
    FROM Cart c
    LEFT JOIN Books b ON c.BookID = b.BookID
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    LEFT JOIN Categories cat ON b.CategoryID = cat.CategoryID
    WHERE c.UserID = @UserID
    ORDER BY c.AddedDate DESC;
    
    SELECT 
        ISNULL(SUM(c.Quantity * b.Price), 0) AS TotalAmount,
        ISNULL(SUM(c.Quantity), 0) AS TotalItems
    FROM Cart c
    LEFT JOIN Books b ON c.BookID = b.BookID
    WHERE c.UserID = @UserID;
END
GO

-- 4. REPAIR sp_GetBooksByCategory
IF OBJECT_ID('sp_GetBooksByCategory', 'P') IS NOT NULL DROP PROCEDURE sp_GetBooksByCategory;
GO

CREATE PROCEDURE sp_GetBooksByCategory
    @CategoryID INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    SELECT 
        b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.ImageURL,
        ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName,
        ISNULL(c.CategoryName, N'Genel') AS CategoryName,
        (SELECT COUNT(*) FROM Books WHERE CategoryID = @CategoryID) AS TotalCount,
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
    FROM Books b
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE b.CategoryID = @CategoryID
    ORDER BY b.CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- 5. REPAIR sp_GetBestSellingBooks
IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    SELECT TOP (@TopCount)
        b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
        ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName,
        ISNULL(c.CategoryName, N'Genel') AS CategoryName,
        SUM(od.Quantity) AS TotalSold,
        SUM(od.SubTotal) AS TotalRevenue,
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
    FROM Books b
    INNER JOIN OrderDetails od ON b.BookID = od.BookID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE o.Status != 'Cancelled'
    GROUP BY b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
             a.FirstName, a.LastName, c.CategoryName
    ORDER BY TotalSold DESC;
END
GO

PRINT '✓ All Stored Procedures repaired with LEFT JOINs.';

-- 6. FINAL PATCH: Unicode Encoding for core metadata
UPDATE Categories SET CategoryName = N'Edebiyat' WHERE CategoryID = 1;
UPDATE Categories SET CategoryName = N'Tarih' WHERE CategoryID = 2;
UPDATE Categories SET CategoryName = N'Bilim' WHERE CategoryID = 3;
UPDATE Categories SET CategoryName = N'Felsefe' WHERE CategoryID = 4;
UPDATE Categories SET CategoryName = N'Çocuk ve Gençlik' WHERE CategoryID = 5;
UPDATE Categories SET CategoryName = N'Psikoloji' WHERE CategoryID = 6;
UPDATE Categories SET CategoryName = N'Ekonomi' WHERE CategoryID = 7;

-- Clean up any broken references in Books
UPDATE Books SET AuthorID = 1 WHERE AuthorID NOT IN (SELECT AuthorID FROM Authors);
UPDATE Books SET CategoryID = 1 WHERE CategoryID NOT IN (SELECT CategoryID FROM Categories);

-- 6. REPAIR sp_GetUserOrders
IF OBJECT_ID('sp_GetUserOrders', 'P') IS NOT NULL DROP PROCEDURE sp_GetUserOrders;
GO

CREATE PROCEDURE sp_GetUserOrders
    @UserID INT
AS
BEGIN
    SELECT 
        o.OrderID, o.OrderDate, o.TotalAmount, o.Status, o.ShippingAddress,
        od.OrderDetailID, od.Quantity, od.UnitPrice, od.SubTotal,
        b.Title AS BookTitle, b.ISBN,
        ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Books b ON od.BookID = b.BookID
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    WHERE o.UserID = @UserID
    ORDER BY o.OrderDate DESC;
END
GO

PRINT '✓ sp_GetUserOrders repaired.';
PRINT '========================================';
PRINT 'DEEP CLEAN COMPLETED SUCCESSFULLY.';
