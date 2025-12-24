USE KitapyurduDB;
GO

-- 1. Create Sellers Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sellers')
BEGIN
    CREATE TABLE Sellers (
        SellerID INT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(255) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        CompanyName NVARCHAR(100) NOT NULL,
        ContactInfo NVARCHAR(255) NULL,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE()
    );
    PRINT 'Sellers table created.';
END
GO

-- 2. Add SellerID to Books Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'SellerID')
BEGIN
    ALTER TABLE Books ADD SellerID INT NULL;
    ALTER TABLE Books ADD CONSTRAINT FK_Books_Sellers FOREIGN KEY (SellerID) REFERENCES Sellers(SellerID);
    PRINT 'SellerID column added to Books table with Foreign Key.';
END
GO

-- 3. Update View to include SellerID
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
    b.ImageURL,
    b.Publisher,
    b.PageCount,
    b.Language,
    b.SellerID, -- New
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
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT 'Database refactored for Sellers.';
GO
