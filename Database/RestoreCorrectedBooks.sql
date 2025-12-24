-- =============================================
-- RESTORE CORRECTED BOOKS - COMPLETE RESTORATION
-- Restores all corrected books with full details
-- Based on the user's corrected book list
-- =============================================

USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Düzeltilmiş Kitaplar Geri Yükleniyor...';
PRINT '========================================';
PRINT '';

-- 1. ENSURE ALL NECESSARY CATEGORIES EXIST
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

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Psikoloji')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Psikoloji', N'Psikoloji kitapları');

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Kişisel Gelişim')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Kişisel Gelişim', N'Kişisel gelişim kitapları');

PRINT '✓ Kategoriler kontrol edildi';

-- Get Category IDs
DECLARE @EdebiyatID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Edebiyat');
DECLARE @TarihID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Tarih');
DECLARE @BilimID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Bilim');
DECLARE @FelsefeID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Felsefe');
DECLARE @CocukID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Çocuk ve Gençlik');
DECLARE @PsikolojiID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Psikoloji');
DECLARE @KisiselGelisimID INT = (SELECT TOP 1 CategoryID FROM Categories WHERE CategoryName = N'Kişisel Gelişim');

-- 2. ENSURE ALL AUTHORS EXIST
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Sabahattin', N'Ali', N'Türk edebiyatının önemli öykü ve roman yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Yaşar' AND LastName = N'Kemal')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yaşar', N'Kemal', N'Türk edebiyatının ünlü romancısı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Sabahattin', N'Ali', N'Türk edebiyatının önemli yazarı');

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

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Can' AND LastName = N'Yayınları')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Can', N'Yayınları', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'J.K.', N'Rowling', N'İngiliz yazar, Harry Potter serisinin yazarı');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Yalvaç' AND LastName = N'Ural')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yalvaç', N'Ural', N'Türk yazar');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Akyüz' AND LastName = N'Yayınları')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Akyüz', N'Yayınları', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Can' AND LastName = N'Yayınları')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Can', N'Yayınları', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Yapı Kredi' AND LastName = N'Yayınları')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Yapı Kredi', N'Yayınları', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'İletişim' AND LastName = N'Yayınları')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'İletişim', N'Yayınları', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Kırmızı' AND LastName = N'Kedi')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Kırmızı', N'Kedi', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Türkiye' AND LastName = N'İş Bankası')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Türkiye', N'İş Bankası', N'Yayınevi');

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Kollektif' AND LastName = N'Kitap')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Kollektif', N'Kitap', N'Yayınevi');

PRINT '✓ Yazarlar kontrol edildi';

-- Get Author IDs
DECLARE @SabahattinAliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali');
DECLARE @YasarKemalID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yaşar' AND LastName = N'Kemal');
DECLARE @GeorgeOrwellID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell');
DECLARE @ZulfuLivaneliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Zülfü' AND LastName = N'Livaneli');
DECLARE @OguzAtayID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Oğuz' AND LastName = N'Atay');
DECLARE @StefanZweigID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Stefan' AND LastName = N'Zweig');
DECLARE @YuvalHarariID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yuval Noah' AND LastName = N'Harari');
DECLARE @DostoyevskiID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Fyodor' AND LastName = N'Dostoyevski');
DECLARE @IlberOrtayliID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı');
DECLARE @CanYayinlariID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Can' AND LastName = N'Yayınları');
DECLARE @JKRowlingID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling');
DECLARE @YalvacUralID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yalvaç' AND LastName = N'Ural');
DECLARE @AkyuzYayinlariID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Akyüz' AND LastName = N'Yayınları');
DECLARE @YapiKrediID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Yapı Kredi' AND LastName = N'Yayınları');
DECLARE @IletisimID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'İletişim' AND LastName = N'Yayınları');
DECLARE @KirmiziKediID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Kırmızı' AND LastName = N'Kedi');
DECLARE @IsBankasiID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Türkiye' AND LastName = N'İş Bankası');
DECLARE @KollektifID INT = (SELECT TOP 1 AuthorID FROM Authors WHERE FirstName = N'Kollektif' AND LastName = N'Kitap');

-- 3. INSERT/UPDATE ALL CORRECTED BOOKS WITH FULL DETAILS

-- Book 1: Kürk Mantolu Madonna
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789753638029')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Kürk Mantolu Madonna', '9789753638029', @YapiKrediID, @EdebiyatID, 50.00, 110, 
            N'Bir sanatçı ile bir kadın arasındaki tutkulu aşk hikayesi.', '2019-02-09', '2025-12-23 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe');
    PRINT '✓ Kürk Mantolu Madonna eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Kürk Mantolu Madonna',
        AuthorID = @YapiKrediID,
        CategoryID = @EdebiyatID,
        Price = 50.00,
        StockQuantity = 110,
        Description = N'Bir sanatçı ile bir kadın arasındaki tutkulu aşk hikayesi.',
        PublishedDate = '2019-02-09',
        ImageURL = 'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220',
        Publisher = N'Yapı Kredi Yayınları',
        Language = N'Türkçe'
    WHERE ISBN = '9789753638029';
    PRINT '✓ Kürk Mantolu Madonna güncellendi';
END

-- Book 2: Kuyucaklı Yusuf
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789753638036')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Kuyucaklı Yusuf', '9789753638036', @YapiKrediID, @EdebiyatID, 180.00, 85, 
            N'Bir mücadele romanı.', '2019-02-09', '2025-12-22 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe');
    PRINT '✓ Kuyucaklı Yusuf eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Kuyucaklı Yusuf',
        AuthorID = @YapiKrediID,
        Price = 180.00,
        StockQuantity = 85
    WHERE ISBN = '9789753638036';
    PRINT '✓ Kuyucaklı Yusuf güncellendi';
END

-- Book 3: İçimizdeki Şeytan
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789753639043')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'İçimizdeki Şeytan', '9789753639043', @SabahattinAliID, @EdebiyatID, 29.00, 60, 
            N'Sabahattin Ali''nin öyküleri.', '2020-02-03', '2025-12-23 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe');
    PRINT '✓ İçimizdeki Şeytan eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'İçimizdeki Şeytan',
        Price = 29.00,
        StockQuantity = 60
    WHERE ISBN = '9789753639043';
    PRINT '✓ İçimizdeki Şeytan güncellendi';
END

-- Book 4: 1984
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750115153')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'1984', '9789750115153', @CanYayinlariID, @EdebiyatID, 27.50, 200, 
            N'George Orwell''in distopya klasiği.', '2021-09-01', '2025-12-22 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Can Yayınları', N'Türkçe');
    PRINT '✓ 1984 eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'1984',
        Price = 27.50,
        StockQuantity = 200
    WHERE ISBN = '9789750115153';
    PRINT '✓ 1984 güncellendi';
END

-- Book 5: Serenad
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9786020000526')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Serenad', '9786020000526', @IletisimID, @EdebiyatID, 32.00, 120, 
            N'Ömür Öymen''in romanı.', '2025-12-31', '2025-12-28 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'İletişim Yayınları', N'Türkçe');
    PRINT '✓ Serenad eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Serenad',
        Price = 32.00,
        StockQuantity = 120
    WHERE ISBN = '9786020000526';
    PRINT '✓ Serenad güncellendi';
END

-- Book 6: Huzursuzluk
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9786050053866')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Huzursuzluk', '9786050053866', @IletisimID, @EdebiyatID, 55.00, 90, 
            N'İlhami Algör''ün romanı.', '2020-01-02', '2025-12-23 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'İletişim Yayınları', N'Türkçe');
    PRINT '✓ Huzursuzluk eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Huzursuzluk',
        Price = 55.00,
        StockQuantity = 90
    WHERE ISBN = '9786050053866';
    PRINT '✓ Huzursuzluk güncellendi';
END

-- Book 7: Bilinmeyen Bir Kadının Mektubu
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789752100247')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Bilinmeyen Bir Kadının Mektubu', '9789752100247', @IsBankasiID, @EdebiyatID, 10.00, 140, 
            N'Stefan Zweig''ın duygusal romanı.', '2025-05-02', '2025-12-23 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Türkiye İş Bankası', N'Türkçe');
    PRINT '✓ Bilinmeyen Bir Kadının Mektubu eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Bilinmeyen Bir Kadının Mektubu',
        Price = 10.00,
        StockQuantity = 140
    WHERE ISBN = '9789752100247';
    PRINT '✓ Bilinmeyen Bir Kadının Mektubu güncellendi';
END

-- Book 8: Hayvan Çiftliği
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9786050026637')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Hayvan Çiftliği', '9786050026637', @CanYayinlariID, @FelsefeID, 120.00, 75, 
            N'İngiliz yazar George Orwell''in alegorik romanı.', '2019-01-09', '2025-12-22 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Can Yayınları', N'Türkçe');
    PRINT '✓ Hayvan Çiftliği eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Hayvan Çiftliği',
        Price = 120.00,
        StockQuantity = 75
    WHERE ISBN = '9786050026637';
    PRINT '✓ Hayvan Çiftliği güncellendi';
END

-- Book 9: Homo Deus
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9786053608530')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Homo Deus', '9786053608530', @KollektifID, @BilimID, 27.50, 60, 
            N'Hayvanlardan Tanrılara İnsan Türünün Kısa Tarihi.', '2020-01-03', '2025-12-23 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Kollektif Kitap', N'Türkçe');
    PRINT '✓ Homo Deus eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Homo Deus',
        Price = 27.50,
        StockQuantity = 60
    WHERE ISBN = '9786053608530';
    PRINT '✓ Homo Deus güncellendi';
END

-- Book 10: Suç ve Ceza
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789754580103')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Suç ve Ceza', '9789754580103', @AkyuzYayinlariID, @EdebiyatID, 135.00, 110, 
            N'Kendinden menkul bir genç adam.', '2020-01-02', '2025-12-27 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Akyüz Yayınları', N'Türkçe');
    PRINT '✓ Suç ve Ceza eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Suç ve Ceza',
        Price = 135.00,
        StockQuantity = 110
    WHERE ISBN = '9789754580103';
    PRINT '✓ Suç ve Ceza güncellendi';
END

-- Book 11: Tutunamayanlar
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789754701114')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Tutunamayanlar', '9789754701114', @CanYayinlariID, @EdebiyatID, 45.00, 50, 
            N'Türk edebiyatının önemli romanı.', '2020-01-03', '2025-12-20 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Can Yayınları', N'Türkçe');
    PRINT '✓ Tutunamayanlar eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Tutunamayanlar',
        Price = 45.00,
        StockQuantity = 50
    WHERE ISBN = '9789754701114';
    PRINT '✓ Tutunamayanlar güncellendi';
END

-- Book 12: Bir Ömür Nasıl Yaşanır
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750735115')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Bir Ömür Nasıl Yaşanır', '9789750735115', @IlberOrtayliID, @TarihID, 20.00, 200, 
            N'DANIKIN ANA AMACI Yaşamın Anlamı.', '2025-05-05', '2025-12-27 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Kronik Kitap', N'Türkçe');
    PRINT '✓ Bir Ömür Nasıl Yaşanır eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Bir Ömür Nasıl Yaşanır',
        Price = 20.00,
        StockQuantity = 200
    WHERE ISBN = '9789750735115';
    PRINT '✓ Bir Ömür Nasıl Yaşanır güncellendi';
END

-- Book 13: Gazi Mustafa Kemal Atatürk
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750735130')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Gazi Mustafa Kemal Atatürk', '9789750735130', @IlberOrtayliID, @TarihID, 20.00, 100, 
            N'YOKSAYIN ÖLÜM Bir Öğrenci Hatırasından.', '2018-09-05', '2025-12-24 10:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Kronik Kitap', N'Türkçe');
    PRINT '✓ Gazi Mustafa Kemal Atatürk eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Gazi Mustafa Kemal Atatürk',
        Price = 20.00,
        StockQuantity = 100
    WHERE ISBN = '9789750735130';
    PRINT '✓ Gazi Mustafa Kemal Atatürk güncellendi';
END

-- Book 14: Harry Potter ve Felsefe Taşı
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800234')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Harry Potter ve Felsefe Taşı', '9789750800234', @YapiKrediID, @CocukID, 15.00, 60, 
            N'Harry''nin büyülü dünyası.', '2023-02-10', '2025-12-21 11:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'İngilizce');
    PRINT '✓ Harry Potter ve Felsefe Taşı eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Harry Potter ve Felsefe Taşı',
        Price = 15.00,
        StockQuantity = 60
    WHERE ISBN = '9789750800234';
    PRINT '✓ Harry Potter ve Felsefe Taşı güncellendi';
END

-- Book 15: Bebek Gemi
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789751001507')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Bebek Gemi', '9789751001507', @CanYayinlariID, @EdebiyatID, 20.00, 50, 
            N'Polisiye Selim''in Macerası.', '2025-02-09', '2025-12-22 12:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Can Yayınları', N'Türkçe');
    PRINT '✓ Bebek Gemi eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Bebek Gemi',
        Price = 20.00,
        StockQuantity = 50
    WHERE ISBN = '9789751001507';
    PRINT '✓ Bebek Gemi güncellendi';
END

-- Book 16: Koca Deve
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789751007581')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, CreatedDate, ImageURL, Publisher, Language)
    VALUES (N'Koca Deve', '9789751007581', @YapiKrediID, @EdebiyatID, 39.00, 40, 
            N'Ömer İnci bir romanı.', '2020-03-07', '2025-12-23 12:00:00', 
            'https://img.kitapyurdu.com/v1/getImage/fn:11467890/wh:true/wi:220', N'Yapı Kredi Yayınları', N'Türkçe');
    PRINT '✓ Koca Deve eklendi';
END
ELSE
BEGIN
    UPDATE Books SET 
        Title = N'Koca Deve',
        Price = 39.00,
        StockQuantity = 40
    WHERE ISBN = '9789751007581';
    PRINT '✓ Koca Deve güncellendi';
END

-- 4. FIX ANY REMAINING CHARACTER ENCODING ISSUES
UPDATE Books SET Title = REPLACE(Title, 'Ã‡', 'Ç');
UPDATE Books SET Title = REPLACE(Title, 'ÄŸ', 'ğ');
UPDATE Books SET Title = REPLACE(Title, 'Ä±', 'ı');
UPDATE Books SET Title = REPLACE(Title, 'Ã¶', 'ö');
UPDATE Books SET Title = REPLACE(Title, 'Ã¼', 'ü');
UPDATE Books SET Title = REPLACE(Title, 'ÅŸ', 'ş');
UPDATE Books SET Title = REPLACE(Title, 'Ä°', 'İ');
UPDATE Books SET Title = REPLACE(Title, 'Ã–', 'Ö');
UPDATE Books SET Title = REPLACE(Title, 'Ãœ', 'Ü');

UPDATE Books SET Description = REPLACE(Description, 'Ã‡', 'Ç');
UPDATE Books SET Description = REPLACE(Description, 'ÄŸ', 'ğ');
UPDATE Books SET Description = REPLACE(Description, 'Ä±', 'ı');
UPDATE Books SET Description = REPLACE(Description, 'Ã¶', 'ö');
UPDATE Books SET Description = REPLACE(Description, 'Ã¼', 'ü');
UPDATE Books SET Description = REPLACE(Description, 'ÅŸ', 'ş');

-- 5. ENSURE ALL BOOKS HAVE SELLER ID
UPDATE Books SET SellerID = 1 WHERE SellerID IS NULL;

PRINT '';
PRINT '========================================';
PRINT '✓ TÜM DÜZELTİLMİŞ KİTAPLAR GERİ YÜKLENDİ!';
PRINT '========================================';

-- Show total book count
SELECT COUNT(*) AS ToplamKitapSayisi FROM Books;

-- Show the restored books
SELECT BookID, Title, ISBN, Price, StockQuantity, Publisher, Language 
FROM Books 
WHERE ISBN IN (
    '9789753638029', '9789753638036', '9789753639043', '9789750115153',
    '9786020000526', '9786050053866', '9789752100247', '9786050026637',
    '9786053608530', '9789754580103', '9789754701114', '9789750735115',
    '9789750735130', '9789750800234', '9789751001507', '9789751007581'
)
ORDER BY BookID;

GO
