USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Fixing Turkish Character Encoding Issues';
PRINT '========================================';
GO

-- Step 1: Fix Authors Table
PRINT '';
PRINT 'Step 1: Fixing Authors table...';
GO

-- Fix specific authors with encoding issues
UPDATE Authors SET Biography = N'Türk edebiyatının önemli yazarlarından' WHERE FirstName = 'Sabahattin' AND LastName = 'Ali';
UPDATE Authors SET Biography = N'Türk yazar' WHERE FirstName = 'Sabahattin' AND LastName = 'Yusuf';
UPDATE Authors SET Biography = N'Yazar, müzisyen ve siyasetçi' WHERE FirstName = 'Zülfü' AND LastName = 'Livaneli';
UPDATE Authors SET Biography = N'Türk yazar' WHERE FirstName = 'Zülfü' AND LastName = 'Huzursuzluk';
UPDATE Authors SET Biography = N'Türk edebiyatının önemli yazarlarından' WHERE FirstName = 'Oğuz' AND LastName = 'Atay';
UPDATE Authors SET Biography = N'Türk tarihçi' WHERE FirstName = 'İlber' AND LastName = 'Ortaylı';
UPDATE Authors SET Biography = N'Türk yazar' WHERE FirstName = 'İnci' AND LastName = 'Aral';
UPDATE Authors SET Biography = N'Türk yazar' WHERE FirstName = 'Hasan Ali' AND LastName = 'Toptaş';

PRINT '✓ Authors table fixed.';
GO

-- Step 2: Fix Books Table
PRINT '';
PRINT 'Step 2: Fixing Books table...';
GO

-- Fix book titles and descriptions with encoding issues
UPDATE Books SET Title = N'Kürk Mantolu Madonna' WHERE Title LIKE '%K%rk Mantolu Madonna%';
UPDATE Books SET Title = N'Kuyucaklı Yusuf' WHERE Title LIKE '%Kuyucakl%Yusuf%';
UPDATE Books SET Title = N'İçimizdeki Şeytan' WHERE Title LIKE '%imizdeki%eytan%';
UPDATE Books SET Title = N'Bilinmeyen Bir Kadının Mektubu' WHERE Title LIKE '%Bilinmeyen Bir Kad%n%n Mektubu%';
UPDATE Books SET Title = N'Hayvan Çiftliği' WHERE Title LIKE '%Hayvan%iftli%i%';
UPDATE Books SET Title = N'Suç ve Ceza' WHERE Title LIKE '%Su%ve Ceza%';
UPDATE Books SET Title = N'Bir Ömür Nasıl Yaşanır' WHERE Title LIKE '%Bir%m%r Nas%l Ya%an%r%';
UPDATE Books SET Title = N'Harry Potter ve Felsefe Taşı' WHERE Title LIKE '%Harry Potter ve Felsefe Ta%';

-- Fix descriptions
UPDATE Books SET Description = N'Sabahattin Ali''nin unutulmaz aşk romanı' WHERE Title = N'Kürk Mantolu Madonna';
UPDATE Books SET Description = N'Sabahattin Ali''nin ünlü romanı' WHERE Title = N'Kuyucaklı Yusuf';
UPDATE Books SET Description = N'Sabahattin Ali''nin kısa öyküleri' WHERE Title = N'İçimizdeki Şeytan';
UPDATE Books SET Description = N'Totaliter bir rejimin kontrolü altındaki distopik bir dünya' WHERE Title = '1984';
UPDATE Books SET Description = N'Zülfü Livaneli''nin duygusal romanı' WHERE Title = 'Serenad';
UPDATE Books SET Description = N'Zülfü Livaneli romanı' WHERE Title = 'Huzursuzluk';
UPDATE Books SET Description = N'Stefan Zweig''ın duygusal hikayesi' WHERE Title = N'Bilinmeyen Bir Kadının Mektubu';
UPDATE Books SET Description = N'Bir çiftlikteki hayvanların ayaklanmasını anlatan alegorik roman' WHERE Title = N'Hayvan Çiftliği';
UPDATE Books SET Description = N'Yarının kısa tarihi' WHERE Title = 'Homo Deus';
UPDATE Books SET Description = N'Dostoyevski''nin başyapıtlarından biri' WHERE Title = N'Suç ve Ceza';
UPDATE Books SET Description = N'Türk edebiyatının başyapıtlarından' WHERE Title = 'Tutunamayanlar';
UPDATE Books SET Description = N'İlber Ortaylı''nın hayat üzerine düşünceleri' WHERE Title = N'Bir Ömür Nasıl Yaşanır';
UPDATE Books SET Description = N'Atatürk hakkında kapsamlı biyografi' WHERE Title LIKE '%Gazi Mustafa Kemal Atat%rk%';
UPDATE Books SET Description = N'Fantastik edebiyatın başyapıtı' WHERE Title = N'Harry Potter ve Felsefe Taşı';
UPDATE Books SET Description = N'Çocuklar için duygusal bir hikaye' WHERE Title = 'Bebek Gemi';
UPDATE Books SET Description = N'Hasan Ali Toptaş''ın büyüleyici romanı' WHERE Title = 'Koca Deve';

-- Fix Publisher names
UPDATE Books SET Publisher = N'Yapı Kredi Yayınları' WHERE Publisher LIKE '%Yap%Kredi Yay%nlar%';
UPDATE Books SET Publisher = N'Can Yayınları' WHERE Publisher LIKE '%Can Yay%nlar%';
UPDATE Books SET Publisher = N'Doğan Kitap' WHERE Publisher LIKE '%Do%an Kitap%';
UPDATE Books SET Publisher = N'İş Bankası Yayınları' WHERE Publisher LIKE '%�?� Bankas%Yay%nlar%';
UPDATE Books SET Publisher = N'Türk Tarih Kurumu' WHERE Publisher LIKE '%T%rk Tarih Kurumu%';
UPDATE Books SET Publisher = N'Can Çocuk Yayınları' WHERE Publisher LIKE '%Can%ocuk Yay%nlar%';
UPDATE Books SET Publisher = N'İletişim Yayınları' WHERE Publisher LIKE '%letişim Yay%nlar%';

-- Fix Language
UPDATE Books SET Language = N'Türkçe' WHERE Language LIKE '%T%rk%e%';

PRINT '✓ Books table fixed.';
GO

-- Step 3: Fix Categories if needed
PRINT '';
PRINT 'Step 3: Fixing Categories table...';
GO

UPDATE Categories SET CategoryName = N'Çocuk Kitapları' WHERE CategoryName LIKE '%ocuk Kitaplar%';
UPDATE Categories SET Description = N'Roman türü kitaplar' WHERE CategoryName = 'Roman' AND Description LIKE '%Roman t%r%kitaplar%';
UPDATE Categories SET Description = N'Çocuklar için kitaplar' WHERE CategoryName LIKE N'%ocuk%' AND Description LIKE '%ocuklar i%in kitaplar%';
UPDATE Categories SET Description = N'Bilim kitapları' WHERE CategoryName = 'Bilim' AND Description LIKE '%Bilim kitaplar%';
UPDATE Categories SET Description = N'Tarih kitapları' WHERE CategoryName = 'Tarih' AND Description LIKE '%Tarih kitaplar%';
UPDATE Categories SET Description = N'Felsefe kitapları' WHERE CategoryName = 'Felsefe' AND Description LIKE '%Felsefe kitaplar%';

PRINT '✓ Categories table fixed.';
GO

-- Step 4: Verify the fixes
PRINT '';
PRINT 'Step 4: Verifying fixes...';
PRINT '';

SELECT 'Authors with potential encoding issues:' AS CheckType, COUNT(*) AS Count 
FROM Authors 
WHERE FirstName LIKE '%Ã%' OR LastName LIKE '%Ã%' OR Biography LIKE '%Ã%'
   OR FirstName LIKE '%�%' OR LastName LIKE '%�%' OR Biography LIKE '%�%';

SELECT 'Books with potential encoding issues:' AS CheckType, COUNT(*) AS Count 
FROM Books 
WHERE Title LIKE '%Ã%' OR Description LIKE '%Ã%' OR Publisher LIKE '%Ã%' OR Language LIKE '%Ã%'
   OR Title LIKE '%�%' OR Description LIKE '%�%' OR Publisher LIKE '%�%' OR Language LIKE '%�%';

SELECT 'Categories with potential encoding issues:' AS CheckType, COUNT(*) AS Count 
FROM Categories 
WHERE CategoryName LIKE '%Ã%' OR Description LIKE '%Ã%'
   OR CategoryName LIKE '%�%' OR Description LIKE '%�%';

PRINT '';
PRINT '========================================';
PRINT 'Turkish Character Fix Completed!';
PRINT '========================================';
PRINT '';
PRINT 'Sample of fixed data:';
SELECT TOP 5 FirstName, LastName, Biography FROM Authors WHERE Biography IS NOT NULL;
SELECT TOP 5 Title, Description, Publisher, Language FROM Books;
GO
