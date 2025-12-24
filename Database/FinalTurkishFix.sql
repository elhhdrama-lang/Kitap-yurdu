USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Final Turkish Character Fix';
PRINT '========================================';
GO

-- Step 1: Clean up duplicate categories
PRINT 'Step 1: Cleaning up categories...';

-- Keep only the original categories and delete duplicates
DELETE FROM Categories WHERE CategoryID > 1000;

-- Fix the remaining categories
UPDATE Categories SET CategoryName = N'Roman', Description = N'Roman türü kitaplar' WHERE CategoryID = 1;
UPDATE Categories SET CategoryName = N'Tarih', Description = N'Tarih kitapları' WHERE CategoryID = 2;
UPDATE Categories SET CategoryName = N'Bilim', Description = N'Bilim kitapları' WHERE CategoryID = 3;
UPDATE Categories SET CategoryName = N'Felsefe', Description = N'Felsefe kitapları' WHERE CategoryID = 4;
UPDATE Categories SET CategoryName = N'Çocuk Kitapları', Description = N'Çocuklar için kitaplar' WHERE CategoryID = 5;
UPDATE Categories SET CategoryName = N'Psikoloji', Description = N'Psikoloji kitapları' WHERE CategoryID = 6;
UPDATE Categories SET CategoryName = N'Ekonomi', Description = N'Ekonomi kitapları' WHERE CategoryID = 7;

PRINT '✓ Categories cleaned and fixed.';
GO

-- Step 2: Insert books with correct encoding
PRINT '';
PRINT 'Step 2: Inserting books...';

-- Use fixed category IDs
DECLARE @RomanID INT = 1;
DECLARE @TarihID INT = 2;
DECLARE @BilimID INT = 3;
DECLARE @FelsefeID INT = 4;
DECLARE @CocukID INT = 5;

INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL, Publisher, PageCount, Language)
VALUES
(N'Kürk Mantolu Madonna', N'9789750810527', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 35.00, 50, 
    N'Sabahattin Ali''nin unutulmaz aşk romanı', 
    '1943-01-01', 
    'https://picsum.photos/seed/kurkmantolu/400/600', 
    N'Yapı Kredi Yayınları', 176, N'Türkçe'),

(N'Kuyucaklı Yusuf', N'9789750810528', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 32.00, 45, 
    N'Sabahattin Ali''nin ünlü romanı', 
    '1937-01-01', 
    'https://picsum.photos/seed/kuyucakli/400/600', 
    N'Yapı Kredi Yayınları', 208, N'Türkçe'),

(N'İçimizdeki Şeytan', N'9789750810529', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali'), 
    @RomanID, 28.00, 40, 
    N'Sabahattin Ali''nin kısa öyküleri', 
    '1940-01-01', 
    'https://picsum.photos/seed/icimizdeki/400/600', 
    N'Yapı Kredi Yayınları', 160, N'Türkçe'),

(N'1984', N'9789750718533', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell'), 
    @RomanID, 45.00, 60, 
    N'Totaliter bir rejimin kontrolü altındaki distopik bir dünya', 
    '1949-01-01', 
    'https://picsum.photos/seed/1984/400/600', 
    N'Can Yayınları', 352, N'Türkçe'),

(N'Serenad', N'9789750810530', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli'), 
    @RomanID, 38.00, 55, 
    N'Zülfü Livaneli''nin duygusal romanı', 
    '2011-01-01', 
    'https://picsum.photos/seed/serenad/400/600', 
    N'Doğan Kitap', 320, N'Türkçe'),

(N'Huzursuzluk', N'9789750810531', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli'), 
    @RomanID, 42.00, 48, 
    N'Zülfü Livaneli romanı', 
    '2017-01-01', 
    'https://picsum.photos/seed/huzursuzluk/400/600', 
    N'Doğan Kitap', 352, N'Türkçe'),

(N'Bilinmeyen Bir Kadının Mektubu', N'9789750810532', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig'), 
    @RomanID, 25.00, 70, 
    N'Stefan Zweig''ın duygusal hikayesi', 
    '1922-01-01', 
    'https://picsum.photos/seed/bilinmeyen/400/600', 
    N'İş Bankası Yayınları', 96, N'Türkçe'),

(N'Hayvan Çiftliği', N'9789750718526', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell'), 
    @RomanID, 32.00, 65, 
    N'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman', 
    '1945-01-01', 
    'https://picsum.photos/seed/hayvanciftligi/400/600', 
    N'Can Yayınları', 128, N'Türkçe'),

(N'Homo Deus', N'9786050915563', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari'), 
    @BilimID, 58.00, 42, 
    N'Yarının kısa tarihi', 
    '2015-01-01', 
    'https://picsum.photos/seed/homodeus/400/600', 
    N'Kolektif Kitap', 448, N'Türkçe'),

(N'Suç ve Ceza', N'9789754580235', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski'), 
    @FelsefeID, 89.90, 38, 
    N'Dostoyevski''nin başyapıtlarından biri', 
    '1866-01-01', 
    'https://picsum.photos/seed/sucveceza/400/600', 
    N'İş Bankası Yayınları', 688, N'Türkçe'),

(N'Tutunamayanlar', N'9789750810533', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay'), 
    @RomanID, 75.00, 30, 
    N'Türk edebiyatının başyapıtlarından', 
    '1971-01-01', 
    'https://picsum.photos/seed/tutunamayanlar/400/600', 
    N'İletişim Yayınları', 724, N'Türkçe'),

(N'Bir Ömür Nasıl Yaşanır', N'9789750810534', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı'), 
    @TarihID, 45.00, 52, 
    N'İlber Ortaylı''nın hayat üzerine düşünceleri', 
    '2019-01-01', 
    'https://picsum.photos/seed/biromur/400/600', 
    N'Kronik Kitap', 256, N'Türkçe'),

(N'Gazi Mustafa Kemal Atatürk', N'9789750810535', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Mustafa Kemal' AND LastName = N'Atatürk'), 
    @TarihID, 65.00, 35, 
    N'Atatürk hakkında kapsamlı biyografi', 
    '1927-01-01', 
    'https://picsum.photos/seed/ataturk/400/600', 
    N'Türk Tarih Kurumu', 720, N'Türkçe'),

(N'Harry Potter ve Felsefe Taşı', N'9789750807673', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling'), 
    @CocukID, 50.00, 80, 
    N'Fantastik edebiyatın başyapıtı', 
    '1997-01-01', 
    'https://picsum.photos/seed/harrypotter/400/600', 
    N'Yapı Kredi Yayınları', 368, N'Türkçe'),

(N'Bebek Gemi', N'9789750810536', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'İnci' AND LastName = N'Aral'), 
    @CocukID, 28.00, 45, 
    N'Çocuklar için duygusal bir hikaye', 
    '2015-01-01', 
    'https://picsum.photos/seed/bebekgemi/400/600', 
    N'Can Çocuk Yayınları', 192, N'Türkçe'),

(N'Koca Deve', N'9789750810537', 
    (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Hasan Ali' AND LastName = N'Toptaş'), 
    @RomanID, 36.00, 40, 
    N'Hasan Ali Toptaş''ın büyüleyici romanı', 
    '2019-01-01', 
    'https://picsum.photos/seed/kocadeve/400/600', 
    N'Everest Yayınları', 288, N'Türkçe');

PRINT '✓ ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' books inserted successfully.';
GO

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! All Turkish characters fixed!';
PRINT '========================================';
PRINT '';

SELECT COUNT(*) AS TotalBooks FROM Books;
SELECT COUNT(*) AS TotalAuthors FROM Authors;
SELECT COUNT(*) AS TotalCategories FROM Categories;

PRINT '';
PRINT 'Sample data:';
SELECT TOP 5 Title, Publisher, Language FROM Books;
GO
