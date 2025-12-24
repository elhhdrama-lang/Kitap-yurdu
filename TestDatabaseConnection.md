# Web Sitesinde Kitapları Görüntüleme Kontrolü

## Sorun Giderme Adımları

### 1. Uygulamayı Yeniden Başlatın
- Visual Studio'da çalışıyorsa: **Stop** (Shift+F5) yapıp tekrar **Start** (F5) edin
- Terminal'de çalışıyorsa: Ctrl+C ile durdurup `dotnet run` ile tekrar başlatın

### 2. View'ın Oluşturulduğundan Emin Olun

SQL Server'da şu sorguyu çalıştırın:

```sql
USE KitapyurduDB;
GO

-- View var mı kontrol et
IF OBJECT_ID('vw_BookDetails', 'V') IS NOT NULL
    SELECT 'View mevcut' AS Durum
ELSE
    SELECT 'View YOK - Views.sql çalıştırılmalı' AS Durum;
GO
```

### 3. View'dan Kitapları Test Edin

```sql
USE KitapyurduDB;
GO

-- View'dan kitapları görüntüle (uygulama bunu kullanıyor)
SELECT * FROM vw_BookDetails
ORDER BY Title;
GO
```

### 4. Eğer View Yoksa

`Database/Views.sql` dosyasını çalıştırın.

### 5. Tarayıcı Cache'ini Temizleyin

- Ctrl+Shift+Delete ile tarayıcı cache'ini temizleyin
- Veya Ctrl+F5 ile hard refresh yapın

### 6. Hata Kontrolü

Uygulama çalışırken tarayıcı konsolunu (F12) açın ve hata var mı kontrol edin.

