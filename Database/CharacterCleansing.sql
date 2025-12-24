-- =============================================
-- FINAL CHARACTER CLEANSING
-- Aggressive replacement of common encoding corruptions
-- =============================================

USE KitapyurduDB;
GO

PRINT 'Starting character cleansing...';

-- Fix Books table
DECLARE @Table NVARCHAR(50) = 'Books';
DECLARE @Column NVARCHAR(50);

-- Helper to update multiple columns
-- Title
UPDATE Books SET Title = REPLACE(Title, N'Ã‡', N'Ç');
UPDATE Books SET Title = REPLACE(Title, N'Ã§', N'ç');
UPDATE Books SET Title = REPLACE(Title, N'ÄŸ', N'ğ');
UPDATE Books SET Title = REPLACE(Title, N'Äž', N'Ğ');
UPDATE Books SET Title = REPLACE(Title, N'Ä±', N'ı');
UPDATE Books SET Title = REPLACE(Title, N'Ä°', N'İ');
UPDATE Books SET Title = REPLACE(Title, N'Ã¶', N'ö');
UPDATE Books SET Title = REPLACE(Title, N'Ã–', N'Ö');
UPDATE Books SET Title = REPLACE(Title, N'Ã¼', N'ü');
UPDATE Books SET Title = REPLACE(Title, N'Ãœ', N'Ü');
UPDATE Books SET Title = REPLACE(Title, N'ÅŸ', N'ş');
UPDATE Books SET Title = REPLACE(Title, N'Åž', N'Ş');
UPDATE Books SET Title = REPLACE(Title, N'?', N'ı') WHERE Title LIKE N'%Simyac?%'; -- Special case for known corruption
UPDATE Books SET Title = REPLACE(Title, N'Simyac?', N'Simyacı');

-- Description
UPDATE Books SET Description = REPLACE(Description, N'Ã‡', N'Ç');
UPDATE Books SET Description = REPLACE(Description, N'Ã§', N'ç');
UPDATE Books SET Description = REPLACE(Description, N'ÄŸ', N'ğ');
UPDATE Books SET Description = REPLACE(Description, N'Äž', N'Ğ');
UPDATE Books SET Description = REPLACE(Description, N'Ä±', N'ı');
UPDATE Books SET Description = REPLACE(Description, N'Ä°', N'İ');
UPDATE Books SET Description = REPLACE(Description, N'Ã¶', N'ö');
UPDATE Books SET Description = REPLACE(Description, N'Ã–', N'Ö');
UPDATE Books SET Description = REPLACE(Description, N'Ã¼', N'ü');
UPDATE Books SET Description = REPLACE(Description, N'Ãœ', N'Ü');
UPDATE Books SET Description = REPLACE(Description, N'ÅŸ', N'ş');
UPDATE Books SET Description = REPLACE(Description, N'Åž', N'Ş');

-- Fix Categories table
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ã‡', N'Ç');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ã§', N'ç');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'ÄŸ', N'ğ');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Äž', N'Ğ');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ä±', N'ı');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ä°', N'İ');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ã¶', N'ö');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ã–', N'Ö');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ã¼', N'ü');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Ãœ', N'Ü');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'ÅŸ', N'ş');
UPDATE Categories SET CategoryName = REPLACE(CategoryName, N'Åž', N'Ş');

-- Fix Authors table
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ã‡', N'Ç');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ã§', N'ç');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'ÄŸ', N'ğ');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Äž', N'Ğ');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ä±', N'ı');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ä°', N'İ');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ã¶', N'ö');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ã–', N'Ö');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ã¼', N'ü');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Ãœ', N'Ü');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'ÅŸ', N'ş');
UPDATE Authors SET FirstName = REPLACE(FirstName, N'Åž', N'Ş');

UPDATE Authors SET LastName = REPLACE(LastName, N'Ã‡', N'Ç');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ã§', N'ç');
UPDATE Authors SET LastName = REPLACE(LastName, N'ÄŸ', N'ğ');
UPDATE Authors SET LastName = REPLACE(LastName, N'Äž', N'Ğ');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ä±', N'ı');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ä°', N'İ');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ã¶', N'ö');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ã–', N'Ö');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ã¼', N'ü');
UPDATE Authors SET LastName = REPLACE(LastName, N'Ãœ', N'Ü');
UPDATE Authors SET LastName = REPLACE(LastName, N'ÅŸ', N'ş');
UPDATE Authors SET LastName = REPLACE(LastName, N'Åž', N'Ş');

PRINT '✓ Character cleansing complete.';
