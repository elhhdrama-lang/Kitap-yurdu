USE KitapyurduDB;
GO

PRINT '========================================';
PRINT 'Deleting All Authors and Related Data';
PRINT '========================================';
GO

-- Step 1: Delete all related data first (to avoid foreign key constraint violations)
PRINT '';
PRINT 'Step 1: Deleting related data...';

-- Delete order details first
DELETE FROM OrderDetails;
PRINT '✓ OrderDetails cleared.';

-- Delete cart items
DELETE FROM Cart;
PRINT '✓ Cart cleared.';

-- Delete reviews
DELETE FROM Reviews;
PRINT '✓ Reviews cleared.';

-- Delete favorites if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Favorites')
BEGIN
    DELETE FROM Favorites;
    PRINT '✓ Favorites cleared.';
END

-- Delete stock movements if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StockMovements')
BEGIN
    DELETE FROM StockMovements;
    PRINT '✓ StockMovements cleared.';
END

-- Delete price change log if table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PriceChangeLog')
BEGIN
    DELETE FROM PriceChangeLog;
    PRINT '✓ PriceChangeLog cleared.';
END

-- Delete orders
DELETE FROM Orders;
PRINT '✓ Orders cleared.';

GO

-- Step 2: Delete all books (they reference authors)
PRINT '';
PRINT 'Step 2: Deleting all books...';

DELETE FROM Books;
PRINT '✓ All books deleted.';
GO

-- Step 3: Delete all authors
PRINT '';
PRINT 'Step 3: Deleting all authors...';

DELETE FROM Authors;
PRINT '✓ All authors deleted.';
GO

-- Step 4: Reset identity seeds (optional - starts IDs from 1 again)
PRINT '';
PRINT 'Step 4: Resetting identity seeds...';

DBCC CHECKIDENT ('Authors', RESEED, 0);
PRINT '✓ Authors identity reset.';

DBCC CHECKIDENT ('Books', RESEED, 0);
PRINT '✓ Books identity reset.';

GO

-- Step 5: Verify deletion
PRINT '';
PRINT '========================================';
PRINT 'Verification:';
PRINT '========================================';

SELECT COUNT(*) AS RemainingAuthors FROM Authors;
SELECT COUNT(*) AS RemainingBooks FROM Books;
SELECT COUNT(*) AS RemainingOrders FROM Orders;
SELECT COUNT(*) AS RemainingReviews FROM Reviews;

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! All authors and related data deleted.';
PRINT '========================================';
PRINT '';
PRINT 'You can now add authors manually with correct Turkish characters.';
PRINT 'Remember to use N prefix for Turkish text, example:';
PRINT 'INSERT INTO Authors (FirstName, LastName, Biography)';
PRINT 'VALUES (N''Sabahattin'', N''Ali'', N''Türk edebiyatının önemli yazarlarından'');';
PRINT '';
GO
