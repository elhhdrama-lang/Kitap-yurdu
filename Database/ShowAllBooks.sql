-- Tüm kitapları görüntüle
USE KitapyurduDB;
GO

-- Basit liste (sadece Books tablosu)
SELECT * FROM Books
ORDER BY Title;
GO

-- Detaylı liste (yazar ve kategori bilgileriyle)
SELECT 
    b.BookID,
    b.Title AS 'Kitap Adı',
    b.ISBN,
    a.FirstName + ' ' + a.LastName AS 'Yazar',
    c.CategoryName AS 'Kategori',
    b.Price AS 'Fiyat',
    b.StockQuantity AS 'Stok',
    CASE 
        WHEN b.StockQuantity > 10 THEN 'Stokta Var'
        WHEN b.StockQuantity > 0 THEN 'Az Stokta'
        ELSE 'Stokta Yok'
    END AS 'Durum',
    b.Description AS 'Açıklama',
    b.PublishedDate AS 'Yayın Tarihi'
FROM Books b
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
ORDER BY b.Title;
GO

