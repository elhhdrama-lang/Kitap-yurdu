-- =============================================
-- 10 Kitap Ekleme Script'i
-- KitapyurduDB Veritabanı için
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

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Bilim Kurgu')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Bilim Kurgu', 'Bilim kurgu kitapları');
    PRINT '✓ Bilim Kurgu kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Tarih')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Tarih', 'Tarih kitapları');
    PRINT '✓ Tarih kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Biyografi')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Biyografi', 'Biyografi kitapları');
    PRINT '✓ Biyografi kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Felsefe')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES ('Felsefe', 'Felsefe kitapları');
    PRINT '✓ Felsefe kategorisi eklendi';
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

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Oktay' AND LastName = 'Sinanoğlu')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Oktay', 'Sinanoğlu', 'Türk bilim insanı ve yazar');
    PRINT '✓ Oktay Sinanoğlu eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Ahmet' AND LastName = 'Ümit')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Ahmet', 'Ümit', 'Türk polisiye roman yazarı');
    PRINT '✓ Ahmet Ümit eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'İsmail' AND LastName = 'Kadare')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('İsmail', 'Kadare', 'Arnavut yazar');
    PRINT '✓ İsmail Kadare eklendi';
END
GO

-- Kitapları ekle
-- İnce Memed - Yaşar Kemal
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'İnce Memed' AND ISBN = '9789750806621')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'İnce Memed', '9789750806621', AuthorID, 
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'), 
           45.90, 50, 
           'Yaşar Kemal''in ünlü eseri. Çukurova''da geçen destansı bir hikaye.', 
           '1955-01-01'
    FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal';
    PRINT '✓ İnce Memed eklendi';
END

-- Kara Kitap - Orhan Pamuk
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Kara Kitap' AND ISBN = '9789750810154')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Kara Kitap', '9789750810154', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           52.50, 40,
           'Orhan Pamuk''un İstanbul''da geçen gizemli romanı.',
           '1990-01-01'
    FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk';
    PRINT '✓ Kara Kitap eklendi';
END

-- Aşk - Elif Şafak
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Aşk' AND ISBN = '9789750809547')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Aşk', '9789750809547', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           48.90, 60,
           'Elif Şafak''ın mistik ve modern bir aşk hikayesi.',
           '2009-01-01'
    FROM Authors WHERE FirstName = 'Elif' AND LastName = 'Şafak';
    PRINT '✓ Aşk eklendi';
END

-- Sinekli Bakkal - Halide Edip Adıvar
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Sinekli Bakkal' AND ISBN = '9789750808953')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Sinekli Bakkal', '9789750808953', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           38.50, 35,
           'Halide Edip Adıvar''ın Osmanlı dönemini anlatan romanı.',
           '1936-01-01'
    FROM Authors WHERE FirstName = 'Halide Edip' AND LastName = 'Adıvar';
    PRINT '✓ Sinekli Bakkal eklendi';
END

-- Memleketimden İnsan Manzaraları - Nazım Hikmet
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Memleketimden İnsan Manzaraları' AND ISBN = '9789750809066')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Memleketimden İnsan Manzaraları', '9789750809066', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           55.00, 30,
           'Nazım Hikmet''in destansı eseri.',
           '1966-01-01'
    FROM Authors WHERE FirstName = 'Nazım' AND LastName = 'Hikmet';
    PRINT '✓ Memleketimden İnsan Manzaraları eklendi';
END

-- Beyaz Gemi - Yaşar Kemal
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Beyaz Gemi' AND ISBN = '9789750809240')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Beyaz Gemi', '9789750809240', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           42.00, 45,
           'Yaşar Kemal''in doğa ve insan ilişkisini anlatan eseri.',
           '1970-01-01'
    FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal';
    PRINT '✓ Beyaz Gemi eklendi';
END

-- Benim Adım Kırmızı - Orhan Pamuk
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Benim Adım Kırmızı' AND ISBN = '9789750810123')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Benim Adım Kırmızı', '9789750810123', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           58.90, 50,
           'Orhan Pamuk''un Osmanlı minyatür sanatını konu alan polisiye romanı.',
           '1998-01-01'
    FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk';
    PRINT '✓ Benim Adım Kırmızı eklendi';
END

-- Babamın Bavulu - Orhan Pamuk
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Babamın Bavulu' AND ISBN = '9789750810345')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Babamın Bavulu', '9789750810345', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Biyografi'),
           35.90, 25,
           'Orhan Pamuk''un Nobel konuşması ve denemeleri.',
           '2007-01-01'
    FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk';
    PRINT '✓ Babamın Bavulu eklendi';
END

-- İstanbul: Hatıralar ve Şehir - Orhan Pamuk
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'İstanbul: Hatıralar ve Şehir' AND ISBN = '9789750810567')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'İstanbul: Hatıralar ve Şehir', '9789750810567', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Biyografi'),
           49.90, 40,
           'Orhan Pamuk''un İstanbul''a dair hatıraları ve gözlemleri.',
           '2003-01-01'
    FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk';
    PRINT '✓ İstanbul: Hatıralar ve Şehir eklendi';
END

-- Patasana - Ahmet Ümit
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Patasana' AND ISBN = '9789750809782')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    SELECT 'Patasana', '9789750809782', AuthorID,
           (SELECT CategoryID FROM Categories WHERE CategoryName = 'Roman'),
           46.90, 55,
           'Ahmet Ümit''in arkeoloji ve mitolojiyi buluşturan polisiye romanı.',
           '2000-01-01'
    FROM Authors WHERE FirstName = 'Ahmet' AND LastName = 'Ümit';
    PRINT '✓ Patasana eklendi';
END
GO

PRINT '';
PRINT '========================================';
PRINT '10 Kitap başarıyla eklendi!';
PRINT '========================================';
GO
