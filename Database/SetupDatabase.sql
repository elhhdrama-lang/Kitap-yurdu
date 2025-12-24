-- =============================================
-- TÜM VERİTABANI KURULUM SCRIPT'İ
-- Bu dosyayı SSMS'de çalıştırarak tüm veritabanını kurabilirsiniz
-- =============================================

-- ÖNEMLİ: Bu script'i çalıştırmadan önce SQL Server'ın çalıştığından emin olun
-- ve Windows kullanıcınızın SQL Server'a erişim izni olduğundan emin olun

PRINT '========================================';
PRINT 'Web Kitapyurdu Veritabanı Kurulumu Başlıyor...';
PRINT '========================================';
GO

-- Veritabanını oluştur
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KitapyurduDB')
BEGIN
    CREATE DATABASE KitapyurduDB;
    PRINT '✓ Veritabanı oluşturuldu: KitapyurduDB';
END
ELSE
BEGIN
    PRINT '⚠ Veritabanı zaten mevcut: KitapyurduDB';
END
GO

USE KitapyurduDB;
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

-- Sipariş Detayları Tablosu
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL
    DROP TABLE OrderDetails;
GO

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
PRINT '✓ OrderDetails tablosu oluşturuldu';

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

-- UserWelcomeLog Tablosu
IF OBJECT_ID('UserWelcomeLog', 'U') IS NULL
BEGIN
    CREATE TABLE UserWelcomeLog (
        LogID INT PRIMARY KEY IDENTITY(1,1),
        UserID INT NOT NULL,
        Username NVARCHAR(50),
        Email NVARCHAR(100),
        WelcomeDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
    );
    PRINT '✓ UserWelcomeLog tablosu oluşturuldu';
END

PRINT '';
PRINT 'Tüm tablolar başarıyla oluşturuldu!';
PRINT '';
PRINT '========================================';
PRINT 'NOT: Şimdi diğer script dosyalarını çalıştırın:';
PRINT '1. StoredProcedures.sql';
PRINT '2. Triggers.sql';
PRINT '3. Views.sql';
PRINT '4. Functions.sql';
PRINT '5. InsertSampleData.sql (opsiyonel)';
PRINT '========================================';
GO





