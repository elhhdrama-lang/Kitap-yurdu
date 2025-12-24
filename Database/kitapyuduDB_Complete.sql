-- =============================================
-- WEB KİTAPYURDU - TAM VERİTABANI SCRIPT'İ
-- Microsoft SQL Server
-- Veritabanı Adı: kitapyuduDB
-- Tüm tablolar, stored procedures, triggers, views ve functions
-- =============================================

PRINT '========================================';
PRINT 'Web Kitapyurdu Veritabanı Kurulumu Başlıyor...';
PRINT 'Veritabanı: kitapyuduDB';
PRINT '========================================';
GO

-- =============================================
-- VERİTABANI OLUŞTURMA
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'kitapyuduDB')
BEGIN
    CREATE DATABASE kitapyuduDB;
    PRINT '✓ Veritabanı oluşturuldu: kitapyuduDB';
END
ELSE
BEGIN
    PRINT '⚠ Veritabanı zaten mevcut: kitapyuduDB';
END
GO

USE kitapyuduDB;
GO

PRINT '';
PRINT 'Veritabanı seçildi. Tablolar oluşturuluyor...';
PRINT '';

-- =============================================
-- TABLOLAR
-- =============================================

-- Kategoriler Tablosu
IF OBJECT_ID('Categories', 'U') IS NOT NULL
    DROP TABLE Categories;
GO

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE()
);
PRINT '✓ Categories tablosu oluşturuldu';
GO

-- Yazarlar Tablosu
IF OBJECT_ID('Authors', 'U') IS NOT NULL
    DROP TABLE Authors;
GO

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Biography NVARCHAR(1000),
    CreatedDate DATETIME DEFAULT GETDATE()
);
PRINT '✓ Authors tablosu oluşturuldu';
GO

-- Kitaplar Tablosu
IF OBJECT_ID('Books', 'U') IS NOT NULL
    DROP TABLE Books;
GO

CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200) NOT NULL,
    ISBN NVARCHAR(20) UNIQUE,
    AuthorID INT NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT DEFAULT 0,
    Description NVARCHAR(2000),
    PublishedDate DATE,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
PRINT '✓ Books tablosu oluşturuldu';
GO

-- Kullanıcılar Tablosu
IF OBJECT_ID('Users', 'U') IS NOT NULL
    DROP TABLE Users;
GO

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(20),
    Address NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
PRINT '✓ Users tablosu oluşturuldu';
GO

-- Siparişler Tablosu
IF OBJECT_ID('Orders', 'U') IS NOT NULL
    DROP TABLE Orders;
GO

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    ShippingAddress NVARCHAR(500),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
PRINT '✓ Orders tablosu oluşturuldu';
GO

-- Sipariş Detayları Tablosu
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
    DROP TABLE OrderDetails;
GO



-- Sepet Tablosu
IF OBJECT_ID('Cart', 'U') IS NOT NULL
    DROP TABLE Cart;
GO

CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    AddedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
PRINT '✓ Cart tablosu oluşturuldu';
GO

-- Stok Hareketleri Tablosu
IF OBJECT_ID('StockMovements', 'U') IS NOT NULL
    DROP TABLE StockMovements;
GO

CREATE TABLE StockMovements (
    MovementID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL,
    Quantity INT NOT NULL,
    MovementDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(500),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
PRINT '✓ StockMovements tablosu oluşturuldu';
GO

-- Reviews Tablosu
IF OBJECT_ID('Reviews', 'U') IS NULL
BEGIN
    CREATE TABLE Reviews (
        ReviewID INT PRIMARY KEY IDENTITY(1,1),
        BookID INT NOT NULL,
        UserID INT NOT NULL,
        Rating INT CHECK (Rating >= 1 AND Rating <= 5),
        Comment NVARCHAR(1000),
        ReviewDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (BookID) REFERENCES Books(BookID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
    PRINT '✓ Reviews tablosu oluşturuldu';
END
GO

-- PriceChangeLog Tablosu
IF OBJECT_ID('PriceChangeLog', 'U') IS NULL
BEGIN
    CREATE TABLE PriceChangeLog (
        LogID INT PRIMARY KEY IDENTITY(1,1),
        BookID INT NOT NULL,
        OldPrice DECIMAL(10,2),
        NewPrice DECIMAL(10,2),
        ChangeDate DATETIME DEFAULT GETDATE(),
        ChangedBy NVARCHAR(100),
        FOREIGN KEY (BookID) REFERENCES Books(BookID)
    );
    PRINT '✓ PriceChangeLog tablosu oluşturuldu';
END
GO


PRINT '';
PRINT 'Tüm tablolar başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'STORED PROCEDURES OLUŞTURULUYOR...';
PRINT '========================================';
GO

-- =============================================
-- STORED PROCEDURES (SP)
-- En az 5 adet Stored Procedure
-- =============================================

-- SP 1: Kullanıcıya göre siparişleri getir
IF OBJECT_ID('sp_GetUserOrders', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetUserOrders;
GO

CREATE PROCEDURE sp_GetUserOrders
    @UserID INT
AS
BEGIN
    -- Kullanıcının tüm siparişlerini ve detaylarını getirir
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.Status,
        o.ShippingAddress,
        od.OrderDetailID,
        od.Quantity,
        od.UnitPrice,
        od.SubTotal,
        b.Title AS BookTitle,
        b.ISBN,
        a.FirstName + ' ' + a.LastName AS AuthorName
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Books b ON od.BookID = b.BookID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    WHERE o.UserID = @UserID
    ORDER BY o.OrderDate DESC;
END
GO
PRINT '✓ sp_GetUserOrders oluşturuldu';

-- SP 2: Kategoriye göre kitapları getir
IF OBJECT_ID('sp_GetBooksByCategory', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBooksByCategory;
GO

CREATE PROCEDURE sp_GetBooksByCategory
    @CategoryID INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    -- Belirli bir kategorideki kitapları sayfalama ile getirir
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        b.Description,
        b.PublishedDate,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        (SELECT COUNT(*) FROM Books WHERE CategoryID = @CategoryID) AS TotalCount
    FROM Books b
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE b.CategoryID = @CategoryID
    ORDER BY b.CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO
PRINT '✓ sp_GetBooksByCategory oluşturuldu';

-- SP 3: Sipariş oluştur
IF OBJECT_ID('sp_CreateOrder', 'P') IS NOT NULL
    DROP PROCEDURE sp_CreateOrder;
GO

CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @ShippingAddress NVARCHAR(500),
    @OrderID INT OUTPUT
AS
BEGIN
    -- Kullanıcının sepetindeki ürünlerden sipariş oluşturur
    DECLARE @TotalAmount DECIMAL(10,2) = 0;
    DECLARE @CartItemCount INT = 0;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Sepetteki ürünlerin toplam tutarını hesapla
        SELECT @TotalAmount = SUM(c.Quantity * b.Price)
        FROM Cart c
        INNER JOIN Books b ON c.BookID = b.BookID
        WHERE c.UserID = @UserID;
        
        -- Sepet boş mu kontrol et
        IF @TotalAmount IS NULL OR @TotalAmount = 0
        BEGIN
            RAISERROR('Sepetiniz boş!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Sipariş oluştur
        INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, Status)
        VALUES (@UserID, @TotalAmount, @ShippingAddress, 'Pending');
        
        SET @OrderID = SCOPE_IDENTITY();
        
        -- Sipariş detaylarını oluştur ve sepeti temizle
        INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal)
        SELECT 
            @OrderID,
            c.BookID,
            c.Quantity,
            b.Price,
            c.Quantity * b.Price
        FROM Cart c
        INNER JOIN Books b ON c.BookID = b.BookID
        WHERE c.UserID = @UserID;
        
        -- Sepeti temizle
        DELETE FROM Cart WHERE UserID = @UserID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
PRINT '✓ sp_CreateOrder oluşturuldu';

-- SP 4: En çok satan kitapları getir
IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    -- En çok satılan kitapları getirir
    SELECT TOP (@TopCount)
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        SUM(od.Quantity) AS TotalSold,
        SUM(od.SubTotal) AS TotalRevenue
    FROM Books b
    INNER JOIN OrderDetails od ON b.BookID = od.BookID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE o.Status != 'Cancelled'
    GROUP BY b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, 
             a.FirstName, a.LastName, c.CategoryName
    ORDER BY TotalSold DESC;
END
GO
PRINT '✓ sp_GetBestSellingBooks oluşturuldu';

-- SP 5: Kullanıcı sepetini getir
IF OBJECT_ID('sp_GetUserCart', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetUserCart;
GO

CREATE PROCEDURE sp_GetUserCart
    @UserID INT
AS
BEGIN
    -- Kullanıcının sepetindeki ürünleri detaylı şekilde getirir
    SELECT 
        c.CartID,
        c.Quantity,
        c.AddedDate,
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        (c.Quantity * b.Price) AS SubTotal,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        cat.CategoryName
    FROM Cart c
    INNER JOIN Books b ON c.BookID = b.BookID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories cat ON b.CategoryID = cat.CategoryID
    WHERE c.UserID = @UserID
    ORDER BY c.AddedDate DESC;
    
    -- Toplam tutarı da getir
    SELECT 
        SUM(c.Quantity * b.Price) AS TotalAmount,
        SUM(c.Quantity) AS TotalItems
    FROM Cart c
    INNER JOIN Books b ON c.BookID = b.BookID
    WHERE c.UserID = @UserID;
END
GO
PRINT '✓ sp_GetUserCart oluşturuldu';

PRINT '';
PRINT 'Tüm Stored Procedures başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'TRIGGERS OLUŞTURULUYOR...';
PRINT '========================================';
GO

-- =============================================
-- TRIGGERS (TRG)
-- En az 4 adet Trigger
-- =============================================

-- TRG 1: Sipariş detayı eklendiğinde stok azalt
IF OBJECT_ID('trg_OrderDetail_Insert_UpdateStock', 'TR') IS NOT NULL
    DROP TRIGGER trg_OrderDetail_Insert_UpdateStock;
GO

CREATE TRIGGER trg_OrderDetail_Insert_UpdateStock
ON OrderDetails
AFTER INSERT
AS
BEGIN
    -- Sipariş detayı eklendiğinde kitap stok miktarını azaltır
    UPDATE b
    SET b.StockQuantity = b.StockQuantity - i.Quantity
    FROM Books b
    INNER JOIN inserted i ON b.BookID = i.BookID;
    
    -- Stok hareketi kaydı oluştur
    INSERT INTO StockMovements (BookID, MovementType, Quantity, Description)
    SELECT 
        BookID,
        'OUT',
        Quantity,
        'Sipariş için stok çıkışı - OrderID: ' + CAST((SELECT OrderID FROM inserted) AS NVARCHAR(10))
    FROM inserted;
    
    PRINT 'Stok güncellendi ve stok hareketi kaydedildi.';
END
GO
PRINT '✓ trg_OrderDetail_Insert_UpdateStock oluşturuldu';

-- TRG 2: Kitap fiyatı değiştiğinde log tut
IF OBJECT_ID('trg_Book_Update_LogPriceChange', 'TR') IS NOT NULL
    DROP TRIGGER trg_Book_Update_LogPriceChange;
GO

CREATE TRIGGER trg_Book_Update_LogPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    -- Kitap fiyatı değiştiğinde değişikliği loglar
    IF UPDATE(Price)
    BEGIN
        INSERT INTO PriceChangeLog (BookID, OldPrice, NewPrice, ChangedBy)
        SELECT 
            i.BookID,
            d.Price AS OldPrice,
            i.Price AS NewPrice,
            SYSTEM_USER AS ChangedBy
        FROM inserted i
        INNER JOIN deleted d ON i.BookID = d.BookID
        WHERE i.Price != d.Price;
        
        PRINT 'Fiyat değişikliği loglandı.';
    END
END
GO
PRINT '✓ trg_Book_Update_LogPriceChange oluşturuldu';

-- TRG 3: Yeni kullanıcı kaydında hoş geldin mesajı
IF OBJECT_ID('trg_User_Insert_WelcomeLog', 'TR') IS NOT NULL
    DROP TRIGGER trg_User_Insert_WelcomeLog;
GO

CREATE TRIGGER trg_User_Insert_WelcomeLog
ON Users
AFTER INSERT
AS
BEGIN
    -- Yeni kullanıcı kaydında hoş geldin logu oluşturur
    INSERT INTO UserWelcomeLog (UserID, Username, Email)
    SELECT UserID, Username, Email
    FROM inserted;
    
    PRINT 'Yeni kullanıcı kaydı için hoş geldin logu oluşturuldu.';
END
GO
PRINT '✓ trg_User_Insert_WelcomeLog oluşturuldu';

-- TRG 4: Sipariş iptal edildiğinde stok geri ekle
IF OBJECT_ID('trg_Order_Update_RestoreStock', 'TR') IS NOT NULL
    DROP TRIGGER trg_Order_Update_RestoreStock;
GO

CREATE TRIGGER trg_Order_Update_RestoreStock
ON Orders
AFTER UPDATE
AS
BEGIN
    -- Sipariş iptal edildiğinde stokları geri ekler
    IF UPDATE(Status)
    BEGIN
        -- İptal edilen siparişler için stok geri ekle
        UPDATE b
        SET b.StockQuantity = b.StockQuantity + od.Quantity
        FROM Books b
        INNER JOIN OrderDetails od ON b.BookID = od.BookID
        INNER JOIN inserted i ON od.OrderID = i.OrderID
        INNER JOIN deleted d ON i.OrderID = d.OrderID
        WHERE d.Status != 'Cancelled' AND i.Status = 'Cancelled';
        
        -- Stok hareketi kaydı oluştur
        INSERT INTO StockMovements (BookID, MovementType, Quantity, Description)
        SELECT 
            od.BookID,
            'IN',
            od.Quantity,
            'İptal edilen sipariş için stok girişi - OrderID: ' + CAST(i.OrderID AS NVARCHAR(10))
        FROM OrderDetails od
        INNER JOIN inserted i ON od.OrderID = i.OrderID
        INNER JOIN deleted d ON i.OrderID = d.OrderID
        WHERE d.Status != 'Cancelled' AND i.Status = 'Cancelled';
        
        PRINT 'İptal edilen sipariş için stoklar geri eklendi.';
    END
END
GO
PRINT '✓ trg_Order_Update_RestoreStock oluşturuldu';

PRINT '';
PRINT 'Tüm Triggers başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'VIEWS OLUŞTURULUYOR...';
PRINT '========================================';
GO

-- =============================================
-- VIEWS
-- En az 1 adet View
-- =============================================

-- VIEW: Kitap detayları görünümü
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL
    DROP VIEW vw_BookDetails;
GO

CREATE VIEW vw_BookDetails
AS
-- Kitapların tüm detaylarını yazar ve kategori bilgileriyle birlikte gösterir
SELECT 
    b.BookID,
    b.Title,
    b.ISBN,
    b.Price,
    b.StockQuantity,
    b.Description,
    b.PublishedDate,
    b.CreatedDate,
    -- Yazar bilgileri
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorFullName,
    a.Biography AS AuthorBiography,
    -- Kategori bilgileri
    c.CategoryID,
    c.CategoryName,
    c.Description AS CategoryDescription,
    -- Hesaplanan alanlar
    CASE 
        WHEN b.StockQuantity > 10 THEN 'Stokta Var'
        WHEN b.StockQuantity > 0 THEN 'Az Stokta'
        ELSE 'Stokta Yok'
    END AS StockStatus,
    -- Satış istatistikleri
    ISNULL((SELECT COUNT(*) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalOrders,
    ISNULL((SELECT SUM(od.Quantity) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalSold
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;
GO
PRINT '✓ vw_BookDetails view oluşturuldu';

PRINT '';
PRINT 'View başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'FUNCTIONS OLUŞTURULUYOR...';
PRINT '========================================';
GO

-- =============================================
-- FUNCTIONS
-- En az 3 adet Fonksiyon
-- =============================================

-- FUNCTION 1: Kullanıcının toplam sipariş tutarını hesapla
IF OBJECT_ID('fn_CalculateUserTotalOrderAmount', 'FN') IS NOT NULL
    DROP FUNCTION fn_CalculateUserTotalOrderAmount;
GO

CREATE FUNCTION fn_CalculateUserTotalOrderAmount(@UserID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    -- Kullanıcının tüm siparişlerinin toplam tutarını hesaplar
    DECLARE @TotalAmount DECIMAL(10,2);
    
    SELECT @TotalAmount = ISNULL(SUM(TotalAmount), 0)
    FROM Orders
    WHERE UserID = @UserID AND Status != 'Cancelled';
    
    RETURN @TotalAmount;
END
GO
PRINT '✓ fn_CalculateUserTotalOrderAmount oluşturuldu';

-- FUNCTION 2: Kategorideki kitap sayısını getir
IF OBJECT_ID('fn_GetCategoryBookCount', 'FN') IS NOT NULL
    DROP FUNCTION fn_GetCategoryBookCount;
GO

CREATE FUNCTION fn_GetCategoryBookCount(@CategoryID INT)
RETURNS INT
AS
BEGIN
    -- Belirli bir kategorideki toplam kitap sayısını döndürür
    DECLARE @BookCount INT;
    
    SELECT @BookCount = COUNT(*)
    FROM Books
    WHERE CategoryID = @CategoryID;
    
    RETURN ISNULL(@BookCount, 0);
END
GO
PRINT '✓ fn_GetCategoryBookCount oluşturuldu';

-- FUNCTION 3: Kitabın ortalama değerlendirme puanını hesapla
IF OBJECT_ID('fn_CalculateBookAverageRating', 'FN') IS NOT NULL
    DROP FUNCTION fn_CalculateBookAverageRating;
GO

CREATE FUNCTION fn_CalculateBookAverageRating(@BookID INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    -- Kitabın ortalama değerlendirme puanını hesaplar (1-5 arası)
    DECLARE @AverageRating DECIMAL(3,2);
    
    SELECT @AverageRating = ISNULL(AVG(CAST(Rating AS DECIMAL(3,2))), 0)
    FROM Reviews
    WHERE BookID = @BookID;
    
    RETURN @AverageRating;
END
GO
PRINT '✓ fn_CalculateBookAverageRating oluşturuldu';

-- FUNCTION 4 (Bonus): İki tarih arasındaki sipariş sayısını getir
IF OBJECT_ID('fn_GetOrderCountByDateRange', 'FN') IS NOT NULL
    DROP FUNCTION fn_GetOrderCountByDateRange;
GO

CREATE FUNCTION fn_GetOrderCountByDateRange(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS
BEGIN
    -- Belirli bir tarih aralığındaki sipariş sayısını döndürür
    DECLARE @OrderCount INT;
    
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE OrderDate >= @StartDate AND OrderDate <= @EndDate
    AND Status != 'Cancelled';
    
    RETURN ISNULL(@OrderCount, 0);
END
GO
PRINT '✓ fn_GetOrderCountByDateRange oluşturuldu';

PRINT '';
PRINT 'Tüm Functions başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'ÖRNEK VERİLER EKLENİYOR...';
PRINT '========================================';
GO

-- =============================================
-- ÖRNEK VERİLER (OPSİYONEL)
-- =============================================

-- Kategoriler
IF NOT EXISTS (SELECT * FROM Categories)
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
    PRINT '✓ Örnek kategoriler eklendi';
END
GO

-- Yazarlar
IF NOT EXISTS (SELECT * FROM Authors)
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
    ('Yuval', 'Harari', 'Sapiens yazarı');
    PRINT '✓ Örnek yazarlar eklendi';
END
GO

-- Kitaplar
IF NOT EXISTS (SELECT * FROM Books)
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
    ('Yazılım Geliştirme Prensipleri', '9789750807802', 1, 10, 55.00, 25, 'Programlama ve yazılım geliştirme', '2020-01-01'),
    -- Çocuk Kitapları
    ('Küçük Prens', '9789750807826', 1, 6, 25.00, 100, 'Antoine de Saint-Exupéry''nin ünlü eseri', '1943-01-01'),
    ('Alice Harikalar Diyarında', '9789750807833', 1, 6, 28.00, 90, 'Lewis Carroll''un klasik eseri', '1865-01-01'),
    -- Şiir
    ('Memleketimden İnsan Manzaraları', '9789750807840', 6, 7, 35.00, 40, 'Nazım Hikmet''in şiirleri', '1966-01-01');
    PRINT '✓ Örnek kitaplar eklendi';
END
GO

-- Kullanıcılar (şifreler basit tutulmuş - gerçek uygulamada hash kullanılmalı)
IF NOT EXISTS (SELECT * FROM Users)
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash, FirstName, LastName, Phone, Address) VALUES
    ('admin', 'admin@kitapyurdu.com', 'admin123', 'Admin', 'User', '555-0001', 'İstanbul, Türkiye'),
    ('testuser', 'test@example.com', 'test123', 'Test', 'User', '555-0002', 'Ankara, Türkiye'),
    ('ahmet', 'ahmet@example.com', 'ahmet123', 'Ahmet', 'Yılmaz', '555-0003', 'İzmir, Türkiye'),
    ('ayse', 'ayse@example.com', 'ayse123', 'Ayşe', 'Demir', '555-0004', 'Bursa, Türkiye'),
    ('mehmet', 'mehmet@example.com', 'mehmet123', 'Mehmet', 'Kaya', '555-0005', 'Antalya, Türkiye'),
    ('fatma', 'fatma@example.com', 'fatma123', 'Fatma', 'Şahin', '555-0006', 'Adana, Türkiye');
    PRINT '✓ Örnek kullanıcılar eklendi';
END
GO

-- Sepet verileri (bazı kullanıcıların sepetinde ürünler)
IF NOT EXISTS (SELECT * FROM Cart)
BEGIN
    INSERT INTO Cart (UserID, BookID, Quantity) VALUES
    (2, 1, 2),  -- testuser - Kara Kitap - 2 adet
    (2, 3, 1),  -- testuser - İnce Memed - 1 adet
    (3, 5, 1),  -- ahmet - Aşk
    (3, 10, 1), -- ahmet - 1984
    (4, 11, 2); -- ayse - Hayvan Çiftliği - 2 adet
    PRINT '✓ Sepet verileri eklendi';
END
GO

-- Siparişler ve sipariş detayları
IF NOT EXISTS (SELECT * FROM Orders)
BEGIN
    -- Kullanıcı 2'nin siparişi
    DECLARE @Order1 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (2, 90.00, 'Completed', 'Ankara, Türkiye');
    SET @Order1 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order1, 2, 1, 55.00, 55.00),  -- Benim Adım Kırmızı
    (@Order1, 4, 1, 35.00, 35.00);  -- Kürk Mantolu Madonna
    
    -- Kullanıcı 3'ün siparişi
    DECLARE @Order2 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (3, 148.00, 'Pending', 'İzmir, Türkiye');
    SET @Order2 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order2, 6, 1, 48.00, 48.00),  -- Baba ve Piç
    (@Order2, 12, 2, 50.00, 100.00); -- Harry Potter ve Felsefe Taşı - 2 adet
    
    -- Kullanıcı 4'ün siparişi
    DECLARE @Order3 INT;
    INSERT INTO Orders (UserID, TotalAmount, Status, ShippingAddress)
    VALUES (4, 95.00, 'Completed', 'Bursa, Türkiye');
    SET @Order3 = SCOPE_IDENTITY();
    
    INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal) VALUES
    (@Order3, 15, 1, 60.00, 60.00), -- Nutuk
    (@Order3, 19, 1, 35.00, 35.00); -- Devlet
    
    PRINT '✓ Siparişler ve sipariş detayları eklendi';
END
GO

-- Değerlendirmeler (Reviews)
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
PRINT 'VERİTABANI KURULUMU TAMAMLANDI!';
PRINT '========================================';
PRINT '';
PRINT 'Oluşturulan Öğeler:';
PRINT '  ✓ Veritabanı: kitapyuduDB';
PRINT '  ✓ 11 Tablo';
PRINT '  ✓ 5 Stored Procedure';
PRINT '  ✓ 4 Trigger';
PRINT '  ✓ 1 View';
PRINT '  ✓ 4 Function';
PRINT '  ✓ Örnek Veriler';
PRINT '';
PRINT 'Veritabanı kullanıma hazır!';
PRINT '========================================';
GO


