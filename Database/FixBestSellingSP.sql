USE KitapyurduDB;
GO

IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    -- En çok satılan kitapları getirir
    -- Note: This requires at least one sale to show up. 
    -- If we want "Best Selling" to fall back to "Newest" or just random if no sales, 
    -- we might need a LEFT JOIN or a UNION, but "Best Selling" implies sales.
    
    SELECT TOP (@TopCount)
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        b.ImageURL, -- Added ImageURL
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        SUM(od.Quantity) AS TotalSold,
        SUM(od.SubTotal) AS TotalRevenue,
        -- Added stats expected by C# code
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
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

PRINT 'sp_GetBestSellingBooks updated successfully.';
GO
