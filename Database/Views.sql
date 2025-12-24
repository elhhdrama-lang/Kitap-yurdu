-- =============================================
-- VIEWS
-- En az 1 adet View
-- =============================================

USE KitapyurduDB;
GO

-- =============================================
-- VIEW: Kitap detayları görünümü
-- =============================================
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

PRINT 'View başarıyla oluşturuldu!';
GO

