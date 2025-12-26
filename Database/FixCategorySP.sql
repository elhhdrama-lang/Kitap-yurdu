USE KitapyurduDB;
GO

IF OBJECT_ID('sp_GetBooksByCategory', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBooksByCategory;
GO

CREATE PROCEDURE sp_GetBooksByCategory
    @CategoryID INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    -- Belirli bir kategorideki kitapları sayfalama ile getirir
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
        -- Added stats
        ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
        ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
    FROM Books b
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE b.CategoryID = @CategoryID
    ORDER BY b.CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

PRINT 'sp_GetBooksByCategory updated successfully.';
GO
