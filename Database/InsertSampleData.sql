-- =============================================
-- Örnek Veri Ekleme Script'i
-- =============================================

USE KitapyurduDB;
GO

-- Kategoriler
INSERT INTO Categories (CategoryName, Description) VALUES
('Roman', 'Roman türü kitaplar'),
('Bilim Kurgu', 'Bilim kurgu türü kitaplar'),
('Tarih', 'Tarih kitapları'),
('Felsefe', 'Felsefe kitapları'),
('Biyografi', 'Biyografi kitapları');
GO

-- Yazarlar
INSERT INTO Authors (FirstName, LastName, Biography) VALUES
('Orhan', 'Pamuk', 'Nobel Edebiyat Ödülü sahibi Türk yazar'),
('Isaac', 'Asimov', 'Ünlü bilim kurgu yazarı'),
('Halil', 'İnalcık', 'Türk tarihçi ve akademisyen'),
('Platon', 'Antik', 'Antik Yunan filozofu'),
('Mustafa', 'Kemal', 'Türkiye Cumhuriyeti''nin kurucusu');
GO

-- Kitaplar
INSERT INTO Books (Title, ISBN, AuthorID, CategoryID, Price, StockQuantity, Description, PublishedDate) VALUES
('Kara Kitap', '9789750807567', 1, 1, 45.00, 50, 'Orhan Pamuk''un ünlü romanı', '1990-01-01'),
('Benim Adım Kırmızı', '9789750807574', 1, 1, 55.00, 30, 'Tarihi roman', '1998-01-01'),
('Vakıf Serisi', '9789750807581', 2, 2, 65.00, 40, 'Bilim kurgu klasiği', '1951-01-01'),
('Osmanlı Tarihi', '9789750807598', 3, 3, 75.00, 25, 'Osmanlı tarihi hakkında kapsamlı eser', '2000-01-01'),
('Devlet', '9789750807604', 4, 4, 35.00, 60, 'Platon''un ünlü eseri', '380-01-01');
GO

-- Kullanıcılar (şifreler hash'lenmiş olmalı, burada örnek)
INSERT INTO Users (Username, Email, PasswordHash, FirstName, LastName, Phone, Address) VALUES
('admin', 'admin@kitapyurdu.com', 'hashed_password_123', 'Admin', 'User', '555-0001', 'İstanbul'),
('testuser', 'test@example.com', 'hashed_password_456', 'Test', 'User', '555-0002', 'Ankara');
GO

PRINT 'Örnek veriler başarıyla eklendi!';
GO





