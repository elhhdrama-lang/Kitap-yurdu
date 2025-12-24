-- Kitapları kontrol etme sorgusu
USE KitapyurduDB;
GO

-- Toplam kitap sayısı
SELECT COUNT(*) AS TotalBooks FROM Books;
GO

-- Kitapları listele
SELECT 
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS Author,
    c.CategoryName AS Category,
    b.Price,
    b.StockQuantity
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID
ORDER BY b.Title;
GO

-- Yazarları kontrol et
SELECT COUNT(*) AS TotalAuthors FROM Authors;
SELECT * FROM Authors;
GO

-- Kategorileri kontrol et
SELECT COUNT(*) AS TotalCategories FROM Categories;
SELECT * FROM Categories;
GO

USE KitapyurduDB;
GO

-- Kitap sayısını kontrol et
SELECT COUNT(*) AS ToplamKitapSayisi FROM Books;
GO

USE KitapyurduDB;
GO

-- Basit liste
SELECT * FROM Books
ORDER BY Title;