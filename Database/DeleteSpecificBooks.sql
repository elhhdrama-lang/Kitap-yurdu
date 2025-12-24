-- =============================================
-- Script to delete "Simyacı" and "Türklerin Tarihi"
-- =============================================

USE KitapyurduDB;
GO

DECLARE @SimyaciID INT, @TurklerinTarihiID INT;

-- Get IDs
SELECT @SimyaciID = BookID FROM Books WHERE Title = N'Simyacı';
SELECT @TurklerinTarihiID = BookID FROM Books WHERE Title = N'Türklerin Tarihi';

PRINT 'Deleting Simyacı (ID: ' + CAST(ISNULL(@SimyaciID, 0) AS NVARCHAR) + ')';
PRINT 'Deleting Türklerin Tarihi (ID: ' + CAST(ISNULL(@TurklerinTarihiID, 0) AS NVARCHAR) + ')';

IF @SimyaciID IS NOT NULL OR @TurklerinTarihiID IS NOT NULL
BEGIN
    -- Delete from dependent tables
    DELETE FROM OrderDetails WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);
    DELETE FROM Cart WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);
    DELETE FROM StockMovements WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);
    DELETE FROM PriceChangeLog WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);
    DELETE FROM Favorites WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);
    DELETE FROM Reviews WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);

    -- Finally delete from Books table
    DELETE FROM Books WHERE BookID IN (@SimyaciID, @TurklerinTarihiID);

    PRINT '✓ Books and related records deleted successfully.';
END
ELSE
BEGIN
    PRINT '⚠ Books not found or already deleted.';
END
GO
