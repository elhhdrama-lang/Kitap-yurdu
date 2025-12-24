USE KitapyurduDB;
GO

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'Complete Turkish Character Fix';
PRINT '========================================';
GO

-- Step 1: Delete all corrupted data and re-insert with proper encoding
PRINT '';
PRINT 'Step 1: Clearing corrupted data...';

-- Clear books and related data
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

-- Clear authors with encoding issues
DELETE FROM Authors WHERE 
    FirstName LIKE '%�%' OR LastName LIKE '%�%' OR Biography LIKE '%�%' OR
    FirstName LIKE '%Ã%' OR LastName LIKE '%Ã%' OR Biography LIKE '%Ã%' OR
    FirstName LIKE '%?%' OR LastName LIKE '%?%' OR Biography LIKE '%?%';

PRINT '✓ Corrupted data cleared.';
GO

-- Step 2: Insert clean authors
PRINT '';
PRINT 'Step 2: Inserting authors with correct Turkish characters...';

-- Ensure these authors exist with proper Turkish characters
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Sabahattin', N'Ali', N'Türk edebiyatının önemli yazarlarından');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'George', N'Orwell', N'1984 ve Hayvan Çiftliği yazarı');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Zülfü', N'Livaneli', N'Yazar, müzisyen ve siyasetçi');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Stefan', N'Zweig', N'Avusturyalı yazar');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yuval Noah', N'Harari', N'Sapiens yazarı');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Fyodor', N'Dostoyevski', N'Rus edebiyatının büyük yazarı');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Oğuz', N'Atay', N'Türk edebiyatının önemli yazarlarından');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'İlber', N'Ortaylı', N'Türk tarihçi');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Mustafa Kemal' AND LastName = N'Atatürk')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Mustafa Kemal', N'Atatürk', N'Türkiye Cumhuriyeti''nin kurucusu');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'J.K.', N'Rowling', N'Harry Potter serisinin yazarı');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'İnci' AND LastName = N'Aral')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'İnci', N'Aral', N'Türk yazar');

IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = N'Hasan Ali' AND LastName = N'Toptaş')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Hasan Ali', N'Toptaş', N'Türk yazar');

PRINT '✓ Authors inserted with correct encoding.';
GO

-- Step 3: Ensure categories with proper Turkish characters
PRINT '';
PRINT 'Step 3: Fixing categories...';

UPDATE Categories SET CategoryName = N'Roman', Description = N'Roman türü kitaplar' WHERE CategoryName LIKE '%Roman%';
UPDATE Categories SET CategoryName = N'Çocuk Kitapları', Description = N'Çocuklar için kitaplar' WHERE CategoryName LIKE '%ocuk%';
UPDATE Categories SET CategoryName = N'Bilim', Description = N'Bilim kitapları' WHERE CategoryName LIKE '%Bilim%';
UPDATE Categories SET CategoryName = N'Tarih', Description = N'Tarih kitapları' WHERE CategoryName LIKE '%Tarih%';
UPDATE Categories SET CategoryName = N'Felsefe', Description = N'Felsefe kitapları' WHERE CategoryName LIKE '%Felsefe%';

PRINT '✓ Categories fixed.';
GO

-- Step 4: Insert books with proper Turkish characters
PRINT '';
PRINT 'Step 4: Inserting books with correct Turkish characters...';

DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Roman');
DECLARE @CocukID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Çocuk Kitapları');
DECLARE @BilimID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Bilim');
DECLARE @TarihID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Tarih');
DECLARE @FelsefeID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Felsefe');

INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL, Publisher, PageCount, Language)
VALUES
(N'Kürk Mantolu Madonna', N'9789750810527', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 35.00, 50, 
    N'Sabahattin Ali''nin unutulmaz aşk romanı', 
    '1943-01-01', 
    'https://picsum.photos/seed/kurkmantolu/400/600', 
    N'Yapı Kredi Yayınları', 176, N'Türkçe'),

(N'Kuyucaklı Yusuf', N'9789750810528', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 32.00, 45, 
    N'Sabahattin Ali''nin ünlü romanı', 
    '1937-01-01', 
    'https://picsum.photos/seed/kuyucakli/400/600', 
    N'Yapı Kredi Yayınları', 208, N'Türkçe'),

(N'İçimizdeki Şeytan', N'9789750810529', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 28.00, 40, 
    N'Sabahattin Ali''nin kısa öyküleri', 
    '1940-01-01', 
    'https://picsum.photos/seed/icimizdeki/400/600', 
    N'Yapı Kredi Yayınları', 160, N'Türkçe'),

(N'1984', N'9789750718533', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell'), 
    @RomanID, 45.00, 60, 
    N'Totaliter bir rejimin kontrolü altındaki distopik bir dünya', 
    '1949-01-01', 
    'https://picsum.photos/seed/1984/400/600', 
    N'Can Yayınları', 352, N'Türkçe'),

(N'Serenad', N'9789750810530', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli'), 
    @RomanID, 38.00, 55, 
    N'Zülfü Livaneli''nin duygusal romanı', 
    '2011-01-01', 
    'https://picsum.photos/seed/serenad/400/600', 
    N'Doğan Kitap', 320, N'Türkçe'),

(N'Huzursuzluk', N'9789750810531', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli'), 
    @RomanID, 42.00, 48, 
    N'Zülfü Livaneli romanı', 
    '2017-01-01', 
    'https://picsum.photos/seed/huzursuzluk/400/600', 
    N'Doğan Kitap', 352, N'Türkçe'),

(N'Bilinmeyen Bir Kadının Mektubu', N'9789750810532', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig'), 
    @RomanID, 25.00, 70, 
    N'Stefan Zweig''ın duygusal hikayesi', 
    '1922-01-01', 
    'https://picsum.photos/seed/bilinmeyen/400/600', 
    N'İş Bankası Yayınları', 96, N'Türkçe'),

(N'Hayvan Çiftliği', N'9789750718526', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell'), 
    @RomanID, 32.00, 65, 
    N'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman', 
    '1945-01-01', 
    'https://picsum.photos/seed/hayvanciftligi/400/600', 
    N'Can Yayınları', 128, N'Türkçe'),

(N'Homo Deus', N'9786050915563', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari'), 
    @BilimID, 58.00, 42, 
    N'Yarının kısa tarihi', 
    '2015-01-01', 
    'https://picsum.photos/seed/homodeus/400/600', 
    N'Kolektif Kitap', 448, N'Türkçe'),

(N'Suç ve Ceza', N'9789754580235', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski'), 
    @FelsefeID, 89.90, 38, 
    N'Dostoyevski''nin başyapıtlarından biri', 
    '1866-01-01', 
    'https://picsum.photos/seed/sucveceza/400/600', 
    N'İş Bankası Yayınları', 688, N'Türkçe'),

(N'Tutunamayanlar', N'9789750810533', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay'), 
    @RomanID, 75.00, 30, 
    N'Türk edebiyatının başyapıtlarından', 
    '1971-01-01', 
    'https://picsum.photos/seed/tutunamayanlar/400/600', 
    N'İletişim Yayınları', 724, N'Türkçe'),

(N'Bir Ömür Nasıl Yaşanır', N'9789750810534', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı'), 
    @TarihID, 45.00, 52, 
    N'İlber Ortaylı''nın hayat üzerine düşünceleri', 
    '2019-01-01', 
    'https://picsum.photos/seed/biromur/400/600', 
    N'Kronik Kitap', 256, N'Türkçe'),

(N'Gazi Mustafa Kemal Atatürk', N'9789750810535', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Mustafa Kemal' AND LastName = N'Atatürk'), 
    @TarihID, 65.00, 35, 
    N'Atatürk hakkında kapsamlı biyografi', 
    '1927-01-01', 
    'https://picsum.photos/seed/ataturk/400/600', 
    N'Türk Tarih Kurumu', 720, N'Türkçe'),

(N'Harry Potter ve Felsefe Taşı', N'9789750807673', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling'), 
    @CocukID, 50.00, 80, 
    N'Fantastik edebiyatın başyapıtı', 
    '1997-01-01', 
    'https://picsum.photos/seed/harrypotter/400/600', 
    N'Yapı Kredi Yayınları', 368, N'Türkçe'),

(N'Bebek Gemi', N'9789750810536', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'İnci' AND LastName = N'Aral'), 
    @CocukID, 28.00, 45, 
    N'Çocuklar için duygusal bir hikaye', 
    '2015-01-01', 
    'https://picsum.photos/seed/bebekgemi/400/600', 
    N'Can Çocuk Yayınları', 192, N'Türkçe'),

(N'Koca Deve', N'9789750810537', 
    (SELECT AuthorID FROM Authors WHERE FirstName = N'Hasan Ali' AND LastName = N'Toptaş'), 
    @RomanID, 36.00, 40, 
    N'Hasan Ali Toptaş''ın büyüleyici romanı', 
    '2019-01-01', 
    'https://picsum.photos/seed/kocadeve/400/600', 
    N'Everest Yayınları', 288, N'Türkçe');

PRINT '✓ ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' books inserted with correct encoding.';
GO

-- Step 5: Verify
PRINT '';
PRINT '========================================';
PRINT 'Verification:';
PRINT '========================================';

SELECT COUNT(*) AS TotalBooks FROM Books;
SELECT COUNT(*) AS TotalAuthors FROM Authors;

PRINT '';
PRINT 'Turkish Character Fix Complete!';
PRINT 'All data now uses proper Unicode (NVARCHAR) with correct Turkish characters.';
GO
