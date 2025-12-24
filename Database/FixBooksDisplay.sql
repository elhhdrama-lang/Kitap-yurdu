USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Fixing Books Display Issue';
PRINT '========================================';
GO

-- Step 1: Add missing columns to Books table
PRINT 'Step 1: Adding missing columns to Books table...';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'ImageURL')
BEGIN
    ALTER TABLE Books ADD ImageURL NVARCHAR(500) NULL;
    PRINT '✓ ImageURL column added.';
END
ELSE
    PRINT '⚠ ImageURL column already exists.';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'Publisher')
BEGIN
    ALTER TABLE Books ADD Publisher NVARCHAR(100) NULL;
    PRINT '✓ Publisher column added.';
END
ELSE
    PRINT '⚠ Publisher column already exists.';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'PageCount')
BEGIN
    ALTER TABLE Books ADD PageCount INT NULL;
    PRINT '✓ PageCount column added.';
END
ELSE
    PRINT '⚠ PageCount column already exists.';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'Language')
BEGIN
    ALTER TABLE Books ADD Language NVARCHAR(50) NULL;
    PRINT '✓ Language column added.';
END
ELSE
    PRINT '⚠ Language column already exists.';

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Books' AND COLUMN_NAME = 'SellerID')
BEGIN
    ALTER TABLE Books ADD SellerID INT NULL;
    PRINT '✓ SellerID column added.';
END
ELSE
    PRINT '⚠ SellerID column already exists.';
GO

-- Step 2: Update vw_BookDetails View to include all columns
PRINT '';
PRINT 'Step 2: Updating vw_BookDetails view...';

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
    b.SellerID,
    -- Author information
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorFullName,
    a.Biography AS AuthorBiography,
    -- Category information
    c.CategoryID,
    c.CategoryName,
    c.Description AS CategoryDescription,
    -- Stock status
    CASE 
        WHEN b.StockQuantity > 10 THEN 'Stokta Var'
        WHEN b.StockQuantity > 0 THEN 'Az Stokta'
        ELSE 'Stokta Yok'
    END AS StockStatus,
    -- Sales statistics
    ISNULL((SELECT COUNT(*) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalOrders,
    ISNULL((SELECT SUM(od.Quantity) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalSold,
    -- Rating information
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT '✓ vw_BookDetails view updated successfully.';
GO

-- Step 3: Ensure necessary categories and authors exist
PRINT '';
PRINT 'Step 3: Ensuring categories and authors exist...';

-- Ensure Categories
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Roman') 
    INSERT INTO Categories (CategoryName, Description) VALUES ('Roman', 'Roman türü kitaplar');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Çocuk Kitapları') 
    INSERT INTO Categories (CategoryName, Description) VALUES ('Çocuk Kitapları', 'Çocuklar için kitaplar');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Bilim') 
    INSERT INTO Categories (CategoryName, Description) VALUES ('Bilim', 'Bilim kitapları');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Tarih') 
    INSERT INTO Categories (CategoryName, Description) VALUES ('Tarih', 'Tarih kitapları');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Felsefe') 
    INSERT INTO Categories (CategoryName, Description) VALUES ('Felsefe', 'Felsefe kitapları');

PRINT '✓ Categories ensured.';

-- Ensure Authors
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Sabahattin', 'Ali', 'Türk edebiyatının önemli yazarlarından');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Yusuf') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Sabahattin', 'Yusuf', 'Türk yazar');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Stefan' AND LastName = 'Zweig') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Stefan', 'Zweig', 'Avusturyalı yazar');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('George', 'Orwell', '1984 ve Hayvan Çiftliği yazarı');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Zülfü' AND LastName = 'Livaneli') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Zülfü', 'Livaneli', 'Yazar, müzisyen ve siyasetçi');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Zülfü' AND LastName = 'Huzursuzluk') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Zülfü', 'Huzursuzluk', 'Türk yazar');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Yuval Noah' AND LastName = 'Harari') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Yuval Noah', 'Harari', 'Sapiens yazarı');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Fyodor', 'Dostoyevski', 'Rus edebiyatının büyük yazarı');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Oğuz' AND LastName = 'Atay') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Oğuz', 'Atay', 'Türk edebiyatının önemli yazarlarından');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'İlber' AND LastName = 'Ortaylı') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('İlber', 'Ortaylı', 'Türk tarihçi');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Mustafa Kemal' AND LastName = 'Atatürk') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Mustafa Kemal', 'Atatürk', 'Türkiye Cumhuriyeti''nin kurucusu');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'J.K.' AND LastName = 'Rowling') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('J.K.', 'Rowling', 'Harry Potter serisinin yazarı');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'İnci' AND LastName = 'Aral') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('İnci', 'Aral', 'Türk yazar');
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Hasan Ali' AND LastName = 'Toptaş') 
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES ('Hasan Ali', 'Toptaş', 'Türk yazar');

PRINT '✓ Authors ensured.';
GO

-- Step 4: Clear existing books and insert your book data
PRINT '';
PRINT 'Step 4: Inserting book data...';

-- Clear existing books (preserving relational integrity)
DELETE FROM OrderDetails;
DELETE FROM Cart;
DELETE FROM Reviews;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Favorites')
    DELETE FROM Favorites;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StockMovements')
    DELETE FROM StockMovements;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PriceChangeLog')
    DELETE FROM PriceChangeLog;
DELETE FROM Books;

PRINT '✓ Existing book data cleared.';
GO

-- Get Category and Author IDs
DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman');
DECLARE @CocukID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Çocuk Kitapları');
DECLARE @BilimID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Bilim');
DECLARE @TarihID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Tarih');
DECLARE @FelsefeID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Felsefe');

-- Insert Books
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL, Publisher, PageCount, Language)
VALUES
-- Kürk Mantolu Madonna
('Kürk Mantolu Madonna', '9789750810527', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali'), 
    @RomanID, 35.00, 50, 
    'Sabahattin Ali''nin unutulmaz aşk romanı', 
    '1943-01-01', 
    'https://picsum.photos/seed/kurkmantolu/400/600', 
    'Yapı Kredi Yayınları', 176, 'Türkçe'),

-- Kuyucaklı Yusuf
('Kuyucaklı Yusuf', '9789750810528', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali'), 
    @RomanID, 32.00, 45, 
    'Sabahattin Ali''nin ünlü romanı', 
    '1937-01-01', 
    'https://picsum.photos/seed/kuyucakli/400/600', 
    'Yapı Kredi Yayınları', 208, 'Türkçe'),

-- İçimizdeki Şeytan
('İçimizdeki Şeytan', '9789750810529', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali'), 
    @RomanID, 28.00, 40, 
    'Sabahattin Ali''nin kısa öyküleri', 
    '1940-01-01', 
    'https://picsum.photos/seed/icimizdeki/400/600', 
    'Yapı Kredi Yayınları', 160, 'Türkçe'),

-- 1984
('1984', '9789750718533', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell'), 
    @RomanID, 45.00, 60, 
    'Totaliter bir rejimin kontrolü altındaki distopik bir dünya', 
    '1949-01-01', 
    'https://picsum.photos/seed/1984/400/600', 
    'Can Yayınları', 352, 'Türkçe'),

-- Serenad
('Serenad', '9789750810530', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Zülfü' AND LastName = 'Livaneli'), 
    @RomanID, 38.00, 55, 
    'Zülfü Livaneli''nin duygusal romanı', 
    '2011-01-01', 
    'https://picsum.photos/seed/serenad/400/600', 
    'Doğan Kitap', 320, 'Türkçe'),

-- Huzursuzluk
('Huzursuzluk', '9789750810531', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Zülfü' AND LastName = 'Livaneli'), 
    @RomanID, 42.00, 48, 
    'Zülfü Livaneli romanı', 
    '2017-01-01', 
    'https://picsum.photos/seed/huzursuzluk/400/600', 
    'Doğan Kitap', 352, 'Türkçe'),

-- Bilinmeyen Bir Kadının Mektubu
('Bilinmeyen Bir Kadının Mektubu', '9789750810532', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Stefan' AND LastName = 'Zweig'), 
    @RomanID, 25.00, 70, 
    'Stefan Zweig''ın duygusal hikayesi', 
    '1922-01-01', 
    'https://picsum.photos/seed/bilinmeyen/400/600', 
    'İş Bankası Yayınları', 96, 'Türkçe'),

-- Hayvan Çiftliği
('Hayvan Çiftliği', '9789750718526', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell'), 
    @RomanID, 32.00, 65, 
    'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman', 
    '1945-01-01', 
    'https://picsum.photos/seed/hayvanciftligi/400/600', 
    'Can Yayınları', 128, 'Türkçe'),

-- Homo Deus
('Homo Deus', '9786050915563', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Yuval Noah' AND LastName = 'Harari'), 
    @BilimID, 58.00, 42, 
    'Yarının kısa tarihi', 
    '2015-01-01', 
    'https://picsum.photos/seed/homodeus/400/600', 
    'Kolektif Kitap', 448, 'Türkçe'),

-- Suç ve Ceza
('Suç ve Ceza', '9789754580235', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski'), 
    @FelsefeID, 89.90, 38, 
    'Dostoyevski''nin başyapıtlarından biri', 
    '1866-01-01', 
    'https://picsum.photos/seed/sucveceza/400/600', 
    'İş Bankası Yayınları', 688, 'Türkçe'),

-- Tutunamayanlar
('Tutunamayanlar', '9789750810533', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Oğuz' AND LastName = 'Atay'), 
    @RomanID, 75.00, 30, 
    'Türk edebiyatının başyapıtlarından', 
    '1971-01-01', 
    'https://picsum.photos/seed/tutunamayanlar/400/600', 
    'İletişim Yayınları', 724, 'Türkçe'),

-- Bir Ömür Nasıl Yaşanır
('Bir Ömür Nasıl Yaşanır', '9789750810534', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'İlber' AND LastName = 'Ortaylı'), 
    @TarihID, 45.00, 52, 
    'İlber Ortaylı''nın hayat üzerine düşünceleri', 
    '2019-01-01', 
    'https://picsum.photos/seed/biromur/400/600', 
    'Kronik Kitap', 256, 'Türkçe'),

-- Gazi Mustafa Kemal Atatürk
('Gazi Mustafa Kemal Atatürk', '9789750810535', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Mustafa Kemal' AND LastName = 'Atatürk'), 
    @TarihID, 65.00, 35, 
    'Atatürk hakkında kapsamlı biyografi', 
    '1927-01-01', 
    'https://picsum.photos/seed/ataturk/400/600', 
    'Türk Tarih Kurumu', 720, 'Türkçe'),

-- Harry Potter ve Felsefe Taşı
('Harry Potter ve Felsefe Taşı', '9789750807673', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'J.K.' AND LastName = 'Rowling'), 
    @CocukID, 50.00, 80, 
    'Fantastik edebiyatın başyapıtı', 
    '1997-01-01', 
    'https://picsum.photos/seed/harrypotter/400/600', 
    'Yapı Kredi Yayınları', 368, 'Türkçe'),

-- Bebek Gemi
('Bebek Gemi', '9789750810536', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'İnci' AND LastName = 'Aral'), 
    @CocukID, 28.00, 45, 
    'Çocuklar için duygusal bir hikaye', 
    '2015-01-01', 
    'https://picsum.photos/seed/bebekgemi/400/600', 
    'Can Çocuk Yayınları', 192, 'Türkçe'),

-- Koca Deve
('Koca Deve', '9789750810537', 
    (SELECT AuthorID FROM Authors WHERE FirstName = 'Hasan Ali' AND LastName = 'Toptaş'), 
    @RomanID, 36.00, 40, 
    'Hasan Ali Toptaş''ın büyüleyici romanı', 
    '2019-01-01', 
    'https://picsum.photos/seed/kocadeve/400/600', 
    'Everest Yayınları', 288, 'Türkçe');

PRINT '✓ ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' books inserted successfully.';
GO

-- Step 5: Verify the data
PRINT '';
PRINT 'Step 5: Verifying data...';
PRINT '';

SELECT COUNT(*) AS TotalBooks FROM Books;
SELECT COUNT(*) AS TotalAuthors FROM Authors;
SELECT COUNT(*) AS TotalCategories FROM Categories;

PRINT '';
PRINT '========================================';
PRINT 'Books Display Fix Completed Successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Restart your web application';
PRINT '2. Navigate to the homepage';
PRINT '3. Your books should now be visible!';
PRINT '';
GO
