-- =============================================
-- FUNCTIONS
-- En az 3 adet Fonksiyon
-- =============================================

USE KitapyurduDB;
GO

-- =============================================
-- FUNCTION 1: Kullanıcının toplam sipariş tutarını hesapla
-- =============================================
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

-- =============================================
-- FUNCTION 2: Kategorideki kitap sayısını getir
-- =============================================
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

-- =============================================
-- FUNCTION 3: Kitabın ortalama değerlendirme puanını hesapla
-- =============================================
-- Önce Reviews tablosu oluşturalım (eğer yoksa)
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
END
GO

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

-- =============================================
-- FUNCTION 4 (Bonus): İki tarih arasındaki sipariş sayısını getir
-- =============================================
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

PRINT 'Tüm Functions başarıyla oluşturuldu!';
GO





