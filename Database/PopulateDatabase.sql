-- =============================================
-- VERİTABANI VERİ DOLDURMA SCRIPT'İ
-- kitapyuduDB veritabanını gerçekçi verilerle doldurur
-- =============================================

USE kitapyuduDB;
GO

PRINT '========================================';
PRINT 'Veritabanı Veri Doldurma Başlıyor...';
PRINT '========================================';
GO

-- =============================================
-- KATEGORİLER
-- =============================================
IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Roman')
BEGIN
    INSERT INTO Categories (CategoryName, Description) VALUES
    ('Roman', 'Roman türü kitaplar'),
    ('Bilim Kurgu', 'Bilim kurgu türü kitaplar'),
    ('Tarih', 'Tarih kitapları'),
    ('Felsefe', 'Felsefe kitapları'),
    ('Biyografi', 'Biyografi kitapları'),
    ('Çocuk Kitapları', 'Çocuklar için kitaplar'),
    ('Şiir', 'Şiir kitapları'),
    ('Psikoloji', 'Psikoloji kitapları'),
    ('Ekonomi', 'Ekonomi kitapları'),
    ('Teknoloji', 'Teknoloji ve programlama kitapları');
    PRINT '✓ Kategoriler eklendi';
END
GO

-- =============================================
-- YAZARLAR
-- =============================================
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Orhan' AND LastName = 'Pamuk')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES
    ('Orhan', 'Pamuk', 'Nobel Edebiyat Ödülü sahibi Türk yazar'),
    ('Isaac', 'Asimov', 'Ünlü bilim kurgu yazarı'),
    ('Halil', 'İnalcık', 'Türk tarihçi ve akademisyen'),
    ('Platon', 'Antik', 'Antik Yunan filozofu'),
    ('Mustafa', 'Kemal', 'Türkiye Cumhuriyeti''nin kurucusu'),
    ('Yaşar', 'Kemal', 'Türk edebiyatının büyük yazarı'),
    ('Sabahattin', 'Ali', 'Türk edebiyatının önemli yazarlarından'),
    ('Elif', 'Şafak', 'Çağdaş Türk yazarı'),
    ('Ahmet', 'Ümit', 'Polisiye roman yazarı'),
    ('Zülfü', 'Livaneli', 'Yazar, müzisyen ve siyasetçi'),
    ('J.K.', 'Rowling', 'Harry Potter serisinin yazarı'),
    ('George', 'Orwell', '1984 ve Hayvan Çiftliği yazarı'),
    ('Fyodor', 'Dostoyevski', 'Rus edebiyatının büyük yazarı'),
    ('Lev', 'Tolstoy', 'Savaş ve Barış yazarı'),
    ('Friedrich', 'Nietzsche', 'Alman filozof'),
    ('Sigmund', 'Freud', 'Psikanalizin kurucusu'),
    ('Daniel', 'Kahneman', 'Nobel ödüllü psikolog ve ekonomist'),
    ('Yuval', 'Harari', 'Sapiens yazarı'),
    ('Bill', 'Gates', 'Microsoft''un kurucusu'),
    ('Steve', 'Jobs', 'Apple''ın kurucusu');
    PRINT '✓ Yazarlar eklendi';
END
GO

-- =============================================
-- KİTAPLAR
-- =============================================
IF NOT EXISTS (SELECT * FROM Books WHERE Title = 'Kara Kitap')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate) VALUES
    -- Türk Edebiyatı
    ('Kara Kitap', '9789750807567', 1, 1, 45.00, 50, 'Orhan Pamuk''un ünlü romanı', '1990-01-01'),
    ('Benim Adım Kırmızı', '9789750807574', 1, 1, 55.00, 30, 'Tarihi roman', '1998-01-01'),
    ('İnce Memed', '9789750807581', 6, 1, 60.00, 40, 'Yaşar Kemal''in başyapıtı', '1955-01-01'),
    ('Kürk Mantolu Madonna', '9789750807598', 7, 1, 35.00, 25, 'Sabahattin Ali''nin unutulmaz eseri', '1943-01-01'),
    ('Aşk', '9789750807604', 8, 1, 42.00, 60, 'Elif Şafak''ın çok satan romanı', '2009-01-01'),
    ('Baba ve Piç', '9789750807611', 8, 1, 48.00, 35, 'Elif Şafak romanı', '2006-01-01'),
    ('İstanbul Hatırası', '9789750807628', 9, 1, 40.00, 45, 'Ahmet Ümit polisiye romanı', '2010-01-01'),
    ('Serenad', '9789750807635', 10, 1, 38.00, 50, 'Zülfü Livaneli romanı', '2011-01-01'),
    
    -- Bilim Kurgu
    ('Vakıf Serisi', '9789750807642', 2, 2, 65.00, 40, 'Bilim kurgu klasiği', '1951-01-01'),
    ('1984', '9789750807659', 12, 2, 45.00, 55, 'Distopya klasiği', '1949-01-01'),
    ('Hayvan Çiftliği', '9789750807666', 12, 2, 30.00, 70, 'Siyasi alegori', '1945-01-01'),
    ('Harry Potter ve Felsefe Taşı', '9789750807673', 11, 2, 50.00, 80, 'Fantastik edebiyat', '1997-01-01'),
    ('Harry Potter ve Sırlar Odası', '9789750807680', 11, 2, 50.00, 75, 'Fantastik edebiyat', '1998-01-01'),
    
    -- Tarih
    ('Osmanlı Tarihi', '9789750807697', 3, 3, 75.00, 25, 'Osmanlı tarihi hakkında kapsamlı eser', '2000-01-01'),
    ('Nutuk', '9789750807703', 5, 3, 60.00, 30, 'Atatürk''ün Söylev''i', '1927-01-01'),
    ('Sapiens', '9789750807710', 18, 3, 55.00, 45, 'İnsanlığın kısa tarihi', '2011-01-01'),
    ('Homo Deus', '9789750807727', 18, 3, 58.00, 40, 'Yarının kısa tarihi', '2015-01-01'),
    
    -- Felsefe
    ('Devlet', '9789750807734', 4, 4, 35.00, 60, 'Platon''un ünlü eseri', '380-01-01'),
    ('Böyle Söyledi Zerdüşt', '9789750807741', 15, 4, 42.00, 35, 'Nietzsche''nin başyapıtı', '1883-01-01'),
    ('Suç ve Ceza', '9789750807758', 13, 4, 50.00, 50, 'Dostoyevski''nin ünlü romanı', '1866-01-01'),
    ('Savaş ve Barış', '9789750807765', 14, 4, 70.00, 20, 'Tolstoy''un başyapıtı', '1869-01-01'),
    
    -- Psikoloji
    ('Düşünme Hızı ve Yavaşlığı', '9789750807772', 17, 8, 48.00, 40, 'Kahneman''ın Nobel ödüllü eseri', '2011-01-01'),
    ('Düşlerin Yorumu', '9789750807789', 16, 8, 40.00, 30, 'Freud''un psikanaliz eseri', '1899-01-01'),
    
    -- Ekonomi
    ('Ekonomi 101', '9789750807796', 17, 9, 45.00, 35, 'Davranışsal ekonomi', '2011-01-01'),
    
    -- Teknoloji
    ('Yazılım Geliştirme Prensipleri', '9789750807802', 19, 10, 55.00, 25, 'Programlama ve yazılım geliştirme', '2020-01-01'),
    ('İnovasyon ve Girişimcilik', '9789750807819', 20, 10, 50.00, 30, 'Teknoloji ve iş dünyası', '2011-01-01'),
    
    -- Çocuk Kitapları (yeni yazarlar eklenmeli, şimdilik mevcut yazarlardan biri kullanılıyor)
    ('Küçük Prens', '9789750807826', 1, 6, 25.00, 100, 'Antoine de Saint-Exupéry''nin ünlü eseri', '1943-01-01'),
    ('Alice Harikalar Diyarında', '9789750807833', 1, 6, 28.00, 90, 'Lewis Carroll''un klasik eseri', '1865-01-01'),
    
    -- Şiir
    ('Memleketimden İnsan Manzaraları', '9789750807840', 6, 7, 35.00, 40, 'Nazım Hikmet''in şiirleri', '1966-01-01');
    PRINT '✓ Kitaplar eklendi';
END
GO

-- =============================================
-- KULLANICILAR
-- =============================================
IF NOT EXISTS (SELECT * FROM Users WHERE Username = 'admin')
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash, FirstName, LastName, Phone, Address) VALUES
    ('admin', 'admin@kitapyurdu.com', 'admin123', 'Admin', 'User', '555-0001', 'İstanbul, Türkiye'),
    ('testuser', 'test@example.com', 'test123', 'Test', 'User', '555-0002', 'Ankara, Türkiye'),
    ('ahmet', 'ahmet@example.com', 'ahmet123', 'Ahmet', 'Yılmaz', '555-0003', 'İzmir, Türkiye'),
    ('ayse', 'ayse@example.com', 'ayse123', 'Ayşe', 'Demir', '555-0004', 'Bursa, Türkiye'),
    ('mehmet', 'mehmet@example.com', 'mehmet123', 'Mehmet', 'Kaya', '555-0005', 'Antalya, Türkiye'),
    ('fatma', 'fatma@example.com', 'fatma123', 'Fatma', 'Şahin', '555-0006', 'Adana, Türkiye'),
    ('ali', 'ali@example.com', 'ali123', 'Ali', 'Çelik', '555-0007', 'Gaziantep, Türkiye'),
    ('zeynep', 'zeynep@example.com', 'zeynep123', 'Zeynep', 'Arslan', '555-0008', 'Konya, Türkiye');
    PRINT '✓ Kullanıcılar eklendi';
END
GO

-- =============================================
-- SEPET VERİLERİ (Bazı kullanıcıların sepetinde ürünler)
-- =============================================
IF NOT EXISTS (SELECT * FROM Cart)
BEGIN
    -- Kullanıcı 2 (testuser) - Sepetinde 2 kitap
    INSERT INTO Cart (UserID, BookID, Quantity) VALUES
    (2, 1, 2),  -- Kara Kitap - 2 adet
    (2, 3, 1);  -- İnce Memed - 1 adet
    
    -- Kullanıcı 3 (ahmet) - Sepetinde 3 kitap
    INSERT INTO Cart (UserID, BookID, Quantity) VALUES
    (3, 5, 1),  -- Aşk
    (3, 10, 1), -- 1984
    (3, 17, 1); -- Sapiens
    
    -- Kullanıcı 4 (ayse) - Sepetinde 1 kitap
    INSERT INTO Cart (UserID, BookID, Quantity) VALUES
    (4, 11, 2); -- Hayvan Çiftliği - 2 adet
    
    PRINT '✓ Sepet verileri eklendi';
END
GO

-- =============================================
-- SİPARİŞLER VE SİPARİŞ DETAYLARI
-- =============================================
IF NOT EXISTS (SELECT * FROM Orders)
BEGIN
    -- Kullanıcı 2'nin siparişi
    DECLARE @Order1 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (2, 95.00, 'Completed', 'Ankara, Türkiye');
    SET @Order1 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order1, 2, 1, 55.00, 55.00),  -- Benim Adım Kırmızı
    (@Order1, 4, 1, 35.00, 35.00);  -- Kürk Mantolu Madonna
    
    -- Kullanıcı 3'ün siparişi
    DECLARE @Order2 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (3, 150.00, 'Pending', 'İzmir, Türkiye');
    SET @Order2 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order2, 6, 1, 48.00, 48.00),  -- Baba ve Piç
    (@Order2, 12, 2, 50.00, 100.00); -- Harry Potter ve Felsefe Taşı - 2 adet
    
    -- Kullanıcı 4'ün siparişi
    DECLARE @Order3 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (4, 70.00, 'Completed', 'Bursa, Türkiye');
    SET @Order3 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order3, 15, 1, 60.00, 60.00), -- Nutuk
    (@Order3, 19, 1, 35.00, 35.00); -- Devlet
    
    -- Kullanıcı 5'in siparişi
    DECLARE @Order4 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (5, 125.00, 'Completed', 'Antalya, Türkiye');
    SET @Order4 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order4, 9, 1, 65.00, 65.00),  -- Vakıf Serisi
    (@Order4, 16, 1, 55.00, 55.00); -- Sapiens
    
    PRINT '✓ Siparişler ve sipariş detayları eklendi';
END
GO

-- =============================================
-- DEĞERLENDİRMELER (REVIEWS)
-- =============================================
IF NOT EXISTS (SELECT * FROM Reviews)
BEGIN
    INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate) VALUES
    (1, 2, 5, 'Harika bir kitap! Çok beğendim.', GETDATE()),
    (2, 3, 5, 'Mükemmel bir eser. Herkese tavsiye ederim.', GETDATE()),
    (3, 4, 4, 'Güzel bir roman, okumaya değer.', GETDATE()),
    (4, 5, 5, 'Çok etkileyici bir kitap.', GETDATE()),
    (5, 6, 4, 'İyi bir kitap ama biraz uzun.', GETDATE()),
    (10, 2, 5, 'Klasik bir distopya, mutlaka okunmalı.', GETDATE()),
    (11, 3, 5, 'Çok güzel bir alegori.', GETDATE()),
    (12, 4, 5, 'Harry Potter serisi muhteşem!', GETDATE()),
    (15, 5, 5, 'Tarih severler için mükemmel.', GETDATE()),
    (17, 6, 5, 'İnsanlık tarihini anlamak için harika bir kitap.', GETDATE());
    PRINT '✓ Değerlendirmeler eklendi';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'VERİTABANI VERİ DOLDURMA TAMAMLANDI!';
PRINT '========================================';
PRINT '';
PRINT 'Eklenen Veriler:';
PRINT '  ✓ 10 Kategori';
PRINT '  ✓ 20 Yazar';
PRINT '  ✓ 30+ Kitap';
PRINT '  ✓ 8 Kullanıcı';
PRINT '  ✓ Sepet verileri';
PRINT '  ✓ 4 Sipariş ve detayları';
PRINT '  ✓ 10 Değerlendirme';
PRINT '';
PRINT 'Veritabanı dolduruldu!';
PRINT '========================================';
GO

