================================================================================
WEB KİTAPYURDU - VERİTABANI PROJESİ
================================================================================

PROJE AÇIKLAMASI
----------------
Web Kitapyurdu, Microsoft SQL Server veritabanı kullanılarak geliştirilmiş
bir e-ticaret web uygulamasıdır. Proje, ASP.NET Core MVC framework'ü ile
oluşturulmuştur.

TEKNİK GEREKSİNİMLER
--------------------
1. Microsoft SQL Server (2019 veya üzeri)
2. .NET 8.0 SDK
3. Visual Studio 2022 veya Visual Studio Code
4. Web tarayıcısı (Chrome, Firefox, Edge vb.)

KURULUM ADIMLARI
----------------

1. VERİTABANI KURULUMU
   -------------------
   a) SQL Server Management Studio (SSMS) veya Azure Data Studio'yu açın
   b) SQL Server'a bağlanın
   c) Database klasöründeki script dosyalarını sırasıyla çalıştırın:
      
      Sıralama:
      1. CreateDatabase.sql        - Veritabanı ve tabloları oluşturur
      2. StoredProcedures.sql      - Stored Procedure'ları oluşturur
      3. Triggers.sql              - Trigger'ları oluşturur
      4. Views.sql                 - View'ları oluşturur
      5. Functions.sql             - Fonksiyonları oluşturur
      6. InsertSampleData.sql      - Örnek verileri ekler (opsiyonel)

   d) Veritabanı bağlantı string'ini kontrol edin:
      - appsettings.json dosyasındaki ConnectionStrings bölümünü
        kendi SQL Server ayarlarınıza göre düzenleyin
      - Örnek: "Server=localhost;Database=KitapyurduDB;Integrated Security=True;TrustServerCertificate=True;"

2. PROJE KURULUMU
   --------------
   a) Proje klasörüne gidin (kitapyurdu klasörü)
   b) Terminal/Command Prompt'ta şu komutu çalıştırın:
      
      dotnet restore
      
   c) Projeyi çalıştırmak için:
      
      dotnet run
      
   d) Tarayıcıda şu adresi açın:
      
      https://localhost:5001 veya http://localhost:5000

3. İLK KULLANIM
   ------------
   a) Uygulama açıldığında ana sayfada kitaplar listelenir
   b) Giriş yapmak için sağ üstteki "Giriş" butonuna tıklayın
   c) Test kullanıcısı ile giriş yapabilirsiniz:
      - Kullanıcı Adı: testuser
      - Şifre: hashed_password_456
   d) Veya yeni bir hesap oluşturabilirsiniz

VERİTABANI YAPISI
-----------------

TABLOLAR:
---------
- Categories      : Kitap kategorileri
- Authors         : Yazarlar
- Books           : Kitaplar
- Users           : Kullanıcılar
- Orders          : Siparişler
- OrderDetails    : Sipariş detayları
- Cart            : Sepet
- StockMovements  : Stok hareketleri
- Reviews         : Kitap değerlendirmeleri
- PriceChangeLog  : Fiyat değişiklik logları
- UserWelcomeLog  : Kullanıcı hoş geldin logları

STORED PROCEDURES (5 ADET):
---------------------------
1. sp_GetUserOrders          : Kullanıcının siparişlerini getirir
2. sp_GetBooksByCategory      : Kategoriye göre kitapları getirir
3. sp_CreateOrder             : Sipariş oluşturur
4. sp_GetBestSellingBooks     : En çok satan kitapları getirir
5. sp_GetUserCart             : Kullanıcının sepetini getirir

TRIGGERS (4 ADET):
------------------
1. trg_OrderDetail_Insert_UpdateStock    : Sipariş detayı eklendiğinde stok azaltır
2. trg_Book_Update_LogPriceChange        : Kitap fiyatı değiştiğinde log tutar
3. trg_User_Insert_WelcomeLog            : Yeni kullanıcı kaydında hoş geldin logu
4. trg_Order_Update_RestoreStock         : Sipariş iptal edildiğinde stok geri ekler

VIEWS (1 ADET):
---------------
1. vw_BookDetails             : Kitap detaylarını yazar ve kategori bilgileriyle gösterir

FUNCTIONS (3+ ADET):
-------------------
1. fn_CalculateUserTotalOrderAmount      : Kullanıcının toplam sipariş tutarını hesaplar
2. fn_GetCategoryBookCount               : Kategorideki kitap sayısını getirir
3. fn_CalculateBookAverageRating         : Kitabın ortalama değerlendirme puanını hesaplar
4. fn_GetOrderCountByDateRange           : Tarih aralığındaki sipariş sayısını getirir

PROJE YAPISI
------------
kitapyurdu/
├── Database/                    # Veritabanı scriptleri
│   ├── CreateDatabase.sql
│   ├── StoredProcedures.sql
│   ├── Triggers.sql
│   ├── Views.sql
│   ├── Functions.sql
│   └── InsertSampleData.sql
├── Models/                      # Veri modelleri
│   ├── Book.cs
│   ├── User.cs
│   ├── Order.cs
│   └── CartItem.cs
├── Controllers/                 # MVC Controller'lar
│   ├── HomeController.cs
│   ├── BookController.cs
│   ├── AuthController.cs
│   ├── CartController.cs
│   └── OrderController.cs
├── Views/                       # Razor View dosyaları
│   ├── Home/
│   ├── Book/
│   ├── Auth/
│   ├── Cart/
│   └── Order/
├── Data/                        # Veritabanı yardımcı sınıfları
│   └── DatabaseHelper.cs
├── Program.cs                   # Uygulama giriş noktası
├── appsettings.json             # Yapılandırma dosyası
└── WebKitapyurdu.csproj         # Proje dosyası

KULLANIM
--------

1. KİTAPLARI GÖRÜNTÜLEME:
   - Ana sayfada tüm kitaplar listelenir
   - Kategorilere göre filtreleme yapılabilir
   - Kitap detay sayfasına tıklayarak detaylı bilgi görüntülenebilir

2. SEPET İŞLEMLERİ:
   - Giriş yapıldıktan sonra kitaplar sepete eklenebilir
   - Sepet sayfasından ürünler görüntülenebilir
   - Sipariş oluşturulabilir

3. SİPARİŞ İŞLEMLERİ:
   - Sepetten sipariş oluşturulabilir
   - Siparişlerim sayfasından geçmiş siparişler görüntülenebilir
   - Sipariş detayları görüntülenebilir

4. KULLANICI İŞLEMLERİ:
   - Yeni kullanıcı kaydı oluşturulabilir
   - Giriş/Çıkış yapılabilir

ÖNEMLİ NOTLAR
-------------
- Şifreler gerçek uygulamada hash'lenmelidir (şu an basit tutulmuştur)
- Veritabanı bağlantı string'i appsettings.json'da düzenlenmelidir
- Tüm veritabanı scriptleri SQL Server'da çalıştırılmalıdır
- Proje .NET 8.0 ile geliştirilmiştir

SORUN GİDERME
-------------
1. Veritabanı bağlantı hatası:
   - appsettings.json'daki connection string'i kontrol edin
   - SQL Server'ın çalıştığından emin olun
   - Windows Authentication veya SQL Authentication ayarlarını kontrol edin

2. Proje çalışmıyor:
   - .NET 8.0 SDK'nın yüklü olduğundan emin olun
   - "dotnet restore" komutunu çalıştırın
   - Port çakışması varsa Program.cs'de port numarasını değiştirin

3. Veritabanı scriptleri hata veriyor:
   - Scriptleri sırasıyla çalıştırdığınızdan emin olun
   - SQL Server versiyonunuzun uyumlu olduğundan emin olun

İLETİŞİM
--------
Proje hakkında sorularınız için:
- Veritabanı: Microsoft SQL Server
- Framework: ASP.NET Core MVC 8.0
- Proje Tipi: Web Uygulaması

================================================================================
SON GÜNCELLEME: 2025
================================================================================





