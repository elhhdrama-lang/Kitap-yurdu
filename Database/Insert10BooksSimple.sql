-- =============================================
-- 10 Kitap Ekleme Script'i (Basit Versiyon)
-- Eğer kitaplar yoksa, bu script onları ekler
-- =============================================

USE KitapyurduDB;
GO

PRINT '========================================';
PRINT '10 Kitap ekleniyor...';
PRINT '========================================';
PRINT '';

-- Önce kategorileri ekle (eğer yoksa)
IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Roman')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Roman', 'Roman türü kitaplar');
    PRINT '✓ Roman kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Biyografi')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Biyografi', 'Biyografi kitapları');
    PRINT '✓ Biyografi kategorisi eklendi';
END
GO

-- Yazarları ekle (eğer yoksa)
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Yaşar', 'Kemal', 'Türk edebiyatının önemli yazarlarından biri');
    PRINT '✓ Yaşar Kemal eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Orhan', 'Pamuk', 'Nobel Edebiyat Ödülü sahibi Türk yazar');
    PRINT '✓ Orhan Pamuk eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Elif' AND LastName = 'Şafak')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Elif', 'Şafak', 'Çağdaş Türk edebiyatının önemli yazarlarından');
    PRINT '✓ Elif Şafak eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Halide Edip' AND LastName = 'Adıvar')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Halide Edip', 'Adıvar', 'Türk edebiyatının önemli kadın yazarlarından');
    PRINT '✓ Halide Edip Adıvar eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Nazım' AND LastName = 'Hikmet')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Nazım', 'Hikmet', 'Türk şiirinin büyük ustası');
    PRINT '✓ Nazım Hikmet eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Ahmet' AND LastName = 'Ümit')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Ahmet', 'Ümit', 'Türk polisiye roman yazarı');
    PRINT '✓ Ahmet Ümit eklendi';
END
GO

-- Şimdi kitapları ekle (ID'leri dinamik olarak al)
DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman');
DECLARE @BiyografiID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Biyografi');
DECLARE @YasarKemalID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal');
DECLARE @OrhanPamukID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk');
DECLARE @ElifSafakID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Elif' AND LastName = 'Şafak');
DECLARE @HalideEdipID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Halide Edip' AND LastName = 'Adıvar');
DECLARE @NazimHikmetID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Nazım' AND LastName = 'Hikmet');
DECLARE @AhmetUmitID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Ahmet' AND LastName = 'Ümit');

-- Kitap 1: İnce Memed
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750806621')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('İnce Memed', '9789750806621', @YasarKemalID, @RomanID, 45.90, 50, 
            'Yaşar Kemal''in ünlü eseri. Çukurova''da geçen destansı bir hikaye.', '1955-01-01');
    PRINT '✓ İnce Memed eklendi';
END

-- Kitap 2: Kara Kitap
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750810154')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Kara Kitap', '9789750810154', @OrhanPamukID, @RomanID, 52.50, 40,
            'Orhan Pamuk''un İstanbul''da geçen gizemli romanı.', '1990-01-01');
    PRINT '✓ Kara Kitap eklendi';
END

-- Kitap 3: Aşk
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750809547')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Aşk', '9789750809547', @ElifSafakID, @RomanID, 48.90, 60,
            'Elif Şafak''ın mistik ve modern bir aşk hikayesi.', '2009-01-01');
    PRINT '✓ Aşk eklendi';
END

-- Kitap 4: Sinekli Bakkal
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750808953')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Sinekli Bakkal', '9789750808953', @HalideEdipID, @RomanID, 38.50, 35,
            'Halide Edip Adıvar''ın Osmanlı dönemini anlatan romanı.', '1936-01-01');
    PRINT '✓ Sinekli Bakkal eklendi';
END

-- Kitap 5: Memleketimden İnsan Manzaraları
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750809066')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Memleketimden İnsan Manzaraları', '9789750809066', @NazimHikmetID, @RomanID, 55.00, 30,
            'Nazım Hikmet''in destansı eseri.', '1966-01-01');
    PRINT '✓ Memleketimden İnsan Manzaraları eklendi';
END

-- Kitap 6: Beyaz Gemi
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750809240')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Beyaz Gemi', '9789750809240', @YasarKemalID, @RomanID, 42.00, 45,
            'Yaşar Kemal''in doğa ve insan ilişkisini anlatan eseri.', '1970-01-01');
    PRINT '✓ Beyaz Gemi eklendi';
END

-- Kitap 7: Benim Adım Kırmızı
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750810123')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Benim Adım Kırmızı', '9789750810123', @OrhanPamukID, @RomanID, 58.90, 50,
            'Orhan Pamuk''un Osmanlı minyatür sanatını konu alan polisiye romanı.', '1998-01-01');
    PRINT '✓ Benim Adım Kırmızı eklendi';
END

-- Kitap 8: Babamın Bavulu
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750810345')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Babamın Bavulu', '9789750810345', @OrhanPamukID, @BiyografiID, 35.90, 25,
            'Orhan Pamuk''un Nobel konuşması ve denemeleri.', '2007-01-01');
    PRINT '✓ Babamın Bavulu eklendi';
END

-- Kitap 9: İstanbul: Hatıralar ve Şehir
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750810567')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('İstanbul: Hatıralar ve Şehir', '9789750810567', @OrhanPamukID, @BiyografiID, 49.90, 40,
            'Orhan Pamuk''un İstanbul''a dair hatıraları ve gözlemleri.', '2003-01-01');
    PRINT '✓ İstanbul: Hatıralar ve Şehir eklendi';
END

-- Kitap 10: Patasana
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750809782')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Patasana', '9789750809782', @AhmetUmitID, @RomanID, 46.90, 55,
            'Ahmet Ümit''in arkeoloji ve mitolojiyi buluşturan polisiye romanı.', '2000-01-01');
    PRINT '✓ Patasana eklendi';
END

GO

PRINT '';
PRINT '========================================';
PRINT 'İşlem tamamlandı!';
PRINT '========================================';

-- Sonuçları göster
SELECT 
    COUNT(*) AS ToplamKitap
FROM Books;
GO

