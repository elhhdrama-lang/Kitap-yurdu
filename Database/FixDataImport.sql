USE KitapyurduDB;
GO

-- Clear all data to ensure clean slate (in correct order of dependency)
DELETE FROM Reviews;
DELETE FROM Favorites;
DELETE FROM OrderDetails;
DELETE FROM Cart;
DELETE FROM Orders; -- Also clear orders as they depend on users/data
DELETE FROM Books;

-- We can clean or keep Authors/Categories. Let's keep distinct ones but clean duplicates if any (complex). 
-- Simplest is to assume we just need to find *one* valid ID for each.

-- Helper Variables
DECLARE @RomanID INT, @CocukID INT, @BilimID INT, @TarihID INT;
DECLARE @FyodorID INT, @OrwellID INT, @CoelhoID INT, @ExuperyID INT, @HarariID INT, @AtaturkID INT, @YasarKemalID INT, @VasconcelosID INT, @SabahattinAliID INT;

-- Categories (Ensure exists + Get ID)
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Roman') INSERT INTO Categories (CategoryName) VALUES ('Roman');
SELECT TOP 1 @RomanID = CategoryID FROM Categories WHERE CategoryName = 'Roman';

IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Çocuk') INSERT INTO Categories (CategoryName) VALUES ('Çocuk');
SELECT TOP 1 @CocukID = CategoryID FROM Categories WHERE CategoryName = 'Çocuk';

IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Bilim') INSERT INTO Categories (CategoryName) VALUES ('Bilim');
SELECT TOP 1 @BilimID = CategoryID FROM Categories WHERE CategoryName = 'Bilim';

IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = 'Tarih') INSERT INTO Categories (CategoryName) VALUES ('Tarih');
SELECT TOP 1 @TarihID = CategoryID FROM Categories WHERE CategoryName = 'Tarih';

-- Authors (Ensure exists + Get ID)
-- Fyodor Dostoyevski
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski') INSERT INTO Authors (FirstName, LastName) VALUES ('Fyodor', 'Dostoyevski');
SELECT TOP 1 @FyodorID = AuthorID FROM Authors WHERE FirstName = 'Fyodor' AND LastName = 'Dostoyevski';

-- George Orwell
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell') INSERT INTO Authors (FirstName, LastName) VALUES ('George', 'Orwell');
SELECT TOP 1 @OrwellID = AuthorID FROM Authors WHERE FirstName = 'George' AND LastName = 'Orwell';

-- Paulo Coelho
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Paulo' AND LastName = 'Coelho') INSERT INTO Authors (FirstName, LastName) VALUES ('Paulo', 'Coelho');
SELECT TOP 1 @CoelhoID = AuthorID FROM Authors WHERE FirstName = 'Paulo' AND LastName = 'Coelho';

-- Antoine de Saint-Exupéry
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Antoine' AND LastName = 'de Saint-Exupéry') INSERT INTO Authors (FirstName, LastName) VALUES ('Antoine', 'de Saint-Exupéry');
SELECT TOP 1 @ExuperyID = AuthorID FROM Authors WHERE FirstName = 'Antoine' AND LastName = 'de Saint-Exupéry';

-- Yuval Noah Harari
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Yuval Noah' AND LastName = 'Harari') INSERT INTO Authors (FirstName, LastName) VALUES ('Yuval Noah', 'Harari');
SELECT TOP 1 @HarariID = AuthorID FROM Authors WHERE FirstName = 'Yuval Noah' AND LastName = 'Harari';

-- Mustafa Kemal Atatürk
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Mustafa Kemal' AND LastName = 'Atatürk') INSERT INTO Authors (FirstName, LastName) VALUES ('Mustafa Kemal', 'Atatürk');
SELECT TOP 1 @AtaturkID = AuthorID FROM Authors WHERE FirstName = 'Mustafa Kemal' AND LastName = 'Atatürk';

-- Yaşar Kemal
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal') INSERT INTO Authors (FirstName, LastName) VALUES ('Yaşar', 'Kemal');
SELECT TOP 1 @YasarKemalID = AuthorID FROM Authors WHERE FirstName = 'Yaşar' AND LastName = 'Kemal';

-- Jose Mauro de Vasconcelos
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Jose Mauro' AND LastName = 'de Vasconcelos') INSERT INTO Authors (FirstName, LastName) VALUES ('Jose Mauro', 'de Vasconcelos');
SELECT TOP 1 @VasconcelosID = AuthorID FROM Authors WHERE FirstName = 'Jose Mauro' AND LastName = 'de Vasconcelos';

-- Sabahattin Ali
IF NOT EXISTS (SELECT 1 FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali') INSERT INTO Authors (FirstName, LastName) VALUES ('Sabahattin', 'Ali');
SELECT TOP 1 @SabahattinAliID = AuthorID FROM Authors WHERE FirstName = 'Sabahattin' AND LastName = 'Ali';


-- Insert Books
INSERT INTO Books (Title, AuthorID, CategoryID, Publisher, Price, Description, StockQuantity, ImageURL, ISBN, PageCount, Language, PublishedDate, CreatedDate)
VALUES 
('Suç ve Ceza', @FyodorID, @RomanID, 'İş Bankası Yayınları', 89.90, 'Dostoyevski''nin başyapıtlarından biri', 45, 'https://picsum.photos/seed/sucveceza/400/600', '9789754580235', 688, 'Türkçe', '2025-12-19', GETDATE()),
('1984', @OrwellID, @RomanID, 'Can Yayınları', 45.00, 'Totaliter bir rejimin kontrolü altındaki distopik bir dünya', 32, 'https://picsum.photos/seed/1984/400/600', '9789750718533', 352, 'Türkçe', '2025-12-19', GETDATE()),
('Simyacı', @CoelhoID, @RomanID, 'Can Yayınları', 38.50, 'Bir Endülüs çobanının hazinesini aramak için çıktığı yolculuk', 58, 'https://picsum.photos/seed/simyaci/400/600', '9789750707223', 176, 'Türkçe', '2025-12-19', GETDATE()),
('Küçük Prens', @ExuperyID, @CocukID, 'Can Çocuk Yayınları', 28.00, 'Tüm zamanların en çok okunan kitaplarından biri', 67, 'https://picsum.photos/seed/kucukprens/400/600', '9789750705694', 96, 'Türkçe', '2025-12-19', GETDATE()),
('Sapiens', @HarariID, @BilimID, 'Kolektif Kitap', 85.00, 'İnsanlığın evriminden günümüze kadar olan serüveni', 41, 'https://picsum.photos/seed/sapiens/400/600', '9786050915556', 536, 'Türkçe', '2025-12-19', GETDATE()),
('Nutuk', @AtaturkID, @TarihID, 'Türk Tarih Kurumu', 65.00, 'Türkiye Cumhuriyeti''nin kuruluş sürecini anlatan tarihi konuşma', 38, 'https://picsum.photos/seed/nutuk/400/600', '9789751617729', 720, 'Türkçe', '2025-12-19', GETDATE()),
('İnce Memed', @YasarKemalID, @RomanID, 'Yapı Kredi Yayınları', 42.00, 'Türk edebiyatının en önemli eserlerinden biri', 29, 'https://picsum.photos/seed/incememed/400/600', '9789750810527', 439, 'Türkçe', '2025-12-19', GETDATE()),
('Şeker Portakalı', @VasconcelosID, @RomanID, 'Can Yayınları', 35.00, 'Fakirlik içinde yaşayan beş yaşındaki Zeze''nin hikayesi', 0, 'https://picsum.photos/seed/sekerportakali/400/600', '9789750707964', 184, 'Türkçe', '2025-12-19', GETDATE()),
('Hayvan Çiftliği', @OrwellID, @RomanID, 'Can Yayınları', 32.00, 'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman', 62, 'https://picsum.photos/seed/hayvanciftligi/400/600', '9789750718526', 128, 'Türkçe', '2025-12-19', GETDATE()),
('Kürk Mantolu Madonna', @SabahattinAliID, @RomanID, 'Yapı Kredi Yayınları', 36.00, 'Türk edebiyatının en çok okunan aşk romanlarından biri', 55, 'https://picsum.photos/seed/kurkmantolu/400/600', '9789750809521', 176, 'Türkçe', '2025-12-19', GETDATE());

-- Seed Review
DECLARE @User1 INT = (SELECT TOP 1 UserID FROM Users);
DECLARE @SucVeCezaBookID INT = (SELECT TOP 1 BookID FROM Books WHERE Title = 'Suç ve Ceza');

IF @User1 IS NOT NULL AND @SucVeCezaBookID IS NOT NULL
BEGIN
   INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate)
   VALUES (@SucVeCezaBookID, @User1, 5, 'Harika bir kitap!', GETDATE());
END

PRINT 'Data import fixed and completed.';
GO
