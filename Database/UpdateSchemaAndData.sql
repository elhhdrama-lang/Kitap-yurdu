USE KitapyurduDB;
GO

-- 1. Add new columns to Books table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'Publisher')
BEGIN
    ALTER TABLE Books ADD Publisher NVARCHAR(100) NULL;
    PRINT 'Publisher column added.';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'PageCount')
BEGIN
    ALTER TABLE Books ADD PageCount INT NULL;
    PRINT 'PageCount column added.';
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'Language')
BEGIN
    ALTER TABLE Books ADD Language NVARCHAR(50) NULL;
    PRINT 'Language column added.';
END
GO

-- 2. Update View to include new columns
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
    b.Publisher,   -- New
    b.PageCount,   -- New
    b.Language,    -- New
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

-- 3. Clear existing data to replace with user's data (preserving relational integrity)
-- Disable constraints temporarily to make mass deletion easier, or delete in order
DELETE FROM OrderDetails;
DELETE FROM Cart;
DELETE FROM Reviews;
DELETE FROM Favorites;
DELETE FROM Books;
-- We'll keep Authors and Categories but ensure the needed ones exist
GO

-- 4. Helper to ensure Author exists and get ID
-- We will use a script block or procedure approach for data migration
DECLARE @Authors TABLE (Name NVARCHAR(100), ID INT);
INSERT INTO @Authors (Name, ID)
SELECT FirstName + ' ' + LastName, AuthorID FROM Authors;

DECLARE @Categories TABLE (Name NVARCHAR(100), ID INT);
INSERT INTO @Categories (Name, ID)
SELECT CategoryName, CategoryID FROM Categories;

-- Function-like logic for inserting if not exists is hard in T-SQL batch without procedures, 
-- so we'll do direct inserts for missing ones.

-- Ensure Categories
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Roman') INSERT INTO Categories (CategoryName) VALUES ('Roman');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Çocuk') INSERT INTO Categories (CategoryName) VALUES ('Çocuk');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Bilim') INSERT INTO Categories (CategoryName) VALUES ('Bilim');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Tarih') INSERT INTO Categories (CategoryName) VALUES ('Tarih');

-- Ensure Authors (Splitting Name simplified for this batch)
-- Map: "Fyodor Dostoyevski" -> First: Fyodor, Last: Dostoyevski
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski') INSERT INTO Authors (FirstName, LastName) VALUES ('Fyodor', 'Dostoyevski');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell') INSERT INTO Authors (FirstName, LastName) VALUES ('George', 'Orwell');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Paulo' AND LastName = 'Coelho') INSERT INTO Authors (FirstName, LastName) VALUES ('Paulo', 'Coelho');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Antoine' AND LastName = 'de Saint-Exupéry') INSERT INTO Authors (FirstName, LastName) VALUES ('Antoine', 'de Saint-Exupéry');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Yuval Noah' AND LastName = 'Harari') INSERT INTO Authors (FirstName, LastName) VALUES ('Yuval Noah', 'Harari');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Mustafa Kemal' AND LastName = 'Atatürk') INSERT INTO Authors (FirstName, LastName) VALUES ('Mustafa Kemal', 'Atatürk');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal') INSERT INTO Authors (FirstName, LastName) VALUES ('Yaşar', 'Kemal');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Jose Mauro' AND LastName = 'de Vasconcelos') INSERT INTO Authors (FirstName, LastName) VALUES ('Jose Mauro', 'de Vasconcelos');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali') INSERT INTO Authors (FirstName, LastName) VALUES ('Sabahattin', 'Ali');

-- 5. Insert Data
DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman');
DECLARE @CocukID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Çocuk');
DECLARE @BilimID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Bilim');
DECLARE @TarihID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Tarih');

DECLARE @FyodorID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Dostoyevski');
DECLARE @OrwellID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Orwell');
DECLARE @CoelhoID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Coelho');
DECLARE @ExuperyID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'de Saint-Exupéry');
DECLARE @HarariID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Harari');
DECLARE @AtaturkID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Atatürk');
DECLARE @YasarKemalID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Kemal');
DECLARE @VasconcelosID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'de Vasconcelos');
DECLARE @SabahattinAliID INT = (SELECT AuthorID FROM Authors WHERE LastName = 'Ali');

INSERT INTO Books (Title, AuthorID, CategoryID, Publisher, Price, Description, StockQuantity, ImageURL, ISBN, PageCount, Language, PublishedDate, CreatedDate)
VALUES 
('Suç ve Ceza', @FyodorID, @RomanID, 'İş Bankası Yayınları', 89.90, 'Dostoyevski''nin başyapıtlarından biri', 45, 'https://picsum.photos/seed/sucveceza/400/600', '9789754580235', 688, 'Türkçe', '2025-12-19', GETDATE()),
('1984', @OrwellID, @RomanID, 'Can Yayınları', 45.00, 'Totaliter bir rejimin kontrolü altındaki distopik bir dünya', 32, 'https://picsum.photos/seed/1984/400/600', '9789750718533', 352, 'Türkçe', '2025-12-19', GETDATE()),
('Simyacı', @CoelhoID, @RomanID, 'Can Yayınları', 38.50, 'Bir Endülüs çobanının hazinesini aramak için çıktığı yolculuk', 58, 'https://picsum.photos/seed/simyaci/400/600', '9789750707223', 176, 'Türkçe', '2025-12-19', GETDATE()),
('Küçük Prens', @ExuperyID, @CocukID, 'Can Çocuk Yayınları', 28.00, 'Tüm zamanların en çok okunan kitaplarından biri', 67, 'https://picsum.photos/seed/kucukprens/400/600', '9789750705694', 96, 'Türkçe', '2025-12-19', GETDATE()),
('Sapiens', @HarariID, @BilimID, 'Kolektif Kitap', 85.00, 'İnsanlığın evriminden günümüze kadar olan serüveni', 41, 'https://picsum.photos/seed/sapiens/400/600', '9786050915556', 536, 'Türkçe', '2025-12-19', GETDATE()),
('Nutuk', @AtaturkID, @TarihID, 'Türk Tarih Kurumu', 65.00, 'Türkiye Cumhuriyeti''nin kuruluş sürecini anlatan tarihi konuşma', 38, 'https://picsum.photos/seed/nutuk/400/600', '9789751617729', 720, 'Türkçe', '2025-12-19', GETDATE()),
('İnce Memed', @YasarKemalID, @RomanID, 'Yapı Kredi Yayınları', 42.00, 'Türk edebiyatının en önemli eserlerinden biri', 29, 'https://picsum.photos/seed/incememed/400/600', '9789750810527', 439, 'Türkçe', '2025-12-19', GETDATE()),
('Şeker Portakalı', @VasconcelosID, @RomanID, 'Can Yayınları', 35.00, 'Fakirlik içinde yaşayan beş yaşındaki Zeze''nin hikayesi', 0, 'https://picsum.photos/seed/sekerportakali/400/600', '9789750707964', 184, 'Türkçe', '2025-12-19', GETDATE()),
('Hayvan Çiftliği', @OrwellID, @RomanID, 'Can Yayınları', 32.00, 'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman', 62, 'https://picsum.photos/seed/hayvanciftligi/400/600', '9789750718526', 128, 'Türkçe', '2025-12-19', GETDATE()),
('Kürk Mantolu Madonna', @SabahattinAliID, @RomanID, 'Yapı Kredi Yayınları', 36.00, 'Türk edebiyatının en çok okunan aşk romanlarından biri', 55, 'https://picsum.photos/seed/kurkmantolu/400/600', '9789750809521', 176, 'Türkçe', '2025-12-19', GETDATE());

-- Seed some reviews to match the '5.0 Rating with 1 Review' for "Suç ve Ceza"
DECLARE @User1 INT = (SELECT TOP 1 UserID FROM Users);
DECLARE @SucVeCezaID INT = (SELECT BookID FROM Books WHERE ISBN = '9789754580235');

IF @User1 IS NOT NULL AND @SucVeCezaID IS NOT NULL
BEGIN
   INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
   VALUES (@SucVeCezaID, @User1, 5, 'Harika bir kitap!', GETDATE());
END

PRINT 'Schema updated and data imported successfully.';
GO
