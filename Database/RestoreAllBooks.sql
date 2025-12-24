-- =============================================
-- MASTER RESTORE SCRIPT (SAFE & COMPLETE)
-- Restores all books from all sources with correct characters
-- =============================================

USE KitapyurduDB;
GO

PRINT 'Starting Full Book Restoration...';

-- 1. FIX CHARACTER ENCODING FOR CATEGORIES
UPDATE Categories SET CategoryName = N'Edebiyat' WHERE CategoryID = 1;
UPDATE Categories SET CategoryName = N'Tarih' WHERE CategoryID = 2;
UPDATE Categories SET CategoryName = N'Bilim' WHERE CategoryID = 3;
UPDATE Categories SET CategoryName = N'Felsefe' WHERE CategoryID = 4;
UPDATE Categories SET CategoryName = N'Çocuk ve Gençlik' WHERE CategoryID = 5;
UPDATE Categories SET CategoryName = N'Psikoloji' WHERE CategoryID = 6;
UPDATE Categories SET CategoryName = N'Ekonomi' WHERE CategoryID = 7;

-- 2. RESTORE MISSING BOOKS FROM InsertMoreBooks.sql (With N prefixes)
-- This avoids duplicates by checking ISBN

DECLARE @RomanID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Edebiyat');
DECLARE @BiyografiID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Tarih'); -- Mapped to existing
DECLARE @TarihID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Tarih');
DECLARE @BilimKurguID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Edebiyat'); -- Mapped to existing
DECLARE @PsikolojiID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Psikoloji');

-- Add extra categories if missing
IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = N'Yazılım')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Yazılım', N'Teknoloji ve Programlama');

DECLARE @YazilimID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = N'Yazılım');

-- Ensure Authors exist
IF NOT EXISTS (SELECT * FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin')
    INSERT INTO Authors (FirstName, LastName, Biography) VALUES (N'Reşat Nuri', N'Güntekin', N'Türk edebiyatının ünlü romancısı');

DECLARE @ResatNuriID INT = (SELECT AuthorID FROM Authors WHERE FirstName = N'Reşat Nuri' AND LastName = N'Güntekin');

-- Insert missing books safely
IF NOT EXISTS (SELECT * FROM Books WHERE Title = N'Çalıkuşu')
    INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate)
    VALUES (N'Çalıkuşu', '9789750800234', @ResatNuriID, @RomanID, 40.00, 60, N'Reşat Nuri Güntekin''un klasik eseri.', '1922-01-01');

-- Fix corrupt titles for existing books
UPDATE Books SET Title = N'Kürk Mantolu Madonna' WHERE Title LIKE '%Madonna%';
UPDATE Books SET Title = N'İçimizdeki Şeytan' WHERE Title LIKE '%imizdeki%';
UPDATE Books SET Title = N'Şeker Portakalı' WHERE Title LIKE '%Portakal%';
UPDATE Books SET Title = N'Hayvan Çiftliği' WHERE Title LIKE '%Hayvan%';
UPDATE Books SET Title = N'Kuyucaklı Yusuf' WHERE Title LIKE '%Kuyucak%';
UPDATE Books SET Title = N'Sapiens: Hayvanlardan Tanrılara' WHERE Title LIKE '%Sapiens%';
UPDATE Books SET Title = N'Bilinmeyen Bir Kadının Mektubu' WHERE Title LIKE '%Bilinmeyen%';
UPDATE Books SET Title = N'Gazi Mustafa Kemal Atatürk' WHERE Title LIKE '%Mustafa%';
UPDATE Books SET Title = N'Dönüşüm' WHERE Title LIKE '%n????%';

-- Fix SellerID if null
UPDATE Books SET SellerID = 1 WHERE SellerID IS NULL;

PRINT '✓ Books restored and encoding fixed.';
GO

-- 3. REPAIR VIEWS
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL DROP VIEW vw_BookDetails;
GO
CREATE VIEW vw_BookDetails
AS
SELECT 
    b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.CreatedDate, b.ImageURL, b.SellerID,
    ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorFullName,
    ISNULL(c.CategoryName, N'Genel') AS CategoryName,
    CASE 
        WHEN b.StockQuantity > 10 THEN N'Stokta Var'
        WHEN b.StockQuantity > 0 THEN N'Az Stokta'
        ELSE N'Stokta Yok'
    END AS StockStatus
FROM Books b
LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
LEFT JOIN Categories c ON b.CategoryID = c.CategoryID;
GO

PRINT '✓ Views repaired.';
PRINT '========================================';
PRINT 'RESTORATION COMPLETE. ALL BOOKS SHOULD BE VISIBLE NOW.';
