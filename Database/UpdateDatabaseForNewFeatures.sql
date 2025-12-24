-- Bu script, yeni özellikler için gerekli veritabanı güncellemelerini içerir
-- ÖNEMLİ: Bu script'i çalıştırmadan ÖNCE SetupDatabase.sql dosyasını çalıştırmalısınız!

-- Veritabanının var olup olmadığını kontrol et
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KitapyurduDB')
BEGIN
    PRINT 'HATA: KitapyurduDB veritabanı bulunamadı!';
    PRINT 'Lütfen önce Database/SetupDatabase.sql dosyasını çalıştırın.';
    RETURN;
END
GO

USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Veritabanı güncellemeleri başlıyor...';
PRINT '========================================';
PRINT '';
GO

-- Favorites Tablosu oluştur
IF OBJECT_ID('Favorites', 'U') IS NULL
BEGIN
    -- Önce Books ve Users tablolarının var olduğunu kontrol et
    IF OBJECT_ID('Books', 'U') IS NOT NULL AND OBJECT_ID('Users', 'U') IS NOT NULL
    BEGIN
        CREATE TABLE Favorites (
            FavoriteID INT PRIMARY KEY IDENTITY(1,1),
            UserID INT NOT NULL,
            BookID INT NOT NULL,
            AddedDate DATETIME DEFAULT GETDATE(),
            FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
            FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
            UNIQUE(UserID, BookID)
        );
        PRINT '✓ Favorites tablosu oluşturuldu';
    END
    ELSE
    BEGIN
        PRINT '⚠ Books veya Users tablosu bulunamadı. SetupDatabase.sql dosyasını çalıştırın.';
    END
END
ELSE
BEGIN
    PRINT '✓ Favorites tablosu zaten mevcut';
END
GO

-- Orders tablosuna TrackingNumber ve ShippingInfo kolonları ekle
IF OBJECT_ID('Orders', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'TrackingNumber')
    BEGIN
        ALTER TABLE Orders
        ADD TrackingNumber NVARCHAR(100) NULL;
        PRINT '✓ TrackingNumber kolonu eklendi';
    END
    ELSE
    BEGIN
        PRINT '✓ TrackingNumber kolonu zaten mevcut';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'ShippingInfo')
    BEGIN
        ALTER TABLE Orders
        ADD ShippingInfo NVARCHAR(500) NULL;
        PRINT '✓ ShippingInfo kolonu eklendi';
    END
    ELSE
    BEGIN
        PRINT '✓ ShippingInfo kolonu zaten mevcut';
    END
END
ELSE
BEGIN
    PRINT '⚠ Orders tablosu bulunamadı. SetupDatabase.sql dosyasını çalıştırın.';
END
GO

-- Reviews tablosunun var olduğundan emin ol (eğer yoksa oluştur)
IF OBJECT_ID('Reviews', 'U') IS NULL
BEGIN
    -- Önce Books ve Users tablolarının var olduğunu kontrol et
    IF OBJECT_ID('Books', 'U') IS NOT NULL AND OBJECT_ID('Users', 'U') IS NOT NULL
    BEGIN
        CREATE TABLE Reviews (
            ReviewID INT PRIMARY KEY IDENTITY(1,1),
            BookID INT NOT NULL,
            UserID INT NOT NULL,
            Rating INT CHECK (Rating >= 1 AND Rating <= 5),
            Comment NVARCHAR(1000),
            ReviewDate DATETIME DEFAULT GETDATE(),
            FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
            FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
        );
        PRINT '✓ Reviews tablosu oluşturuldu';
    END
    ELSE
    BEGIN
        PRINT '⚠ Books veya Users tablosu bulunamadı. SetupDatabase.sql dosyasını çalıştırın.';
    END
END
ELSE
BEGIN
    PRINT '✓ Reviews tablosu zaten mevcut';
END
GO

PRINT '';
PRINT 'Veritabanı güncellemeleri tamamlandı!';
GO

