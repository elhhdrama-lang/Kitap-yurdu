# ER DİYAGRAMI - WEB KİTAPYURDU VERİTABANI

## Tablolar ve İlişkiler

```
┌─────────────────┐
│   Categories    │
├─────────────────┤
│ CategoryID (PK) │
│ CategoryName    │
│ Description     │
│ CreatedDate     │
└────────┬────────┘
         │
         │ 1:N
         │
┌────────▼────────┐
│     Books       │
├─────────────────┤
│ BookID (PK)     │
│ Title           │
│ ISBN            │
│ AuthorID (FK)   │──┐
│ CategoryID (FK) │  │
│ Price           │  │
│ StockQuantity   │  │
│ Description     │  │
│ PublishedDate   │  │
│ CreatedDate     │  │
└────────┬────────┘  │
         │            │
         │ 1:N        │ 1:N
         │            │
┌────────▼────────┐  │
│  OrderDetails   │  │
├─────────────────┤  │
│ OrderDetailID   │  │
│ OrderID (FK)    │  │
│ BookID (FK)     │──┘
│ Quantity        │
│ UnitPrice       │
│ SubTotal        │
└────────┬────────┘
         │
         │ N:1
         │
┌────────▼────────┐
│     Orders      │
├─────────────────┤
│ OrderID (PK)    │
│ UserID (FK)     │──┐
│ OrderDate       │  │
│ TotalAmount     │  │
│ Status          │  │
│ ShippingAddress │  │
└─────────────────┘  │
                     │
                     │ 1:N
                     │
┌────────────────────▼──────┐
│         Users             │
├───────────────────────────┤
│ UserID (PK)               │
│ Username                  │
│ Email                     │
│ PasswordHash              │
│ FirstName                 │
│ LastName                  │
│ Phone                     │
│ Address                   │
│ CreatedDate               │
│ IsActive                  │
└───────────┬───────────────┘
            │
            │ 1:N
            │
┌───────────▼───────────────┐
│         Cart              │
├───────────────────────────┤
│ CartID (PK)               │
│ UserID (FK)               │
│ BookID (FK)               │
│ Quantity                  │
│ AddedDate                 │
└───────────────────────────┘

┌─────────────────┐
│    Authors      │
├─────────────────┤
│ AuthorID (PK)   │
│ FirstName       │
│ LastName        │
│ Biography       │
│ CreatedDate     │
└────────┬────────┘
         │
         │ 1:N
         │
         │ (Books tablosuna bağlı)
```

## İlişki Açıklamaları

### 1. Categories ↔ Books (1:N)
- Bir kategori birden fazla kitaba sahip olabilir
- Bir kitap sadece bir kategoriye ait olabilir
- Foreign Key: Books.CategoryID → Categories.CategoryID

### 2. Authors ↔ Books (1:N)
- Bir yazar birden fazla kitap yazabilir
- Bir kitap sadece bir yazara ait olabilir
- Foreign Key: Books.AuthorID → Authors.AuthorID

### 3. Users ↔ Orders (1:N)
- Bir kullanıcı birden fazla sipariş verebilir
- Bir sipariş sadece bir kullanıcıya ait olabilir
- Foreign Key: Orders.UserID → Users.UserID

### 4. Orders ↔ OrderDetails (1:N)
- Bir sipariş birden fazla sipariş detayına sahip olabilir
- Bir sipariş detayı sadece bir siparişe ait olabilir
- Foreign Key: OrderDetails.OrderID → Orders.OrderID

### 5. Books ↔ OrderDetails (1:N)
- Bir kitap birden fazla sipariş detayında yer alabilir
- Bir sipariş detayı sadece bir kitaba ait olabilir
- Foreign Key: OrderDetails.BookID → Books.BookID

### 6. Users ↔ Cart (1:N)
- Bir kullanıcı birden fazla sepet öğesine sahip olabilir
- Bir sepet öğesi sadece bir kullanıcıya ait olabilir
- Foreign Key: Cart.UserID → Users.UserID

### 7. Books ↔ Cart (1:N)
- Bir kitap birden fazla sepet öğesinde yer alabilir
- Bir sepet öğesi sadece bir kitaba ait olabilir
- Foreign Key: Cart.BookID → Books.BookID

## Ek Tablolar

### StockMovements
- Books ile 1:N ilişki
- Stok hareketlerini kaydeder (IN/OUT)

### Reviews
- Books ile 1:N ilişki
- Users ile 1:N ilişki
- Kitap değerlendirmelerini tutar

### PriceChangeLog
- Books ile 1:N ilişki
- Fiyat değişikliklerini loglar

### UserWelcomeLog
- Users ile 1:N ilişki
- Yeni kullanıcı kayıtlarını loglar

## Önemli Notlar

- Tüm Foreign Key'ler CASCADE DELETE kullanmaz (veri bütünlüğü için)
- Primary Key'ler IDENTITY(1,1) ile otomatik artar
- CreatedDate alanları GETDATE() ile otomatik doldurulur
- Status alanları varsayılan değerlere sahiptir





