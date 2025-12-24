-- =============================================
-- Daha Fazla Kitap Ekleme Script'i
-- 20 Ek Kitap Eklenecek
-- =============================================

USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Daha fazla kitap ekleniyor...';
PRINT '========================================';
PRINT '';

-- Kategorileri kontrol et ve ekle (eğer yoksa)
IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Psikoloji')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES (N'Psikoloji', N'Psikoloji kitapları');
    PRINT '✓ Psikoloji kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Kişisel Gelişim')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES (N'Kişisel Gelişim', N'Kişisel gelişim kitapları');
    PRINT '✓ Kişisel Gelişim kategorisi eklendi';
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Polisiye')
BEGIN
    INSERT INTO Categories (CategoryName, Description) 
    VALUES (N'Polisiye', N'Polisiye roman kitapları');
    PRINT '✓ Polisiye kategorisi eklendi';
END
GO

-- Yazarları ekle (eğer yoksa)
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Sabahattin', N'Ali', N'Türk edebiyatının önemli öykü ve roman yazarı');
    PRINT '✓ Sabahattin Ali eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Reşat Nuri', N'Güntekin', N'Türk edebiyatının ünlü romancısı');
    PRINT '✓ Reşat Nuri Güntekin eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Peyami' AND LastName = N'Safa')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Peyami', N'Safa', N'Türk romancı ve hikayeci');
    PRINT '✓ Peyami Safa eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Hakan' AND LastName = N'Günday')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Hakan', N'Günday', N'Çağdaş Türk edebiyatı yazarı');
    PRINT '✓ Hakan Günday eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Can' AND LastName = N'Dündar')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Can', N'Dündar', N'Türk gazeteci ve yazar');
    PRINT '✓ Can Dündar eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'İlber', N'Ortaylı', N'Türk tarihçi ve akademisyen');
    PRINT '✓ İlber Ortaylı eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Paulo' AND LastName = N'Coelho')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Paulo', N'Coelho', N'Brezilyalı yazar');
    PRINT '✓ Paulo Coelho eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'George', N'Orwell', N'İngiliz yazar ve gazeteci');
    PRINT '✓ George Orwell eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'J.K.', N'Rowling', N'İngiliz yazar, Harry Potter serisinin yazarı');
    PRINT '✓ J.K. Rowling eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Dan' AND LastName = N'Brown')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Dan', N'Brown', N'Amerikalı yazar, Da Vinci Şifresi yazarı');
    PRINT '✓ Dan Brown eklendi';
END

IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Haruki' AND LastName = N'Murakami')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES (N'Haruki', N'Murakami', N'Japon yazar');
    PRINT '✓ Haruki Murakami eklendi';
END
GO

-- Kategori ve Yazar ID'lerini al
DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Roman');
DECLARE @BiyografiID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Biyografi');
DECLARE @TarihID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Tarih');
DECLARE @BilimKurguID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Bilim Kurgu');
DECLARE @PsikolojiID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Psikoloji');
DECLARE @KisiselGelisimID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Kişisel Gelişim');
DECLARE @PolisiyeID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Polisiye');

DECLARE @SabahattinAliID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Sabahattin' AND LastName = N'Ali');
DECLARE @ResatNuriID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin');
DECLARE @PeyamiSafaID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Peyami' AND LastName = N'Safa');
DECLARE @HakanGundayID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Hakan' AND LastName = N'Günday');
DECLARE @CanDundarID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Can' AND LastName = N'Dündar');
DECLARE @IlberOrtayliID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'İlber' AND LastName = N'Ortaylı');
DECLARE @PauloCoelhoID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Paulo' AND LastName = N'Coelho');
DECLARE @GeorgeOrwellID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'George' AND LastName = N'Orwell');
DECLARE @JKRowlingID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'J.K.' AND LastName = N'Rowling');
DECLARE @DanBrownID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Dan' AND LastName = N'Brown');
DECLARE @HarukiMurakamiID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Haruki' AND LastName = N'Murakami');
DECLARE @OrhanPamukID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Orhan' AND LastName = N'Pamuk');
DECLARE @AhmetUmitID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Ahmet' AND LastName = N'Ümit');
DECLARE @ElifSafakID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Elif' AND LastName = N'Şafak');

-- Kitapları ekle
-- 11. Kürk Mantolu Madonna - Sabahattin Ali
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800123')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Kürk Mantolu Madonna', '9789750800123', @SabahattinAliID, @RomanID, 32.50, 45,
            N'Sabahattin Ali''nin unutulmaz aşk romanı.', '1943-01-01');
    PRINT '✓ Kürk Mantolu Madonna eklendi';
END

-- 12. Çalıkuşu - Reşat Nuri Güntekin
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800234')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Çalıkuşu', '9789750800234', @ResatNuriID, @RomanID, 40.00, 60,
            N'Reşat Nuri Güntekin''in klasik eseri.', '1922-01-01');
    PRINT '✓ Çalıkuşu eklendi';
END

-- 13. Dokuzuncu Hariciye Koğuşu - Peyami Safa
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800345')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Dokuzuncu Hariciye Koğuşu', '9789750800345', @PeyamiSafaID, @RomanID, 36.90, 40,
            N'Peyami Safa''nın otobiyografik romanı.', '1930-01-01');
    PRINT '✓ Dokuzuncu Hariciye Koğuşu eklendi';
END

-- 14. Az - Hakan Günday
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800456')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Az', '9789750800456', @HakanGundayID, @RomanID, 44.90, 35,
            N'Hakan Günday''ın sıra dışı romanı.', '2011-01-01');
    PRINT '✓ Az eklendi';
END

-- 15. Mustafa Kemal - Can Dündar
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800567')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Mustafa Kemal', '9789750800567', @CanDundarID, @BiyografiID, 55.00, 30,
            N'Atatürk biyografisi.', '2008-01-01');
    PRINT '✓ Mustafa Kemal eklendi';
END

-- 16. Türklerin Tarihi - İlber Ortaylı
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800678')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Türklerin Tarihi', '9789750800678', @IlberOrtayliID, @TarihID, 62.50, 50,
            'İlber Ortaylı''nın Türk tarihi üzerine eseri.', '2015-01-01');
    PRINT '✓ Türklerin Tarihi eklendi';
END

-- 17. Simyacı - Paulo Coelho
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800789')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Simyacı', '9789750800789', @PauloCoelhoID, @KisiselGelisimID, 38.50, 80,
            'Paulo Coelho''nun dünyaca ünlü eseri.', '1988-01-01');
    PRINT '✓ Simyacı eklendi';
END

-- 18. 1984 - George Orwell
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800890')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('1984', '9789750800890', @GeorgeOrwellID, @BilimKurguID, 42.00, 65,
            'George Orwell''in distopya klasiği.', '1949-01-01');
    PRINT '✓ 1984 eklendi';
END

-- 19. Harry Potter ve Felsefe Taşı - J.K. Rowling
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750800901')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Harry Potter ve Felsefe Taşı', '9789750800901', @JKRowlingID, @BilimKurguID, 48.90, 100,
            'J.K. Rowling''in dünyaca ünlü serisinin ilk kitabı.', '1997-01-01');
    PRINT '✓ Harry Potter ve Felsefe Taşı eklendi';
END

-- 20. Da Vinci Şifresi - Dan Brown
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801012')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Da Vinci Şifresi', '9789750801012', @DanBrownID, @PolisiyeID, 52.00, 55,
            'Dan Brown''un çok satan polisiye gerilim romanı.', '2003-01-01');
    PRINT '✓ Da Vinci Şifresi eklendi';
END

-- 21. 1Q84 - Haruki Murakami
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801123')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('1Q84', '9789750801123', @HarukiMurakamiID, @RomanID, 68.50, 40,
            'Haruki Murakami''nin büyülü gerçekçilik romanı.', '2009-01-01');
    PRINT '✓ 1Q84 eklendi';
END

-- 22. Masumiyet Müzesi - Orhan Pamuk
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801234')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Masumiyet Müzesi', '9789750801234', @OrhanPamukID, @RomanID, 59.90, 45,
            'Orhan Pamuk''un aşk ve tutku dolu romanı.', '2008-01-01');
    PRINT '✓ Masumiyet Müzesi eklendi';
END

-- 23. İstanbul Hatıraları - Ahmet Ümit
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801345')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('İstanbul Hatıraları', '9789750801345', @AhmetUmitID, @PolisiyeID, 47.50, 50,
            'Ahmet Ümit''in İstanbul''u konu alan polisiye romanı.', '2010-01-01');
    PRINT '✓ İstanbul Hatıraları eklendi';
END

-- 24. Şafak - Elif Şafak
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801456')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Şafak', '9789750801456', @ElifSafakID, @RomanID, 46.00, 42,
            'Elif Şafak''ın modern Türkiye''yi anlatan romanı.', '2016-01-01');
    PRINT '✓ Şafak eklendi';
END

-- 25. Yaban - Yakup Kadri Karaosmanoğlu
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Yakup Kadri' AND LastName = 'Karaosmanoğlu')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Yakup Kadri', 'Karaosmanoğlu', 'Türk edebiyatının önemli romancısı');
END

DECLARE @YakupKadriID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Yakup Kadri' AND LastName = 'Karaosmanoğlu');

IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801567')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Yaban', '9789750801567', @YakupKadriID, @RomanID, 34.50, 38,
            'Yakup Kadri Karaosmanoğlu''nun Kurtuluş Savaşı dönemini anlatan romanı.', '1932-01-01');
    PRINT '✓ Yaban eklendi';
END

-- 26. Hayvan Çiftliği - George Orwell
IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801678')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Hayvan Çiftliği', '9789750801678', @GeorgeOrwellID, @RomanID, 28.90, 70,
            'George Orwell''in alegorik romanı.', '1945-01-01');
    PRINT '✓ Hayvan Çiftliği eklendi';
END

-- 27. Suç ve Ceza - Dostoyevski (Rus edebiyatı klasiklerinden)
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Fyodor', 'Dostoyevski', 'Rus edebiyatının büyük yazarı');
END

DECLARE @DostoyevskiID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski');

IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801789')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Suç ve Ceza', '9789750801789', @DostoyevskiID, @RomanID, 65.00, 35,
            'Dostoyevski''nin dünya edebiyatı klasiği.', '1866-01-01');
    PRINT '✓ Suç ve Ceza eklendi';
END

-- 28. Savaş ve Barış - Tolstoy
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Lev' AND LastName = 'Tolstoy')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Lev', 'Tolstoy', 'Rus edebiyatının dev yazarı');
END

DECLARE @TolstoyID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Lev' AND LastName = 'Tolstoy');

IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801890')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Savaş ve Barış', '9789750801890', @TolstoyID, @RomanID, 75.00, 25,
            'Tolstoy''un Napolyon dönemini anlatan başyapıtı.', '1869-01-01');
    PRINT '✓ Savaş ve Barış eklendi';
END

-- 29. Dönüşüm - Kafka
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'Franz' AND LastName = 'Kafka')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('Franz', 'Kafka', 'Çek-Avusturyalı yazar');
END

DECLARE @KafkaID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'Franz' AND LastName = 'Kafka');

IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750801901')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Dönüşüm', '9789750801901', @KafkaID, @RomanID, 32.00, 48,
            'Kafka''nın büyülü gerçekçilik eseri.', '1915-01-01');
    PRINT '✓ Dönüşüm eklendi';
END

-- 30. Yüzüklerin Efendisi - Tolkien
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = 'J.R.R.' AND LastName = 'Tolkien')
BEGIN
    INSERT INTO Authors (FirstName, LastName, Biography) 
    VALUES ('J.R.R.', 'Tolkien', 'İngiliz yazar, Yüzüklerin Efendisi yazarı');
END

DECLARE @TolkienID INT = (SELECT AuthorID FROM Authors WHERE FirstName = 'J.R.R.' AND LastName = 'Tolkien');

IF NOT EXISTS (SELECT * FROM Books WHERE ISBN = '9789750802012')
BEGIN
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES ('Yüzüklerin Efendisi', '9789750802012', @TolkienID, @BilimKurguID, 72.50, 60,
            'Tolkien''in epik fantastik romanı.', '1954-01-01');
    PRINT '✓ Yüzüklerin Efendisi eklendi';
END

GO

PRINT '';
PRINT '========================================';
PRINT 'Tüm kitaplar başarıyla eklendi!';
PRINT '========================================';

-- Toplam kitap sayısını göster
SELECT COUNT(*) AS ToplamKitapSayisi FROM Books;
GO

