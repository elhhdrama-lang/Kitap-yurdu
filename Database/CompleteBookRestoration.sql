-- =============================================
-- COMPLETE BOOK RESTORATION WITH REVIEWS & RATINGS
-- Restores all corrected books with full details
-- =============================================

USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'COMPLETE BOOK RESTORATION STARTING...';
PRINT '========================================';
PRINT '';

-- STEP 1: CLEAR EXISTING DATA
PRINT 'Step 1: Clearing existing data...';

-- Delete in correct order to respect foreign keys
DELETE FROM Reviews;
DELETE FROM Favorites;
DELETE FROM Cart;
DELETE FROM OrderDetails;
DELETE FROM Books;

PRINT '✓ Existing data cleared';
PRINT '';

-- STEP 2: ENSURE CATEGORIES EXIST
PRINT 'Step 2: Setting up categories...';

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Edebiyat')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Edebiyat', N'Edebiyat ve Roman kitapları');

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Tarih')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Tarih', N'Tarih kitapları');

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Bilim')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Bilim', N'Bilim kitapları');

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Felsefe')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Felsefe', N'Felsefe kitapları');

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Çocuk ve Gençlik')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Çocuk ve Gençlik', N'Çocuk ve gençlik kitapları');

DECLARE @EdebiyatID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Edebiyat');
DECLARE @TarihID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Tarih');
DECLARE @BilimID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Bilim');
DECLARE @FelsefeID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Felsefe');
DECLARE @CocukID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Çocuk ve Gençlik');

PRINT '✓ Categories ready';
PRINT '';

-- STEP 3: ENSURE AUTHORS EXIST
PRINT 'Step 3: Setting up authors...';

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Sabahattin', N'Ali', N'Türk edebiyatının önemli öykü ve roman yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Yaşar' AND LastName = N'Kemal')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yaşar', N'Kemal', N'Türk edebiyatının ünlü romancısı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'George', N'Orwell', N'İngiliz yazar ve gazeteci');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Zülfü', N'Livaneli', N'Türk yazar, müzisyen ve yönetmen');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Oğuz', N'Atay', N'Türk edebiyatının önemli yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Stefan', N'Zweig', N'Avusturyalı yazar');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yuval Noah', N'Harari', N'İsrailli tarihçi ve yazar');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Fyodor', N'Dostoyevski', N'Rus edebiyatının büyük yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'İlber', N'Ortaylı', N'Türk tarihçi ve akademisyen');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'J.K.', N'Rowling', N'İngiliz yazar, Harry Potter serisinin yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Reşat Nuri', N'Güntekin', N'Türk edebiyatının ünlü romancısı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Orhan' AND LastName = N'Pamuk')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Orhan', N'Pamuk', N'Nobel ödüllü Türk yazar');

DECLARE @SabahattinAliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali');
DECLARE @YasarKemalID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yaşar' AND LastName = N'Kemal');
DECLARE @GeorgeOrwellID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell');
DECLARE @ZulfuLivaneliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli');
DECLARE @OguzAtayID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay');
DECLARE @StefanZweigID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig');
DECLARE @YuvalHarariID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari');
DECLARE @DostoyevskiID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski');
DECLARE @IlberOrtayliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı');
DECLARE @JKRowlingID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling');
DECLARE @ResatNuriID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin');
DECLARE @OrhanPamukID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Orhan' AND LastName = N'Pamuk');

PRINT '✓ Authors ready';
PRINT '';

-- STEP 4: INSERT ALL BOOKS
PRINT 'Step 4: Inserting books...';

SET IDENTITY_INSERT Books ON;

-- Book 1: Kürk Mantolu Madonna
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (1, N'Kürk Mantolu Madonna', '9789753638029', @SabahattinAliID, @EdebiyatID, 50.00, 110, 
        N'Bir sanatçı ile bir kadın arasındaki tutkulu aşk hikayesi.', '2019-02-09', '2025-12-23 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe', 1);

-- Book 2: Kuyucaklı Yusuf
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (2, N'Kuyucaklı Yusuf', '9789753638036', @YasarKemalID, @EdebiyatID, 180.00, 85, 
        N'Bir mücadele romanı.', '2019-02-09', '2025-12-22 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467891/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe', 1);

-- Book 3: İçimizdeki Şeytan
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (3, N'İçimizdeki Şeytan', '9789753639043', @SabahattinAliID, @EdebiyatID, 29.00, 60, 
        N'Sabahattin Ali''nin öyküleri.', '2020-02-03', '2025-12-23 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467892/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe', 1);

-- Book 4: 1984
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (4, N'1984', '9789750115153', @GeorgeOrwellID, @EdebiyatID, 27.50, 200, 
        N'George Orwell''in distopya klasiği.', '2021-09-01', '2025-12-22 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467893/wh:true/wi:220', N'Can Yayınları', N'Türkçe', 1);

-- Book 5: Serenad
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (5, N'Serenad', '9786020000526', @ZulfuLivaneliID, @EdebiyatID, 32.00, 120, 
        N'Zülfü Livaneli''nin romanı.', '2025-12-31', '2025-12-28 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467894/wh:true/wi:220', N'İletişim Yayınları', N'Türkçe', 1);

-- Book 6: Huzursuzluk
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (6, N'Huzursuzluk', '9786050053866', @ZulfuLivaneliID, @EdebiyatID, 55.00, 90, 
        N'İnsanın iç dünyasına yolculuk.', '2020-01-02', '2025-12-23 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467895/wh:true/wi:220', N'İletişim Yayınları', N'Türkçe', 1);

-- Book 7: Bilinmeyen Bir Kadının Mektubu
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (7, N'Bilinmeyen Bir Kadının Mektubu', '9789752100247', @StefanZweigID, @EdebiyatID, 10.00, 140, 
        N'Stefan Zweig''ın duygusal romanı.', '2025-05-02', '2025-12-23 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467896/wh:true/wi:220', N'Türkiye İş Bankası', N'Türkçe', 1);

-- Book 8: Hayvan Çiftliği
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (8, N'Hayvan Çiftliği', '9786050026637', @GeorgeOrwellID, @FelsefeID, 120.00, 75, 
        N'George Orwell''in alegorik romanı.', '2019-01-09', '2025-12-22 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467897/wh:true/wi:220', N'Can Yayınları', N'Türkçe', 1);

-- Book 9: Homo Deus
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (9, N'Homo Deus', '9786053608530', @YuvalHarariID, @BilimID, 27.50, 60, 
        N'Hayvanlardan Tanrılara İnsan Türünün Kısa Tarihi.', '2020-01-03', '2025-12-23 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467898/wh:true/wi:220', N'Kollektif Kitap', N'Türkçe', 1);

-- Book 10: Suç ve Ceza
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (10, N'Suç ve Ceza', '9789754580103', @DostoyevskiID, @EdebiyatID, 135.00, 110, 
        N'Dostoyevski''nin başyapıtı.', '2020-01-02', '2025-12-27 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467899/wh:true/wi:220', N'Akyüz Yayınları', N'Türkçe', 1);

-- Book 11: Tutunamayanlar
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (11, N'Tutunamayanlar', '9789754701114', @OguzAtayID, @EdebiyatID, 45.00, 50, 
        N'Türk edebiyatının önemli romanı.', '2020-01-03', '2025-12-20 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467900/wh:true/wi:220', N'Can Yayınları', N'Türkçe', 1);

-- Book 12: Bir Ömür Nasıl Yaşanır
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (12, N'Bir Ömür Nasıl Yaşanır', '9789750735115', @IlberOrtayliID, @TarihID, 20.00, 200, 
        N'İlber Ortaylı''nın yaşam önerileri.', '2025-05-05', '2025-12-27 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467901/wh:true/wi:220', N'Kronik Kitap', N'Türkçe', 1);

-- Book 13: Gazi Mustafa Kemal Atatürk
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (13, N'Gazi Mustafa Kemal Atatürk', '9789750735130', @IlberOrtayliID, @TarihID, 20.00, 100, 
        N'Atatürk''ün hayatı ve eserleri.', '2018-09-05', '2025-12-24 10:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467902/wh:true/wi:220', N'Kronik Kitap', N'Türkçe', 1);

-- Book 14: Harry Potter ve Felsefe Taşı
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (14, N'Harry Potter ve Felsefe Taşı', '9789750800234', @JKRowlingID, @CocukID, 15.00, 60, 
        N'Harry''nin büyülü dünyası.', '2023-02-10', '2025-12-21 11:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467903/wh:true/wi:220', N'Yapı Kredi Yayınları', N'İngilizce', 1);

-- Book 15: Bebek Gemi
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (15, N'Bebek Gemi', '9789751001507', @ResatNuriID, @EdebiyatID, 20.00, 50, 
        N'Reşat Nuri''nin romanı.', '2025-02-09', '2025-12-22 12:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467904/wh:true/wi:220', N'Can Yayınları', N'Türkçe', 1);

-- Book 16: Koca Deve
INSERT INTO Books (BookID, Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language, SellerID)
VALUES (16, N'Koca Deve', '9789751007581', @OrhanPamukID, @EdebiyatID, 39.00, 40, 
        N'Orhan Pamuk''un romanı.', '2020-03-07', '2025-12-23 12:00:00', 
        'https://img.kitapyurdu.com/v1/getImage/fn:11467905/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe', 1);

SET IDENTITY_INSERT Books OFF;

PRINT '✓ 16 books inserted';
PRINT '';

-- STEP 5: ADD REVIEWS AND RATINGS
PRINT 'Step 5: Adding reviews and ratings...';

-- Get first user ID for reviews
DECLARE @UserID INT = (SELECT TOP 1 UserID FROM Users WHERE Role = 'Customer');
IF @UserID IS NULL SET @UserID = 1;

-- Reviews for Book 1: Kürk Mantolu Madonna
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(1, @UserID, 5, N'Muhteşem bir aşk hikayesi. Sabahattin Ali''nin en iyi eserlerinden biri.', '2025-12-20 14:30:00'),
(1, @UserID, 5, N'Her okuduğumda yeniden etkileniyorum. Kesinlikle okunmalı!', '2025-12-21 10:15:00'),
(1, @UserID, 4, N'Çok güzel bir roman ama sonu biraz hüzünlü.', '2025-12-22 16:45:00'),
(1, @UserID, 5, N'Türk edebiyatının başyapıtlarından. Harika!', '2025-12-23 09:20:00');

-- Reviews for Book 2: Kuyucaklı Yusuf
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(2, @UserID, 5, N'Yaşar Kemal''in en güzel romanlarından. Akıcı ve etkileyici.', '2025-12-19 11:00:00'),
(2, @UserID, 4, N'Çok beğendim ama biraz uzun geldi.', '2025-12-20 15:30:00'),
(2, @UserID, 5, N'Mükemmel bir eser. Kesinlikle tavsiye ederim.', '2025-12-22 13:45:00');

-- Reviews for Book 3: İçimizdeki Şeytan
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(3, @UserID, 5, N'Sabahattin Ali''nin öykülerini çok seviyorum. Bu kitap da harika.', '2025-12-18 10:20:00'),
(3, @UserID, 4, N'Güzel öyküler ama bazıları biraz ağır.', '2025-12-21 14:10:00'),
(3, @UserID, 5, N'Her öykü ayrı bir başyapıt. Muhteşem!', '2025-12-23 11:30:00');

-- Reviews for Book 4: 1984
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(4, @UserID, 5, N'Distopya edebiyatının en iyilerinden. Kesinlikle okunmalı.', '2025-12-17 09:15:00'),
(4, @UserID, 5, N'Günümüzde bile geçerliliğini koruyor. Harika bir eser.', '2025-12-19 16:40:00'),
(4, @UserID, 4, N'Çok iyi ama biraz karanlık bir atmosferi var.', '2025-12-21 12:25:00'),
(4, @UserID, 5, N'George Orwell''in başyapıtı. Mükemmel!', '2025-12-23 10:50:00');

-- Reviews for Book 5: Serenad
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(5, @UserID, 4, N'Güzel bir roman. Zülfü Livaneli''nin tarzını seviyorum.', '2025-12-20 13:20:00'),
(5, @UserID, 5, N'Çok etkileyici bir hikaye. Kesinlikle tavsiye ederim.', '2025-12-22 15:10:00'),
(5, @UserID, 4, N'İyi bir eser ama beklediğim kadar beğenmedim.', '2025-12-23 09:45:00');

-- Reviews for Book 6: Huzursuzluk
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(6, @UserID, 5, N'İnsanın iç dünyasını çok güzel anlatmış. Harika bir roman.', '2025-12-18 14:30:00'),
(6, @UserID, 4, N'Güzel ama biraz ağır bir anlatımı var.', '2025-12-20 11:15:00'),
(6, @UserID, 5, N'Çok beğendim. Zülfü Livaneli''nin en iyi eserlerinden.', '2025-12-22 16:20:00');

-- Reviews for Book 7: Bilinmeyen Bir Kadının Mektubu
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(7, @UserID, 5, N'Stefan Zweig''ın en güzel eserlerinden. Çok duygusal.', '2025-12-19 10:40:00'),
(7, @UserID, 5, N'Kısa ama çok etkileyici. Kesinlikle okunmalı.', '2025-12-21 13:55:00'),
(7, @UserID, 4, N'Güzel bir hikaye ama biraz kısa geldi.', '2025-12-23 12:10:00');

-- Reviews for Book 8: Hayvan Çiftliği
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(8, @UserID, 5, N'Alegorik bir başyapıt. George Orwell harika bir yazar.', '2025-12-17 15:20:00'),
(8, @UserID, 5, N'Çok güzel bir eser. Günümüzde bile geçerli.', '2025-12-20 09:30:00'),
(8, @UserID, 4, N'İyi ama 1984 kadar beğenmedim.', '2025-12-22 14:45:00');

-- Reviews for Book 9: Homo Deus
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(9, @UserID, 5, N'Yuval Harari''nin en iyi kitaplarından. Çok bilgilendirici.', '2025-12-18 11:15:00'),
(9, @UserID, 4, N'Güzel ama Sapiens kadar beğenmedim.', '2025-12-20 16:30:00'),
(9, @UserID, 5, N'Geleceğe dair çok güzel öngörüler. Harika!', '2025-12-22 10:20:00');

-- Reviews for Book 10: Suç ve Ceza
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(10, @UserID, 5, N'Dostoyevski''nin başyapıtı. Kesinlikle okunmalı.', '2025-12-17 13:40:00'),
(10, @UserID, 5, N'Psikolojik derinliği çok etkileyici. Mükemmel!', '2025-12-19 15:25:00'),
(10, @UserID, 4, N'Çok iyi ama biraz uzun.', '2025-12-21 11:50:00'),
(10, @UserID, 5, N'Dünya edebiyatının klasiklerinden. Harika!', '2025-12-23 14:15:00');

-- Reviews for Book 11: Tutunamayanlar
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(11, @UserID, 5, N'Türk edebiyatının en önemli romanlarından. Muhteşem!', '2025-12-18 09:30:00'),
(11, @UserID, 4, N'Çok iyi ama anlaması biraz zor.', '2025-12-20 14:45:00'),
(11, @UserID, 5, N'Oğuz Atay''ın başyapıtı. Kesinlikle okunmalı.', '2025-12-22 12:20:00');

-- Reviews for Book 12: Bir Ömür Nasıl Yaşanır
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(12, @UserID, 5, N'İlber Ortaylı''nın en güzel kitaplarından. Çok faydalı.', '2025-12-19 11:20:00'),
(12, @UserID, 5, N'Hayata dair çok güzel öğütler. Harika!', '2025-12-21 15:40:00'),
(12, @UserID, 4, N'Güzel ama bazı bölümler biraz tekrarlı.', '2025-12-23 10:15:00');

-- Reviews for Book 13: Gazi Mustafa Kemal Atatürk
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(13, @UserID, 5, N'Atatürk''ü daha iyi tanımak için harika bir kaynak.', '2025-12-18 13:50:00'),
(13, @UserID, 5, N'Çok bilgilendirici. Kesinlikle okunmalı.', '2025-12-20 10:25:00'),
(13, @UserID, 4, N'İyi ama biraz kısa geldi.', '2025-12-22 16:10:00');

-- Reviews for Book 14: Harry Potter ve Felsefe Taşı
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(14, @UserID, 5, N'Çocukluğumun en güzel kitabı. Hala okuyorum.', '2025-12-17 14:20:00'),
(14, @UserID, 5, N'Büyülü bir dünya. J.K. Rowling harika bir yazar.', '2025-12-19 12:35:00'),
(14, @UserID, 5, N'Her yaştan okuyucu için mükemmel. Harika!', '2025-12-21 09:50:00'),
(14, @UserID, 4, N'Çok güzel ama çocuklar için daha uygun.', '2025-12-23 15:25:00');

-- Reviews for Book 15: Bebek Gemi
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(15, @UserID, 4, N'Güzel bir roman. Reşat Nuri''nin tarzını seviyorum.', '2025-12-19 10:15:00'),
(15, @UserID, 5, N'Çok etkileyici bir hikaye. Kesinlikle tavsiye ederim.', '2025-12-21 14:30:00'),
(15, @UserID, 4, N'İyi ama Çalıkuşu kadar beğenmedim.', '2025-12-23 11:45:00');

-- Reviews for Book 16: Koca Deve
INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
VALUES 
(16, @UserID, 5, N'Orhan Pamuk''un en güzel romanlarından. Harika!', '2025-12-18 15:40:00'),
(16, @UserID, 4, N'Güzel ama biraz ağır bir anlatımı var.', '2025-12-20 12:55:00'),
(16, @UserID, 5, N'Çok beğendim. Kesinlikle okunmalı.', '2025-12-22 09:20:00');

PRINT '✓ Reviews and ratings added';
PRINT '';

-- STEP 6: VERIFY RESULTS
PRINT '========================================';
PRINT 'RESTORATION COMPLETE!';
PRINT '========================================';
PRINT '';

SELECT COUNT(*) AS TotalBooks FROM Books;
SELECT COUNT(*) AS TotalReviews FROM Reviews;

PRINT '';
PRINT 'Book Summary:';
SELECT 
    b.BookID,
    b.Title,
    b.Publisher,
    b.Price,
    b.StockQuantity,
    AVG(CAST(r.Rating AS FLOAT)) AS AvgRating,
    COUNT(r.ReviewID) AS ReviewCount
FROM Books b
LEFT JOIN Reviews r ON b.BookID = r.BookID
GROUP BY b.BookID, b.Title, b.Publisher, b.Price, b.StockQuantity
ORDER BY b.BookID;

GO
