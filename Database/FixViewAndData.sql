USE KitapyurduDB;
GO

-- Complete vw_BookDetails with all columns required by DatabaseHelper
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL
    DROP VIEW vw_BookDetails;
GO

CREATE VIEW vw_BookDetails
AS
SELECT 
    b.BookID,
    b.Title,
    b.ISBN,
    b.Price,
    b.StockQuantity,
    b.Description,
    b.PublishedDate,
    b.CreatedDate,
    b.ImageURL,
    b.Publisher,
    b.PageCount,
    b.Language,
    b.SellerID,
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
    -- Istatistikler
    ISNULL((SELECT COUNT(*) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalOrders,
    ISNULL((SELECT SUM(od.Quantity) FROM OrderDetails od WHERE od.BookID = b.BookID), 0) AS TotalSold,
    ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS AverageRating,
    ISNULL((SELECT COUNT(*) FROM Reviews r WHERE r.BookID = b.BookID), 0) AS ReviewCount
FROM Books b
INNER JOIN Authors a ON b.AuthorID = a.AuthorID
INNER JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT 'vw_BookDetails updated with all columns.';
GO

-- Re-populate data just in case
-- (Running the PopulateRealData logic again ensures IDs match)
ALTER TABLE Books NOCHECK CONSTRAINT ALL;
DELETE FROM Books;
ALTER TABLE Books CHECK CONSTRAINT ALL;

INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Kürk Mantolu Madonna', '9789753638029', 1, 1, 45.50, 100, N'Raif Efendi''nin içe kapanık yaşamı ve Berlin''de Maria Puder ile yaşadığı unutulmaz aşkın hikayesi.', '1943-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638029-L.jpg'),
(N'Kuyucaklı Yusuf', '9789753638036', 1, 1, 42.00, 85, N'Taşra hayatının ve toplumsal adaletsizliklerin Yusuf''un gözünden anlatımı.', '1937-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638036-L.jpg'),
(N'İçimizdeki Şeytan', '9789753638043', 1, 1, 40.00, 60, N'Ömer ve Macide''nin aşkı etrafında aydın kesimin eleştirisi.', '1940-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638043-L.jpg'),
(N'1984', '9789750718533', 2, 1, 65.00, 200, N'Büyük Birader''in gözetimi altındaki totaliter bir distopya.', '1949-06-08', 'https://covers.openlibrary.org/b/isbn/9789750718533-L.jpg'),
(N'Hayvan Çiftliği', '9789750718526', 2, 1, 55.00, 150, N'Stalin dönemi Sovyetler Birliği''nin alegorik bir eleştirisi.', '1945-08-17', 'https://covers.openlibrary.org/b/isbn/9789750718526-L.jpg'),
(N'Serenad', '9786050900286', 3, 1, 85.00, 120, N'İstanbul Üniversitesi''nden Struma gemisine uzanan hüzünlü bir aşk ve tarih yolculuğu.', '2011-01-01', 'https://covers.openlibrary.org/b/isbn/9786050900286-L.jpg'),
(N'Huzursuzluk', '9786050939866', 3, 1, 75.00, 90, N'Orta Doğu''nun acı gerçekleri ve bir gazetecinin arayışı.', '2017-01-01', 'https://covers.openlibrary.org/b/isbn/9786050939866-L.jpg'),
(N'Satranç', '9786053606116', 4, 1, 35.00, 180, N'Bir gemide geçen, satranç şampiyonu ile bir yabancının psikolojik düellosu.', '1941-01-01', 'https://covers.openlibrary.org/b/isbn/9786053606116-L.jpg'),
(N'Bilinmeyen Bir Kadının Mektubu', '9786053320647', 4, 1, 30.00, 140, N'İsimsiz bir kadının, hayatı boyunca sevdiği adama yazdığı itiraf mektubu.', '1922-01-01', 'https://covers.openlibrary.org/b/isbn/9786053320647-L.jpg'),
(N'Sapiens: Hayvanlardan Tanrılara', '9786050926637', 5, 3, 120.00, 75, N'İnsan türünün (Homo Sapiens) taş devrinden günümüze evrimi ve tarihi.', '2011-01-01', 'https://covers.openlibrary.org/b/isbn/9786050926637-L.jpg'),
(N'Homo Deus', '9786050939330', 5, 3, 125.00, 60, N'Yarının kısa bir tarihi. İnsanlığın geleceği ve olası senaryolar.', '2015-01-01', 'https://covers.openlibrary.org/b/isbn/9786050939330-L.jpg'),
(N'Suç ve Ceza', '9789754589023', 6, 1, 95.00, 110, N'Raskolnikov''un vicdan muhasebesi ve suç psikolojisi üzerine bir başyapıt.', '1866-01-01', 'https://covers.openlibrary.org/b/isbn/9789754589023-L.jpg'),
(N'Karamazov Kardeşler', '9789754589597', 6, 1, 140.00, 45, N'İnanç, şüphe, devlet ve kilise üzerine derin felsefi sorgulamalar içeren roman.', '1880-01-01', 'https://covers.openlibrary.org/b/isbn/9789754589597-L.jpg'),
(N'Şeker Portakalı', '9789750707964', 7, 5, 55.00, 250, N'Zeze''nin hüzünlü ve sıcak büyüme hikayesi.', '1968-01-01', 'https://covers.openlibrary.org/b/isbn/9789750707964-L.jpg'),
(N'Tutunamayanlar', '9789754700114', 8, 1, 130.00, 50, N'Türk edebiyatının en önemli eserlerinden biri.', '1972-01-01', 'https://covers.openlibrary.org/b/isbn/9789754700114-L.jpg'),
(N'Tehlikeli Oyunlar', '9789754702095', 8, 1, 110.00, 40, N'Hikmet Benol''un toplumla ve kendisiyle çatışması.', '1973-01-01', 'https://covers.openlibrary.org/b/isbn/9789754702095-L.jpg'),
(N'Dönüşüm', '9789750719356', 9, 1, 35.00, 130, N'Gregor Samsa''nın bir sabah dev bir böceğe dönüşmüş olarak uyanması.', '1915-01-01', 'https://covers.openlibrary.org/b/isbn/9789750719356-L.jpg'),
(N'Bir Ömür Nasıl Yaşanır?', '9786057635115', 10, 6, 85.00, 200, N'Hayatta doğru seçimler yapmak için tavsiyeler.', '2019-01-01', 'https://covers.openlibrary.org/b/isbn/9786057635115-L.jpg'),
(N'Gazi Mustafa Kemal Atatürk', '9786057635030', 10, 2, 95.00, 100, N'Atatürk''ün hayatı ve liderliği üzerine kapsamlı bir biyografi.', '2018-01-01', 'https://covers.openlibrary.org/b/isbn/9786057635030-L.jpg');

PRINT 'Books repopulated.';
GO
