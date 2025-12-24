-- =============================================
-- TRIGGERS (TRG)
-- En az 4 adet Trigger
-- =============================================

USE KitapyurduDB;
GO

-- =============================================
-- TRG 1: Sipariş detayı eklendiğinde stok azalt
-- =============================================
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

-- =============================================
-- TRG 2: Kitap fiyatı değiştiğinde log tut
-- =============================================
IF OBJECT_ID('PriceChangeLog', 'U') IS NOT NULL
    DROP TABLE PriceChangeLog;
GO

CREATE TABLE PriceChangeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT NOT NULL,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO

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

-- =============================================
-- TRG 3: Yeni kullanıcı kaydında hoş geldin mesajı
-- =============================================
IF OBJECT_ID('UserWelcomeLog', 'U') IS NOT NULL
    DROP TABLE UserWelcomeLog;
GO

CREATE TABLE UserWelcomeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    Username NVARCHAR(50),
    Email NVARCHAR(100),
    WelcomeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

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

-- =============================================
-- TRG 4: Sipariş iptal edildiğinde stok geri ekle
-- =============================================
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

PRINT 'Tüm Triggers başarıyla oluşturuldu!';
GO





