-- =============================================
-- HOME PAGE DISPLAY FIX
-- Restores missing columns to vw_BookDetails and ensures procedures are robust
-- =============================================

USE KitapyurduDB;
GO

PRINT 'Repairing Home Page Views...';

-- 1. FIX vw_BookDetails (Add AverageRating and ReviewCount)
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL DROP VIEW vw_BookDetails;
GO

CREATE VIEW vw_BookDetails AS
SELECT 
    b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.CreatedDate, b.ImageURL, b.SellerID,
    ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorFullName,
    ISNULL(a.FirstName, N'Bilinmeyen') AS AuthorFirstName,
    ISNULL(a.LastName, N'Yazar') AS AuthorLastName,
    ISNULL(c.CategoryName, N'Genel') AS CategoryName,
    b.AuthorID,
    b.CategoryID,
    CASE 
        WHEN b.StockQuantity > 10 THEN N'Stokta Var' 
        WHEN b.StockQuantity > 0 THEN N'Az Stokta' 
        ELSE N'Stokta Yok' 
    END AS StockStatus,
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount,
    ISNULL(b.Publisher, N'Genel Yayın') AS Publisher,
    ISNULL(b.PageCount, 0) AS PageCount,
    ISNULL(b.Language, N'Türkçe') AS Language
FROM Books b 
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID 
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

-- 2. ENSURE SAMPLE IMAGES (If missing)
UPDATE Books SET ImageURL = 'https://picsum.photos/seed/book' + CAST(BookID AS NVARCHAR) + '/400/600' WHERE ImageURL IS NULL OR ImageURL = '';
GO

-- 3. FIX sp_GetBestSellingBooks (Ensure it returns SOMETHING even if no orders)
IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    -- If no orders exist, return the newest books instead of nothing
    IF NOT EXISTS (SELECT 1 FROM OrderDetails)
    BEGIN
        SELECT TOP (@TopCount)
            b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
            ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName,
            ISNULL(c.CategoryName, N'Genel') AS CategoryName,
            0 AS TotalSold, 0 AS TotalRevenue,
            ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
            ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
        FROM Books b
        LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
        LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
        ORDER BY b.CreatedDate DESC;
    END
    ELSE
    BEGIN
        SELECT TOP (@TopCount)
            b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
            ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName,
            ISNULL(c.CategoryName, N'Genel') AS CategoryName,
            SUM(ISNULL(od.Quantity, 0)) AS TotalSold,
            SUM(ISNULL(od.SubTotal, 0)) AS TotalRevenue,
            ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
            ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
        FROM Books b
        LEFT JOIN OrderDetails od ON b.BookID = od.BookID
        LEFT JOIN Orders o ON od.OrderID = o.OrderID AND o.Status != 'Cancelled'
        LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
        LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
        GROUP BY b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL, a.FirstName, a.LastName, c.CategoryName
        ORDER BY TotalSold DESC;
    END
END
GO

PRINT '✓ Home Page Fix Applied.';
