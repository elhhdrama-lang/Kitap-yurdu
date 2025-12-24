USE KitapyurduDB;
GO

-- 1. Add ImageURL column to Books table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'ImageURL')
BEGIN
    ALTER TABLE Books ADD ImageURL NVARCHAR(500) NULL;
    PRINT 'ImageURL column added to Books table.';
END
GO

-- 2. Update vw_BookDetails View
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL
    DROP VIEW vw_BookDetails;
GO

CREATE VIEW vw_BookDetails
AS
SELECT 
    b.BookID,
    b.Title,
    b.ISBN,
    b.Price,
    b.StockQuantity,
    b.Description,
    b.PublishedDate,
    b.CreatedDate,
    b.ImageURL, -- Added
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorFullName,
    a.Biography AS AuthorBiography,
    c.CategoryID,
    c.CategoryName,
    c.Description AS CategoryDescription,
    CASE 
        WHEN b.StockQuantity > 10 THEN 'Stokta Var'
        WHEN b.StockQuantity > 0 THEN 'Az Stokta'
        ELSE 'Stokta Yok'
    END AS StockStatus,
    ISNULL((SELECT COUNT(*) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalOrders,
    ISNULL((SELECT SUM(od.Quantity) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalSold,
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating, -- Added Rating
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount -- Added Review Count
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

-- 3. Update sp_GetBooksByCategory
IF OBJECT_ID('sp_GetBooksByCategory', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBooksByCategory;
GO

CREATE PROCEDURE sp_GetBooksByCategory
    @CategoryID INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        b.Description,
        b.PublishedDate,
        b.ImageURL, -- Added
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        (SELECT COUNT(*) FROM Books WHERE CategoryID = @CategoryID) AS TotalCount,
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating, -- Added
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount -- Added
    FROM Books b
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE b.CategoryID = @CategoryID
    ORDER BY b.CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- 4. Update sp_GetBestSellingBooks
IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    SELECT TOP (@TopCount)
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        b.ImageURL, -- Added
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        SUM(od.Quantity) AS TotalSold,
        SUM(od.SubTotal) AS TotalRevenue,
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating, -- Added
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount -- Added
    FROM Books b
    INNER JOIN OrderDetails od ON b.BookID = od.BookID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE o.Status != 'Cancelled'
    GROUP BY b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.ImageURL,
             a.FirstName, a.LastName, c.CategoryName
    ORDER BY TotalSold DESC;
END
GO

-- 5. Update some sample data with ImageURLs (Placeholder images)
-- Using Lorem Picsum with seed based on BookID to simulate different persistent images for each book
UPDATE Books SET ImageURL = 'https://picsum.photos/seed/book' + CAST(BookID AS NVARCHAR) + '/400/600' WHERE ImageURL IS NULL;
GO

PRINT 'Database updated successfully with ImageURL and Rating support.';
GO
