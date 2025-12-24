-- =============================================
-- Web Kitapyurdu Veritabanı Oluşturma Script'i
-- Microsoft SQL Server
-- =========================================
-- Veritabanını oluştur
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KitapyurduDB')
BEGIN
    CREATE DATABASE KitapyurduDB;
END
GO

USE KitapyurduDB;
GO

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
GO

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
GO

-- Stok Hareketleri Tablosu (Trigger için)
IF OBJECT_ID('StockMovements', 'U') IS NOT NULL
    DROP TABLE StockMovements;
GO

CREATE TABLE StockMovements (
    MovementID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL, -- 'IN', 'OUT'
    Quantity INT NOT NULL,
    MovementDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(500),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO

PRINT 'Tüm tablolar başarıyla oluşturuldu!';
GO

