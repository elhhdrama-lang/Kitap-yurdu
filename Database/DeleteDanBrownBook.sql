-- Dan Brown Polisiye kitabını (BookID: 113) tamamen silme script'i
USE KitapyurduDB;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Sipariş detaylarından sil
    DELETE FROM OrderDetails WHERE BookID = 113;
    PRINT 'OrderDetails tablosundan silindi.';

    -- 2. Sepetten sil
    DELETE FROM Cart WHERE BookID = 113;
    PRINT 'Cart tablosundan silindi.';

    -- 3. Değerlendirmelerden (Reviews) sil
    DELETE FROM Reviews WHERE BookID = 113;
    PRINT 'Reviews tablosundan silindi.';

    -- 4. Favorilerden sil
    DELETE FROM Favorites WHERE BookID = 113;
    PRINT 'Favorites tablosundan silindi.';

    -- 5. Stok hareketlerinden sil
    DELETE FROM StockMovements WHERE BookID = 113;
    PRINT 'StockMovements tablosundan silindi.';

    -- 6. Fiyat değişim loglarından sil
    DELETE FROM PriceChangeLog WHERE BookID = 113;
    PRINT 'PriceChangeLog tablosundan silindi.';

    -- 7. Kitaplar tablosundan sil
    DELETE FROM Books WHERE BookID = 113;
    PRINT 'Books tablosundan silindi.';

    COMMIT TRANSACTION;
    PRINT 'Kitap ve tüm referansları başarıyla silindi.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Hata oluştu, işlem geri alındı.';
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
