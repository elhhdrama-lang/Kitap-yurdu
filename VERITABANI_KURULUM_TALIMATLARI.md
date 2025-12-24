# Veritabanı Kurulum Talimatları

## Sorun
Eğer şu hatayı alıyorsanız:
```
Database 'KitapyurduDB' does not exist
```

Bu, veritabanının henüz oluşturulmadığı anlamına gelir.

## Çözüm

### Adım 1: Temel Veritabanını Oluşturun
Önce temel veritabanı yapısını oluşturmanız gerekiyor:

1. SQL Server Management Studio (SSMS) veya SQL Server'ınızı açın
2. `Database/SetupDatabase.sql` dosyasını açın
3. Bu dosyayı çalıştırın (F5 veya Execute)
4. Script'in başarıyla tamamlandığını kontrol edin

Bu script şunları yapacak:
- `KitapyurduDB` veritabanını oluşturur
- Tüm temel tabloları oluşturur (Users, Books, Orders, Cart, vb.)
- Stored procedure'ları oluşturur
- Views'ları oluşturur

### Adım 2: Güncelleme Script'ini Çalıştırın
Temel veritabanı oluşturulduktan sonra:

1. `Database/UpdateDatabaseForNewFeatures.sql` dosyasını açın
2. Bu dosyayı çalıştırın (F5 veya Execute)
3. Script'in başarıyla tamamlandığını kontrol edin

Bu script şunları yapacak:
- `Favorites` tablosunu oluşturur
- `Orders` tablosuna `TrackingNumber` ve `ShippingInfo` kolonlarını ekler
- `Reviews` tablosunun var olduğunu kontrol eder

## Alternatif: Tüm Script'leri Sırayla Çalıştırma

Eğer SetupDatabase.sql dosyası yoksa veya eksikse, şu sırayla çalıştırın:

1. `CreateDatabase.sql` - Veritabanı ve temel tablolar
2. `StoredProcedures.sql` - Stored procedure'lar
3. `Views.sql` - Views
4. `Functions.sql` - Functions
5. `Triggers.sql` - Triggers
6. `InsertSampleData.sql` - Örnek veriler (opsiyonel)
7. `UpdateDatabaseForNewFeatures.sql` - Yeni özellikler için güncellemeler

## Hata Kontrolü

Script çalıştırırken şu hataları alıyorsanız:

### "Database does not exist"
→ Önce SetupDatabase.sql'i çalıştırın

### "Foreign key references invalid table"
→ Tabloların doğru sırayla oluşturulduğundan emin olun (SetupDatabase.sql'i çalıştırın)

### "Cannot find the object"
→ Eksik bir script var demektir, yukarıdaki sırayı takip edin

## Başarılı Kurulum Kontrolü

Veritabanı başarıyla kurulduysa şu tablolar olmalı:
- ✅ Users
- ✅ Books
- ✅ Authors
- ✅ Categories
- ✅ Orders
- ✅ OrderDetails
- ✅ Cart
- ✅ Reviews
- ✅ Favorites
- ✅ StockMovements

Bu tabloları kontrol etmek için:
```sql
USE KitapyurduDB;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
```

## Yardım

Sorun devam ederse:
1. SQL Server'ın çalıştığından emin olun
2. Windows kullanıcınızın SQL Server'a erişim izni olduğundan emin olun
3. Script'leri sırayla ve tek tek çalıştırmayı deneyin

