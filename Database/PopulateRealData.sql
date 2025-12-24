-- =============================================
-- GERÇEKÇİ VERİ DOLDURMA SCRIPT'İ
-- Doğru kitap kapakları (OpenLibrary API), yazarlar ve kategoriler
-- =============================================

USE kitapyurduDB;
GO

PRINT 'Cleaning existing data...';

-- Disable constraints
ALTER TABLE Books NOCHECK CONSTRAINT ALL;
ALTER TABLE Authors NOCHECK CONSTRAINT ALL;
ALTER TABLE Categories NOCHECK CONSTRAINT ALL;
ALTER TABLE Reviews NOCHECK CONSTRAINT ALL;
ALTER TABLE OrderDetails NOCHECK CONSTRAINT ALL;
ALTER TABLE Cart NOCHECK CONSTRAINT ALL;
ALTER TABLE Favorites NOCHECK CONSTRAINT ALL;

-- Clear tables
DELETE FROM Reviews;
DELETE FROM OrderDetails;
DELETE FROM Cart;
DELETE FROM Favorites;
DELETE FROM Orders;
DELETE FROM Books;
DELETE FROM Authors;
DELETE FROM Categories;

-- Enable constraints (we will insert in correct order)
ALTER TABLE Books CHECK CONSTRAINT ALL;
ALTER TABLE Authors CHECK CONSTRAINT ALL;
ALTER TABLE Categories CHECK CONSTRAINT ALL;
ALTER TABLE Reviews CHECK CONSTRAINT ALL;
ALTER TABLE OrderDetails CHECK CONSTRAINT ALL;
ALTER TABLE Cart CHECK CONSTRAINT ALL;
ALTER TABLE Favorites CHECK CONSTRAINT ALL;

-- =============================================
-- KATEGORİLER
-- =============================================
SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES
(1, N'Edebiyat', N'Roman, Hikaye, Şiir ve Deneme türleri'),
(2, N'Tarih', N'Türk ve Dünya Tarihi, Araştırma-İnceleme'),
(3, N'Bilim', N'Popüler Bilim, Fizik, Biyoloji, Matematik'),
(4, N'Felsefe', N'Batı ve Doğu Felsefesi, Klasik Metinler'),
(5, N'Çocuk ve Gençlik', N'Masal, Hikaye, Gençlik Romanları'),
(6, N'Psikoloji', N'İnsan Psikolojisi, Kişisel Gelişim'),
(7, N'Ekonomi', N'İktisat Teorisi, İş Dünyası, Finans');
SET IDENTITY_INSERT Categories OFF;

-- =============================================
-- YAZARLAR
-- =============================================
SET IDENTITY_INSERT Authors ON;
INSERT INTO Authors (AuthorID, FirstName, LastName, Biography) VALUES
(1, N'Sabahattin', N'Ali', N'Türk yazar ve şair. Toplumsal gerçekçi eserleriyle tanınır. Kürk Mantolu Madonna ve Kuyucaklı Yusuf en bilinen eserleridir.'),
(2, N'George', N'Orwell', N'İngiliz yazar. Bin Dokuz Yüz Seksen Dört ve Hayvan Çiftliği gibi distopik eserleriyle tanınır.'),
(3, N'Zülfü', N'Livaneli', N'Türk müzisyen, yazar ve siyasetçi. Serenad ve Huzursuzluk gibi çok okunan romanların yazarıdır.'),
(4, N'Stefan', N'Zweig', N'Avusturyalı yazar. Satranç, Bilinmeyen Bir Kadının Mektubu gibi psikolojik derinliği olan eserleriyle ünlüdür.'),
(5, N'Yuval Noah', N'Harari', N'İsrailli tarihçi ve yazar. Sapiens ve Homo Deus kitaplarıyla dünya çapında ün kazanmıştır.'),
(6, N'Fyodor', N'Dostoyevski', N'Rus roman yazarı. Suç ve Ceza, Karamazov Kardeşler gibi dünya klasiklerinin yazarıdır.'),
(7, N'Jose Mauro', N'de Vasconcelos', N'Brezilyalı yazar. Şeker Portakalı adlı eseriyle tüm dünyada tanınır.'),
(8, N'Oğuz', N'Atay', N'Türk edebiyatının en önemli modern yazarlarından. Tutunamayanlar ile post-modern tarzın öncüsü olmuştur.'),
(9, N'Franz', N'Kafka', N'Bohemyalı Yahudi yazar. Dönüşüm ve Dava gibi eserleriyle modern edebiyatı derinden etkilemiştir.'),
(10, N'İlber', N'Ortaylı', N'Türk tarihçi ve akademisyen. Osmanlı tarihi konusundaki uzmanlığıyla tanınır.');
SET IDENTITY_INSERT Authors OFF;

-- =============================================
-- KİTAPLAR
-- Not: Görseller için OpenLibrary Cover API kullanıyoruz (ISBN tabanlı)
-- ya da bilinen statik görseller.
-- =============================================

-- Sabahattin Ali (ID: 1)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Kürk Mantolu Madonna', '9789753638029', 1, 1, 45.50, 100, N'Raif Efendi''nin içe kapanık yaşamı ve Berlin''de Maria Puder ile yaşadığı unutulmaz aşkın hikayesi.', '1943-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638029-L.jpg'),
(N'Kuyucaklı Yusuf', '9789753638036', 1, 1, 42.00, 85, N'Taşra hayatının ve toplumsal adaletsizliklerin Yusuf''un gözünden anlatımı.', '1937-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638036-L.jpg'),
(N'İçimizdeki Şeytan', '9789753638043', 1, 1, 40.00, 60, N'Ömer ve Macide''nin aşkı etrafında aydın kesimin eleştirisi.', '1940-01-01', 'https://covers.openlibrary.org/b/isbn/9789753638043-L.jpg');

-- George Orwell (ID: 2)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'1984', '9789750718533', 2, 1, 65.00, 200, N'Büyük Birader''in gözetimi altındaki totaliter bir distopya.', '1949-06-08', 'https://covers.openlibrary.org/b/isbn/9789750718533-L.jpg'),
(N'Hayvan Çiftliği', '9789750718526', 2, 1, 55.00, 150, N'Stalin dönemi Sovyetler Birliği''nin alegorik bir eleştirisi.', '1945-08-17', 'https://covers.openlibrary.org/b/isbn/9789750718526-L.jpg');

-- Zülfü Livaneli (ID: 3)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Serenad', '9786050900286', 3, 1, 85.00, 120, N'İstanbul Üniversitesi''nden Struma gemisine uzanan hüzünlü bir aşk ve tarih yolculuğu.', '2011-01-01', 'https://covers.openlibrary.org/b/isbn/9786050900286-L.jpg'),
(N'Huzursuzluk', '9786050939866', 3, 1, 75.00, 90, N'Orta Doğu''nun acı gerçekleri ve bir gazetecinin arayışı.', '2017-01-01', 'https://covers.openlibrary.org/b/isbn/9786050939866-L.jpg');

-- Stefan Zweig (ID: 4)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Satranç', '9786053606116', 4, 1, 35.00, 180, N'Bir gemide geçen, satranç şampiyonu ile bir yabancının psikolojik düellosu.', '1941-01-01', 'https://covers.openlibrary.org/b/isbn/9786053606116-L.jpg'),
(N'Bilinmeyen Bir Kadının Mektubu', '9786053320647', 4, 1, 30.00, 140, N'İsimsiz bir kadının, hayatı boyunca sevdiği adama yazdığı itiraf mektubu.', '1922-01-01', 'https://covers.openlibrary.org/b/isbn/9786053320647-L.jpg');

-- Yuval Noah Harari (ID: 5)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Sapiens: Hayvanlardan Tanrılara', '9786050926637', 5, 3, 120.00, 75, N'İnsan türünün (Homo Sapiens) taş devrinden günümüze evrimi ve tarihi.', '2011-01-01', 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1420585954l/24264297.jpg'),
(N'Homo Deus', '9786050939330', 5, 3, 125.00, 60, N'Yarının kısa bir tarihi. İnsanlığın geleceği ve olası senaryolar.', '2015-01-01', 'https://covers.openlibrary.org/b/isbn/9786050939330-L.jpg');

-- Fyodor Dostoyevski (ID: 6)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Suç ve Ceza', '9789754589023', 6, 1, 95.00, 110, N'Raskolnikov''un vicdan muhasebesi ve suç psikolojisi üzerine bir başyapıt.', '1866-01-01', 'https://covers.openlibrary.org/b/isbn/9789754589023-L.jpg'),
(N'Karamazov Kardeşler', '9789754589597', 6, 1, 140.00, 45, N'İnanç, şüphe, devlet ve kilise üzerine derin felsefi sorgulamalar içeren roman.', '1880-01-01', 'https://covers.openlibrary.org/b/isbn/9789754589597-L.jpg');

-- Jose Mauro de Vasconcelos (ID: 7)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Şeker Portakalı', '9789750707964', 7, 5, 55.00, 250, N'Zeze''nin hüzünlü ve sıcak büyüme hikayesi. "Günün birinde acıyı keşfeden küçük bir çocuğun öyküsü."', '1968-01-01', 'https://covers.openlibrary.org/b/isbn/9789750707964-L.jpg');

-- Oğuz Atay (ID: 8)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Tutunamayanlar', '9789754700114', 8, 1, 130.00, 50, N'Türk edebiyatının en önemli eserlerinden biri. Küçük burjuva dünyasına ironik bir bakış.', '1972-01-01', 'https://covers.openlibrary.org/b/isbn/9789754700114-L.jpg'),
(N'Tehlikeli Oyunlar', '9789754702095', 8, 1, 110.00, 40, N'Hikmet Benol''un toplumla ve kendisiyle çatışması.', '1973-01-01', 'https://covers.openlibrary.org/b/isbn/9789754702095-L.jpg');

-- Franz Kafka (ID: 9)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Dönüşüm', '9789750719356', 9, 1, 35.00, 130, N'Gregor Samsa''nın bir sabah dev bir böceğe dönüşmüş olarak uyanması.', '1915-01-01', 'https://covers.openlibrary.org/b/isbn/9789750719356-L.jpg');

-- İlber Ortaylı (ID: 10)
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate, ImageURL) VALUES
(N'Bir Ömür Nasıl Yaşanır?', '9786057635115', 10, 6, 85.00, 200, N'Hayatta doğru seçimler yapmak için tavsiyeler.', '2019-01-01', 'https://covers.openlibrary.org/b/isbn/9786057635115-L.jpg'),
(N'Gazi Mustafa Kemal Atatürk', '9786057635030', 10, 2, 95.00, 100, N'Atatürk''ün hayatı ve liderliği üzerine kapsamlı bir biyografi.', '2018-01-01', 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1516620583l/38096359._SX318_.jpg');

PRINT 'Data population completed.';
GO
