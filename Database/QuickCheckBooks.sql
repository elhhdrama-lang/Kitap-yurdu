-- Hızlı kontrol: Kitaplar var mı?
USE KitapyurduDB;
GO

-- Toplam kitap sayısı
SELECT COUNT(*) AS ToplamKitapSayisi FROM Books;
GO

-- Eğer kitaplar varsa, listele
IF EXISTS (SELECT * FROM Books)
BEGIN
    SELECT 
        b.BookID,
        b.Title AS KitapAdi,
        a.FirstName + ' ' + a.LastName AS Yazar,
        c.CategoryName AS Kategori,
        b.Price AS Fiyat,
        b.StockQuantity AS Stok
    FROM Books b
    LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
    LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
    ORDER BY b.Title;
END
ELSE
BEGIN
    PRINT '⚠️ Kitaplar henüz eklenmemiş! Insert10BooksSimple.sql script''ini çalıştırın.';
    PRINT '';
    PRINT 'Yazarları kontrol ediliyor...';
    SELECT COUNT(*) AS ToplamYazarSayisi FROM Authors;
    SELECT * FROM Authors;
END
GO

