-- =============================================
-- EMERGENCY DATA REPAIR (SAFE)
-- Fixes: Character Encoding & Joining Issues
-- DOES NOT DELETE USERS OR BOOKS
-- =============================================

USE KitapyurduDB;
GO

PRINT 'Starting Safe Data Repair...';

-- 1. Fix Character Encoding for Categories
UPDATE Categories SET CategoryName = N'Edebiyat' WHERE CategoryID = 1;
UPDATE Categories SET CategoryName = N'Tarih' WHERE CategoryID = 2;
UPDATE Categories SET CategoryName = N'Bilim' WHERE CategoryID = 3;
UPDATE Categories SET CategoryName = N'Felsefe' WHERE CategoryID = 4;
UPDATE Categories SET CategoryName = N'Çocuk ve Gençlik', Description = N'Masal, Hikaye, Gençlik Romanları' WHERE CategoryID = 5;
UPDATE Categories SET CategoryName = N'Psikoloji' WHERE CategoryID = 6;
UPDATE Categories SET CategoryName = N'Ekonomi' WHERE CategoryID = 7;

-- 2. Fix Character Encoding for Authors
UPDATE Authors SET FirstName = N'Sabahattin', LastName = N'Ali' WHERE AuthorID = 1;
UPDATE Authors SET FirstName = N'Zülfü', LastName = N'Livaneli' WHERE AuthorID = 3;
UPDATE Authors SET FirstName = N'İlber', LastName = N'Ortaylı' WHERE AuthorID = 10;
UPDATE Authors SET FirstName = N'Oğuz', LastName = N'Atay' WHERE AuthorID = 8;

-- 3. Fix Character Encoding for core books (if they exists)
UPDATE Books SET Title = N'Kürk Mantolu Madonna' WHERE Title LIKE '%Madonna%';
UPDATE Books SET Title = N'İçimizdeki Şeytan' WHERE Title LIKE '%imizdeki%';
UPDATE Books SET Title = N'Şeker Portakalı' WHERE Title LIKE '%Portakal%';
UPDATE Books SET Title = N'Bir Ömür Nasıl Yaşanır?' WHERE Title LIKE '%Ya??an??r%';

PRINT '✓ Character encoding patched.';

-- 4. Ensure Robust Views (Ensure they use LEFT JOIN)
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL DROP VIEW vw_BookDetails;
GO
CREATE VIEW vw_BookDetails
AS
SELECT 
    b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.CreatedDate, b.ImageURL, b.Publisher, b.PageCount, b.Language, b.SellerID,
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

-- 5. Clear only ORPHANED cart items (Ghost cleanup)
-- This is safe as it only removes items that reference non-existent books
DELETE FROM Cart WHERE BookID NOT IN (SELECT BookID FROM Books);
DELETE FROM Favorites WHERE BookID NOT IN (SELECT BookID FROM Books);

PRINT '✓ Ghost cleanup finished.';
PRINT '========================================';
PRINT 'SAFE REPAIR COMPLETED.';
