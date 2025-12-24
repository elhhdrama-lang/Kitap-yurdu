USE KitapyurduDB;
GO

-- 1. Add Role column to Users table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Role')
BEGIN
    ALTER TABLE Users ADD Role NVARCHAR(20) NOT NULL DEFAULT 'Customer';
    PRINT 'Role column added to Users table.';
END
GO

-- 2. Create a specific Seller user
-- Password is 'seller123' (simple mock hash/storage for this demo)
IF NOT EXISTS (SELECT * FROM Users WHERE Username = 'seller')
BEGIN
    INSERT INTO Users (Username, Email, PasswordHash, Role, IsActive, CreatedDate)
    VALUES ('seller', 'seller@kitapyurdu.com', 'seller123', 'Seller', 1, GETDATE());
    PRINT 'Seller user created.';
END
ELSE
BEGIN
    UPDATE Users SET Role = 'Seller' WHERE Username = 'seller';
    PRINT 'Existing user "seller" updated to Seller role.';
END
GO

PRINT 'Database updated with Role support.';
GO
