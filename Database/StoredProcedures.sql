
-- STORED PROCEDURES (SP)

USE KitapyurduDB;
GO


-- SP 1: Kullanıcıya göre siparişleri getir=
IF OBJECT_ID('sp_GetUserOrders', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetUserOrders;
GO

CREATE PROCEDURE sp_GetUserOrders
    @UserID INT
AS
BEGIN
    -- Kullanıcının tüm siparişlerini ve detaylarını getirir
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.Status,
        o.ShippingAddress,
        od.OrderDetailID,
        od.Quantity,
        od.UnitPrice,
        od.SubTotal,
        b.Title AS BookTitle,
        b.ISBN,
        a.FirstName + ' ' + a.LastName AS AuthorName
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Books b ON od.BookID = b.BookID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    WHERE o.UserID = @UserID
    ORDER BY o.OrderDate DESC;
END
GO


-- SP 2: Kategoriye göre kitapları getir
IF OBJECT_ID('sp_GetBooksByCategory', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBooksByCategory;
GO

CREATE PROCEDURE sp_GetBooksByCategory
    @CategoryID INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    -- Belirli bir kategorideki kitapları sayfalama ile getirir
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        b.Description,
        b.PublishedDate,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        (SELECT COUNT(*) FROM Books WHERE CategoryID = @CategoryID) AS TotalCount
    FROM Books b
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE b.CategoryID = @CategoryID
    ORDER BY b.CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO


-- SP 3: Sipariş oluştur
IF OBJECT_ID('sp_CreateOrder', 'P') IS NOT NULL
    DROP PROCEDURE sp_CreateOrder;
GO

CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @ShippingAddress NVARCHAR(500),
    @OrderID INT OUTPUT
AS
BEGIN
    -- Kullanıcının sepetindeki ürünlerden sipariş oluşturur
    DECLARE @TotalAmount DECIMAL(10,2) = 0;
    DECLARE @CartItemCount INT = 0;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Sepetteki ürünlerin toplam tutarını hesapla
        SELECT @TotalAmount = SUM(c.Quantity * b.Price)
        FROM Cart c
        INNER JOIN Books b ON c.BookID = b.BookID
        WHERE c.UserID = @UserID;
        
        -- Sepet boş mu kontrol et
        IF @TotalAmount IS NULL OR @TotalAmount = 0
        BEGIN
            RAISERROR('Sepetiniz boş!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Sipariş oluştur
        INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, Status)
        VALUES (@UserID, @TotalAmount, @ShippingAddress, 'Pending');
        
        SET @OrderID = SCOPE_IDENTITY();
        
        -- Sipariş detaylarını oluştur ve sepeti temizle
        INSERT INTO OrderDetails (OrderID, BookID, Quantity, UnitPrice, SubTotal)
        SELECT 
            @OrderID,
            c.BookID,
            c.Quantity,
            b.Price,
            c.Quantity * b.Price
        FROM Cart c
        INNER JOIN Books b ON c.BookID = b.BookID
        WHERE c.UserID = @UserID;
        
        -- Sepeti temizle
        DELETE FROM Cart WHERE UserID = @UserID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- SP 4: En çok satan kitapları getir
IF OBJECT_ID('sp_GetBestSellingBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBestSellingBooks;
GO

CREATE PROCEDURE sp_GetBestSellingBooks
    @TopCount INT = 10
AS
BEGIN
    -- En çok satılan kitapları getirir
    SELECT TOP (@TopCount)
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        c.CategoryName,
        SUM(od.Quantity) AS TotalSold,
        SUM(od.SubTotal) AS TotalRevenue
    FROM Books b
    INNER JOIN OrderDetails od ON b.BookID = od.BookID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories c ON b.CategoryID = c.CategoryID
    WHERE o.Status != 'Cancelled'
    GROUP BY b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, 
             a.FirstName, a.LastName, c.CategoryName
    ORDER BY TotalSold DESC;
END
GO

-- SP 5: Kullanıcı sepetini getir
IF OBJECT_ID('sp_GetUserCart', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetUserCart;
GO

CREATE PROCEDURE sp_GetUserCart
    @UserID INT
AS
BEGIN
    -- Kullanıcının sepetindeki ürünleri detaylı şekilde getirir
    SELECT 
        c.CartID,
        c.Quantity,
        c.AddedDate,
        b.BookID,
        b.Title,
        b.ISBN,
        b.Price,
        b.StockQuantity,
        (c.Quantity * b.Price) AS SubTotal,
        a.FirstName + ' ' + a.LastName AS AuthorName,
        cat.CategoryName
    FROM Cart c
    INNER JOIN Books b ON c.BookID = b.BookID
    INNER JOIN Authors a ON b.AuthorID = a.AuthorID
    INNER JOIN Categories cat ON b.CategoryID = cat.CategoryID
    WHERE c.UserID = @UserID
    ORDER BY c.AddedDate DESC;
    
    -- Toplam tutarı da getir
    SELECT 
        SUM(c.Quantity * b.Price) AS TotalAmount,
        SUM(c.Quantity) AS TotalItems
    FROM Cart c
    INNER JOIN Books b ON c.BookID = b.BookID
    WHERE c.UserID = @UserID;
END
GO

PRINT 'Tüm Stored Procedures başarıyla oluşturuldu!';
GO

