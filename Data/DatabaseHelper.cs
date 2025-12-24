using Microsoft.Data.SqlClient;
using System.Data;
using WebKitapyurdu.Models;

namespace WebKitapyurdu.Data
{
    /// <summary>
    /// Veritabanı işlemleri için yardımcı sınıf
    /// Tüm veritabanı bağlantıları ve sorguları bu sınıf üzerinden yönetilir
    /// </summary>
    public class DatabaseHelper
    {
        private readonly string _connectionString;

        public DatabaseHelper(string connectionString)
        {
            _connectionString = connectionString;
        }

        /// <summary>
        /// Veritabanı bağlantısı oluşturur
        /// </summary>
        private SqlConnection GetConnection()
        {
            return new SqlConnection(_connectionString);
        }

        /// <summary>
        /// Tüm kitapları getirir
        /// </summary>
        public List<Book> GetAllBooks()
        {
            var books = new List<Book>();
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    // View kullanarak kitap detaylarını getir
                    var query = "SELECT * FROM vw_BookDetails ORDER BY CreatedDate DESC";
                    using (var command = new SqlCommand(query, connection))
                    {
                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                books.Add(new Book
                                {
                                    BookID = reader.GetInt32("BookID"),
                                    Title = reader.GetString("Title"),
                                    ISBN = reader.IsDBNull("ISBN") ? null : reader.GetString("ISBN"),
                                    AuthorID = reader.GetInt32("AuthorID"),
                                    AuthorName = reader.GetString("AuthorFullName"),
                                    CategoryID = reader.GetInt32("CategoryID"),
                                    CategoryName = reader.GetString("CategoryName"),
                                    Price = reader.GetDecimal("Price"),
                                    StockQuantity = reader.GetInt32("StockQuantity"),
                                    Description = reader.IsDBNull("Description") ? null : reader.GetString("Description"),
                                    PublishedDate = reader.IsDBNull("PublishedDate") ? null : reader.GetDateTime("PublishedDate"),
                                    StockStatus = reader.GetString("StockStatus"),
                                    ImageURL = reader.IsDBNull("ImageURL") ? null : reader.GetString("ImageURL"),
                                    AverageRating = reader.GetDouble("AverageRating"),
                                    ReviewCount = reader.GetInt32("ReviewCount"),
                                    Publisher = reader.IsDBNull("Publisher") ? null : reader.GetString("Publisher"),
                                    PageCount = reader.IsDBNull("PageCount") ? null : reader.GetInt32("PageCount"),
                                    Language = reader.IsDBNull("Language") ? null : reader.GetString("Language"),
                                    SellerID = reader.IsDBNull("SellerID") ? null : reader.GetInt32("SellerID")
                                });
                            }
                        }
                    }
                }
            }
            catch (SqlException ex) when (ex.Number == 4060) // Database does not exist
            {
                throw new Exception("Veritabanı bulunamadı. Lütfen Database/SetupDatabase.sql dosyasını SQL Server'da çalıştırın.", ex);
            }
            catch (SqlException ex) when (ex.Number == 18456) // Login failed
            {
                throw new Exception("SQL Server'a bağlanılamadı. Lütfen bağlantı ayarlarınızı kontrol edin.", ex);
            }
            return books;
        }

        /// <summary>
        /// Kategoriye göre kitapları getirir (Stored Procedure kullanır)
        /// </summary>
        public List<Book> GetBooksByCategory(int categoryId, int pageNumber = 1, int pageSize = 10)
        {
            var books = new List<Book>();
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand("sp_GetBooksByCategory", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CategoryID", categoryId);
                    command.Parameters.AddWithValue("@PageNumber", pageNumber);
                    command.Parameters.AddWithValue("@PageSize", pageSize);

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            books.Add(new Book
                            {
                                BookID = reader.GetInt32("BookID"),
                                Title = reader.GetString("Title"),
                                ISBN = reader.IsDBNull("ISBN") ? null : reader.GetString("ISBN"),
                                AuthorName = reader.GetString("AuthorName"),
                                CategoryName = reader.GetString("CategoryName"),
                                Price = reader.GetDecimal("Price"),
                                StockQuantity = reader.GetInt32("StockQuantity"),
                                Description = reader.IsDBNull("Description") ? null : reader.GetString("Description"),
                                PublishedDate = reader.IsDBNull("PublishedDate") ? null : reader.GetDateTime("PublishedDate"),
                                ImageURL = reader.IsDBNull("ImageURL") ? null : reader.GetString("ImageURL"),
                                AverageRating = reader.GetDouble("AverageRating"),
                                ReviewCount = reader.GetInt32("ReviewCount")
                            });
                        }
                    }
                }
            }
            return books;
        }

        /// <summary>
        /// Kullanıcı girişi yapar
        /// </summary>
        public User? LoginUser(string username, string password)
        {
            // Basit şifre kontrolü (gerçek uygulamada hash kullanılmalı)
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT * FROM Users WHERE Username = @Username AND PasswordHash = @Password AND IsActive = 1";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    command.Parameters.AddWithValue("@Password", password); // Gerçek uygulamada hash kullanılmalı

                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new User
                            {
                                UserID = reader.GetInt32("UserID"),
                                Username = reader.GetString("Username"),
                                Email = reader.GetString("Email"),
                                FirstName = reader.IsDBNull("FirstName") ? null : reader.GetString("FirstName"),
                                LastName = reader.IsDBNull("LastName") ? null : reader.GetString("LastName"),
                                Address = reader.IsDBNull("Address") ? null : reader.GetString("Address"),
                                Role = reader.GetString("Role")
                            };
                        }
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Kullanıcı kaydı oluşturur
        /// </summary>
        public bool RegisterUser(User user)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"INSERT INTO Users (Username, Email, PasswordHash, FirstName, LastName, Phone, Address, Role) 
                             VALUES (@Username, @Email, @PasswordHash, @FirstName, @LastName, @Phone, @Address, 'Customer')";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", user.Username);
                    command.Parameters.AddWithValue("@Email", user.Email);
                    command.Parameters.AddWithValue("@PasswordHash", user.PasswordHash);
                    command.Parameters.AddWithValue("@FirstName", (object?)user.FirstName ?? DBNull.Value);
                    command.Parameters.AddWithValue("@LastName", (object?)user.LastName ?? DBNull.Value);
                    command.Parameters.AddWithValue("@Phone", (object?)user.Phone ?? DBNull.Value);
                    command.Parameters.AddWithValue("@Address", (object?)user.Address ?? DBNull.Value);

                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Satıcı login işlemi
        /// </summary>
        public Seller? LoginSeller(string username, string password)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT * FROM Sellers WHERE Username = @Username AND PasswordHash = @PasswordHash AND IsActive = 1";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    command.Parameters.AddWithValue("@PasswordHash", password); 

                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new Seller
                            {
                                SellerID = reader.GetInt32("SellerID"),
                                Username = reader.GetString("Username"),
                                Email = reader.GetString("Email"),
                                CompanyName = reader.GetString("CompanyName"),
                                ContactInfo = reader.IsDBNull("ContactInfo") ? null : reader.GetString("ContactInfo"),
                                CreatedDate = reader.GetDateTime("CreatedDate")
                            };
                        }
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// Satıcı kayıt olma
        /// </summary>
        public bool RegisterSeller(Seller seller)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                // Basit şifre - hashlenmemiştir, demo amaçlı
                var query = @"INSERT INTO Sellers (Username, Email, PasswordHash, CompanyName, ContactInfo) 
                             VALUES (@Username, @Email, @PasswordHash, @CompanyName, @ContactInfo)";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Username", seller.Username);
                    command.Parameters.AddWithValue("@Email", seller.Email);
                    command.Parameters.AddWithValue("@PasswordHash", seller.PasswordHash);
                    command.Parameters.AddWithValue("@CompanyName", seller.CompanyName);
                    command.Parameters.AddWithValue("@ContactInfo", (object?)seller.ContactInfo ?? DBNull.Value);

                    try
                    {
                        return command.ExecuteNonQuery() > 0;
                    }
                    catch
                    {
                        return false; 
                    }
                }
            }
        }

        /// <summary>
        /// Sepete ürün ekler (stok kontrolü ile)
        /// </summary>
        public (bool Success, string Message) AddToCart(int userId, int bookId, int quantity)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                
                // Stok kontrolü
                var stock = GetBookStock(bookId);
                if (stock <= 0)
                {
                    return (false, "Bu ürün stokta bulunmamaktadır.");
                }

                // Eğer sepette varsa miktarı artır, yoksa yeni ekle
                var checkQuery = "SELECT CartID, Quantity FROM Cart WHERE UserID = @UserID AND BookID = @BookID";
                using (var checkCommand = new SqlCommand(checkQuery, connection))
                {
                    checkCommand.Parameters.AddWithValue("@UserID", userId);
                    checkCommand.Parameters.AddWithValue("@BookID", bookId);
                    
                    using (var reader = checkCommand.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Güncelle
                            var cartId = reader.GetInt32("CartID");
                            var currentQuantity = reader.GetInt32("Quantity");
                            reader.Close();
                            
                            var newQuantity = currentQuantity + quantity;
                            if (newQuantity > stock)
                            {
                                return (false, $"Stokta sadece {stock} adet ürün bulunmaktadır.");
                            }
                            
                            var updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE CartID = @CartID";
                            using (var updateCommand = new SqlCommand(updateQuery, connection))
                            {
                                updateCommand.Parameters.AddWithValue("@Quantity", newQuantity);
                                updateCommand.Parameters.AddWithValue("@CartID", cartId);
                                return (updateCommand.ExecuteNonQuery() > 0, "Ürün sepete eklendi.");
                            }
                        }
                    }
                }

                // Stok kontrolü
                if (quantity > stock)
                {
                    return (false, $"Stokta sadece {stock} adet ürün bulunmaktadır.");
                }

                // Yeni ekle
                var insertQuery = "INSERT INTO Cart (UserID, BookID, Quantity) VALUES (@UserID, @BookID, @Quantity)";
                using (var insertCommand = new SqlCommand(insertQuery, connection))
                {
                    insertCommand.Parameters.AddWithValue("@UserID", userId);
                    insertCommand.Parameters.AddWithValue("@BookID", bookId);
                    insertCommand.Parameters.AddWithValue("@Quantity", quantity);
                    return (insertCommand.ExecuteNonQuery() > 0, "Ürün sepete eklendi.");
                }
            }
        }

        /// <summary>
        /// Kullanıcının sepetini getirir (Stored Procedure kullanır)
        /// </summary>
        public List<CartItem> GetUserCart(int userId)
        {
            var cartItems = new List<CartItem>();
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand("sp_GetUserCart", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@UserID", userId);

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            cartItems.Add(new CartItem
                            {
                                CartID = reader.GetInt32("CartID"),
                                BookID = reader.GetInt32("BookID"),
                                BookTitle = reader.IsDBNull("Title") ? "Geçersiz Kitap" : reader.GetString("Title"),
                                AuthorName = reader.IsDBNull("AuthorName") ? "Bilinmeyen Yazar" : reader.GetString("AuthorName"),
                                Price = reader.IsDBNull("Price") ? 0 : reader.GetDecimal("Price"),
                                Quantity = reader.GetInt32("Quantity"),
                                SubTotal = reader.IsDBNull("SubTotal") ? 0 : reader.GetDecimal("SubTotal"),
                                StockQuantity = reader.IsDBNull("StockQuantity") ? 0 : reader.GetInt32("StockQuantity")
                            });
                        }
                    }
                }
            }
            return cartItems;
        }

        /// <summary>
        /// Sipariş oluşturur (Stored Procedure kullanır)
        /// </summary>
        public int CreateOrder(int userId, string shippingAddress)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand("sp_CreateOrder", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@UserID", userId);
                    command.Parameters.AddWithValue("@ShippingAddress", shippingAddress);
                    
                    var orderIdParam = new SqlParameter("@OrderID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    command.Parameters.Add(orderIdParam);

                    command.ExecuteNonQuery();
                    return (int)orderIdParam.Value;
                }
            }
        }

        /// <summary>
        /// Kullanıcının siparişlerini getirir (Stored Procedure kullanır)
        /// </summary>
        public List<Order> GetUserOrders(int userId)
        {
            var orders = new List<Order>();
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand("sp_GetUserOrders", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@UserID", userId);

                    using (var reader = command.ExecuteReader())
                    {
                        int currentOrderId = 0;
                        Order? currentOrder = null;

                        while (reader.Read())
                        {
                            var orderId = reader.GetInt32("OrderID");
                            
                            if (orderId != currentOrderId)
                            {
                                if (currentOrder != null)
                                {
                                    orders.Add(currentOrder);
                                }
                                
                                string? trackingNumber = null;
                                string? shippingInfo = null;
                                
                                try
                                {
                                    if (!reader.IsDBNull("TrackingNumber"))
                                        trackingNumber = reader.GetString("TrackingNumber");
                                }
                                catch { }
                                
                                try
                                {
                                    if (!reader.IsDBNull("ShippingInfo"))
                                        shippingInfo = reader.GetString("ShippingInfo");
                                }
                                catch { }
                                
                                currentOrder = new Order
                                {
                                    OrderID = orderId,
                                    UserID = userId,
                                    OrderDate = reader.GetDateTime("OrderDate"),
                                    TotalAmount = reader.GetDecimal("TotalAmount"),
                                    Status = reader.GetString("Status"),
                                    ShippingAddress = reader.IsDBNull("ShippingAddress") ? null : reader.GetString("ShippingAddress"),
                                    TrackingNumber = trackingNumber,
                                    ShippingInfo = shippingInfo,
                                    OrderDetails = new List<OrderDetail>()
                                };
                                currentOrderId = orderId;
                            }

                            if (currentOrder != null)
                            {
                                currentOrder.OrderDetails.Add(new OrderDetail
                                {
                                    OrderDetailID = reader.GetInt32("OrderDetailID"),
                                    OrderID = orderId,
                                    BookID = reader.GetInt32("BookID"),
                                    BookTitle = reader.GetString("BookTitle"),
                                    Quantity = reader.GetInt32("Quantity"),
                                    UnitPrice = reader.GetDecimal("UnitPrice"),
                                    SubTotal = reader.GetDecimal("SubTotal")
                                });
                            }
                        }

                        if (currentOrder != null)
                        {
                            orders.Add(currentOrder);
                        }
                    }
                }
            }
            return orders;
        }

        /// <summary>
        /// Tüm kategorileri getirir
        /// </summary>
        public List<Category> GetAllCategories()
        {
            var categories = new List<Category>();
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    var query = "SELECT * FROM Categories ORDER BY CategoryName";
                    using (var command = new SqlCommand(query, connection))
                    {
                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                categories.Add(new Category
                                {
                                    CategoryID = reader.GetInt32("CategoryID"),
                                    CategoryName = reader.GetString("CategoryName"),
                                    Description = reader.IsDBNull("Description") ? null : reader.GetString("Description")
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetAllCategories Error: " + ex.Message);
            }
            return categories;
        }

        /// <summary>
        /// En çok satan kitapları getirir (Stored Procedure kullanır)
        /// </summary>
        public List<Book> GetBestSellingBooks(int topCount = 10)
        {
            var books = new List<Book>();
            using (var connection = GetConnection())
            {
                connection.Open();
                using (var command = new SqlCommand("sp_GetBestSellingBooks", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@TopCount", topCount);

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            books.Add(new Book
                            {
                                BookID = reader.GetInt32("BookID"),
                                Title = reader.GetString("Title"),
                                ISBN = reader.IsDBNull("ISBN") ? null : reader.GetString("ISBN"),
                                AuthorName = reader.GetString("AuthorName"),
                                CategoryName = reader.GetString("CategoryName"),
                                Price = reader.GetDecimal("Price"),
                                StockQuantity = reader.GetInt32("StockQuantity"),
                                ImageURL = reader.IsDBNull("ImageURL") ? null : reader.GetString("ImageURL"),
                                AverageRating = reader.GetDouble("AverageRating"),
                                ReviewCount = reader.GetInt32("ReviewCount")
                            });
                        }
                    }
                }
            }
            return books;
        }

        /// <summary>
        /// Kitap arama
        /// </summary>
        public List<Book> SearchBooks(string searchTerm)
        {
            var books = new List<Book>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT DISTINCT b.BookID, b.Title, b.ISBN, b.Price, b.StockQuantity, b.Description, b.PublishedDate, b.ImageURL,
                             a.AuthorID, ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorFullName,
                             c.CategoryID, ISNULL(c.CategoryName, N'Genel') AS CategoryName,
                             CASE 
                                 WHEN b.StockQuantity > 10 THEN N'Stokta Var'
                                 WHEN b.StockQuantity > 0 THEN N'Az Stokta'
                                 ELSE N'Stokta Yok'
                             END AS StockStatus
                             FROM Books b
                             LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
                             LEFT JOIN Categories c ON b.CategoryID = c.CategoryID
                             WHERE b.Title COLLATE Turkish_CI_AI LIKE @SearchTerm 
                                OR a.FirstName COLLATE Turkish_CI_AI LIKE @SearchTerm 
                                OR a.LastName COLLATE Turkish_CI_AI LIKE @SearchTerm 
                                OR c.CategoryName COLLATE Turkish_CI_AI LIKE @SearchTerm 
                                OR b.Description COLLATE Turkish_CI_AI LIKE @SearchTerm
                             ORDER BY b.Title";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            books.Add(new Book
                            {
                                BookID = reader.GetInt32("BookID"),
                                Title = reader.GetString("Title"),
                                ISBN = reader.IsDBNull("ISBN") ? null : reader.GetString("ISBN"),
                                AuthorID = reader.IsDBNull("AuthorID") ? 0 : reader.GetInt32("AuthorID"),
                                AuthorName = reader.GetString("AuthorFullName"),
                                CategoryID = reader.IsDBNull("CategoryID") ? 0 : reader.GetInt32("CategoryID"),
                                CategoryName = reader.GetString("CategoryName"),
                                Price = reader.GetDecimal("Price"),
                                StockQuantity = reader.GetInt32("StockQuantity"),
                                Description = reader.IsDBNull("Description") ? null : reader.GetString("Description"),
                                PublishedDate = reader.IsDBNull("PublishedDate") ? null : reader.GetDateTime("PublishedDate"),
                                StockStatus = reader.GetString("StockStatus"),
                                ImageURL = reader.IsDBNull("ImageURL") ? null : reader.GetString("ImageURL")
                            });
                        }
                    }
                }
            }
            return books;
        }

        /// <summary>
        /// Kitap yorumlarını getirir
        /// </summary>
        public List<Review> GetBookReviews(int bookId)
        {
            var reviews = new List<Review>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT r.*, u.Username 
                             FROM Reviews r
                             INNER JOIN Users u ON r.UserID = u.UserID
                             WHERE r.BookID = @BookID
                             ORDER BY r.ReviewDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@BookID", bookId);
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            reviews.Add(new Review
                            {
                                ReviewID = reader.GetInt32("ReviewID"),
                                BookID = reader.GetInt32("BookID"),
                                UserID = reader.GetInt32("UserID"),
                                Username = reader.GetString("Username"),
                                Rating = reader.GetInt32("Rating"),
                                Comment = reader.IsDBNull("Comment") ? null : reader.GetString("Comment"),
                                ReviewDate = reader.GetDateTime("ReviewDate")
                            });
                        }
                    }
                }
            }
            return reviews;
        }

        /// <summary>
        /// Yorum ekler
        /// </summary>
        public bool AddReview(int userId, int bookId, int rating, string? comment)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"INSERT INTO Reviews (BookID, UserID, Rating, Comment, ReviewDate) 
                             VALUES (@BookID, @UserID, @Rating, @Comment, GETDATE())";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@BookID", bookId);
                    command.Parameters.AddWithValue("@UserID", userId);
                    command.Parameters.AddWithValue("@Rating", rating);
                    command.Parameters.AddWithValue("@Comment", (object?)comment ?? DBNull.Value);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Sepet öğesi güncelleme (miktar) - stok kontrolü ile
        /// </summary>
        public (bool Success, string Message) UpdateCartItem(int cartId, int quantity)
        {
            if (quantity <= 0)
            {
                return (false, "Miktar 0'dan büyük olmalıdır.");
            }

            using (var connection = GetConnection())
            {
                connection.Open();
                
                // Önce BookID'yi bul
                var getBookQuery = "SELECT BookID FROM Cart WHERE CartID = @CartID";
                int bookId = 0;
                using (var getBookCommand = new SqlCommand(getBookQuery, connection))
                {
                    getBookCommand.Parameters.AddWithValue("@CartID", cartId);
                    var result = getBookCommand.ExecuteScalar();
                    if (result == null)
                    {
                        return (false, "Sepet öğesi bulunamadı.");
                    }
                    bookId = Convert.ToInt32(result);
                }

                // Stok kontrolü
                var stock = GetBookStock(bookId);
                if (quantity > stock)
                {
                    return (false, $"Stokta sadece {stock} adet ürün bulunmaktadır.");
                }

                var query = "UPDATE Cart SET Quantity = @Quantity WHERE CartID = @CartID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Quantity", quantity);
                    command.Parameters.AddWithValue("@CartID", cartId);
                    return (command.ExecuteNonQuery() > 0, "Sepet güncellendi.");
                }
            }
        }

        /// <summary>
        /// Sepet öğesi silme
        /// </summary>
        public bool RemoveCartItem(int cartId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "DELETE FROM Cart WHERE CartID = @CartID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CartID", cartId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Sepetteki ürün sayısını getirir
        /// </summary>
        public int GetCartCount(int userId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT SUM(Quantity) FROM Cart WHERE UserID = @UserID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    var result = command.ExecuteScalar();
                    return result == DBNull.Value ? 0 : Convert.ToInt32(result);
                }
            }
        }

        /// <summary>
        /// Kitabın stok bilgisini getirir
        /// </summary>
        public int GetBookStock(int bookId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT StockQuantity FROM Books WHERE BookID = @BookID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@BookID", bookId);
                    var result = command.ExecuteScalar();
                    return result == null ? 0 : Convert.ToInt32(result);
                }
            }
        }

        /// <summary>
        /// Favorilere ekler
        /// </summary>
        public bool AddToFavorites(int userId, int bookId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                // Önce var mı kontrol et
                var checkQuery = "SELECT COUNT(*) FROM Favorites WHERE UserID = @UserID AND BookID = @BookID";
                using (var checkCommand = new SqlCommand(checkQuery, connection))
                {
                    checkCommand.Parameters.AddWithValue("@UserID", userId);
                    checkCommand.Parameters.AddWithValue("@BookID", bookId);
                    var exists = (int)checkCommand.ExecuteScalar() > 0;
                    
                    if (exists) return false; // Zaten favorilerde
                }

                var query = "INSERT INTO Favorites (UserID, BookID, AddedDate) VALUES (@UserID, @BookID, GETDATE())";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    command.Parameters.AddWithValue("@BookID", bookId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Favorilerden çıkarır
        /// </summary>
        public bool RemoveFromFavorites(int userId, int bookId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "DELETE FROM Favorites WHERE UserID = @UserID AND BookID = @BookID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    command.Parameters.AddWithValue("@BookID", bookId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Kullanıcının favorilerini getirir
        /// </summary>
        public List<Favorite> GetUserFavorites(int userId)
        {
            var favorites = new List<Favorite>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT f.FavoriteID, f.UserID, f.BookID, f.AddedDate,
                             b.Title AS BookTitle, ISNULL(a.FirstName + ' ' + a.LastName, N'Bilinmeyen Yazar') AS AuthorName, b.Price
                             FROM Favorites f
                             INNER JOIN Books b ON f.BookID = b.BookID
                             LEFT JOIN Authors a ON b.AuthorID = a.AuthorID
                             WHERE f.UserID = @UserID
                             ORDER BY f.AddedDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            favorites.Add(new Favorite
                            {
                                FavoriteID = reader.GetInt32("FavoriteID"),
                                UserID = reader.GetInt32("UserID"),
                                BookID = reader.GetInt32("BookID"),
                                BookTitle = reader.GetString("BookTitle"),
                                AuthorName = reader.GetString("AuthorName"),
                                Price = reader.GetDecimal("Price"),
                                AddedDate = reader.GetDateTime("AddedDate")
                            });
                        }
                    }
                }
            }
            return favorites;
        }

        /// <summary>
        /// Kitap favorilerde mi kontrol eder
        /// </summary>
        public bool IsFavorite(int userId, int bookId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT COUNT(*) FROM Favorites WHERE UserID = @UserID AND BookID = @BookID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserID", userId);
                    command.Parameters.AddWithValue("@BookID", bookId);
                    return (int)command.ExecuteScalar() > 0;
                }
            }
        }

        /// <summary>
        /// Siparişin kargo bilgisini günceller (satıcı için)
        /// </summary>
        public bool UpdateOrderTracking(int orderId, string trackingNumber, string? shippingInfo)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"UPDATE Orders 
                             SET TrackingNumber = @TrackingNumber, 
                                 ShippingInfo = @ShippingInfo,
                                 Status = 'Shipped'
                             WHERE OrderID = @OrderID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@OrderID", orderId);
                    command.Parameters.AddWithValue("@TrackingNumber", trackingNumber);
                    command.Parameters.AddWithValue("@ShippingInfo", (object?)shippingInfo ?? DBNull.Value);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Tüm yazarları getirir
        /// </summary>
        public List<Author> GetAllAuthors()
        {
            var authors = new List<Author>();
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    var query = "SELECT * FROM Authors ORDER BY FirstName, LastName";
                    using (var command = new SqlCommand(query, connection))
                    {
                        using (var reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                authors.Add(new Author
                                {
                                    AuthorID = reader.GetInt32("AuthorID"),
                                    FirstName = reader.GetString("FirstName"),
                                    LastName = reader.GetString("LastName"),
                                    Biography = reader.IsDBNull("Biography") ? null : reader.GetString("Biography")
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetAllAuthors Error: " + ex.Message);
            }
            return authors;
        }

        /// <summary>
        /// Yeni kitap ekler
        /// </summary>
        public bool AddBook(Book book)
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    var query = @"INSERT INTO Books (Title, AuthorID, CategoryID, Publisher, Price, Description, StockQuantity, ImageURL, ISBN, PageCount, Language, PublishedDate, SellerID, CreatedDate)
                                  VALUES (@Title, @AuthorID, @CategoryID, @Publisher, @Price, @Description, @StockQuantity, @ImageURL, @ISBN, @PageCount, @Language, @PublishedDate, @SellerID, GETDATE())";
                    
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@Title", book.Title ?? "");
                        command.Parameters.AddWithValue("@AuthorID", book.AuthorID);
                        command.Parameters.AddWithValue("@CategoryID", book.CategoryID);
                        command.Parameters.AddWithValue("@Publisher", (object?)book.Publisher ?? DBNull.Value);
                        
                        var priceParam = new SqlParameter("@Price", SqlDbType.Decimal) { Value = book.Price, Precision = 18, Scale = 2 };
                        command.Parameters.Add(priceParam);
                        
                        command.Parameters.AddWithValue("@Description", (object?)book.Description ?? DBNull.Value);
                        command.Parameters.AddWithValue("@StockQuantity", book.StockQuantity);
                        command.Parameters.AddWithValue("@ImageURL", (object?)book.ImageURL ?? DBNull.Value);
                        
                        // Handle empty ISBN as NULL
                        command.Parameters.AddWithValue("@ISBN", string.IsNullOrWhiteSpace(book.ISBN) ? DBNull.Value : book.ISBN);
                        
                        command.Parameters.AddWithValue("@PageCount", (object?)book.PageCount ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Language", (object?)book.Language ?? DBNull.Value);
                        command.Parameters.AddWithValue("@PublishedDate", (object?)book.PublishedDate ?? DBNull.Value);
                        command.Parameters.AddWithValue("@SellerID", (object?)book.SellerID ?? DBNull.Value);
                        
                        return command.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Hata durumunda loglama yapılabilir
                System.Diagnostics.Debug.WriteLine("AddBook Error: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Kitap günceller
        /// </summary>
        public bool UpdateBook(Book book)
        {
            try
            {
                using (var connection = GetConnection())
                {
                    connection.Open();
                    var query = @"UPDATE Books 
                                  SET Title = @Title, 
                                      AuthorID = @AuthorID, 
                                      CategoryID = @CategoryID, 
                                      Publisher = @Publisher,
                                      Price = @Price, 
                                      Description = @Description, 
                                      StockQuantity = @StockQuantity, 
                                      ImageURL = @ImageURL, 
                                      ISBN = @ISBN,
                                      PageCount = @PageCount,
                                      Language = @Language,
                                      PublishedDate = @PublishedDate
                                  WHERE BookID = @BookID";
                    
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@BookID", book.BookID);
                        command.Parameters.AddWithValue("@Title", book.Title ?? "");
                        command.Parameters.AddWithValue("@AuthorID", book.AuthorID);
                        command.Parameters.AddWithValue("@CategoryID", book.CategoryID);
                        command.Parameters.AddWithValue("@Publisher", (object?)book.Publisher ?? DBNull.Value);
                        
                        var priceParam = new SqlParameter("@Price", SqlDbType.Decimal) { Value = book.Price, Precision = 18, Scale = 2 };
                        command.Parameters.Add(priceParam);

                        command.Parameters.AddWithValue("@Description", (object?)book.Description ?? DBNull.Value);
                        command.Parameters.AddWithValue("@StockQuantity", book.StockQuantity);
                        command.Parameters.AddWithValue("@ImageURL", (object?)book.ImageURL ?? DBNull.Value);
                        
                        // Handle empty ISBN as NULL
                        command.Parameters.AddWithValue("@ISBN", string.IsNullOrWhiteSpace(book.ISBN) ? DBNull.Value : book.ISBN);
                        
                        command.Parameters.AddWithValue("@PageCount", (object?)book.PageCount ?? DBNull.Value);
                        command.Parameters.AddWithValue("@Language", (object?)book.Language ?? DBNull.Value);
                        command.Parameters.AddWithValue("@PublishedDate", (object?)book.PublishedDate ?? DBNull.Value);

                        return command.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateBook Error: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Kitap siler
        /// </summary>
        public bool DeleteBook(int bookId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "DELETE FROM Books WHERE BookID = @BookID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@BookID", bookId);
                    try 
                    {
                        return command.ExecuteNonQuery() > 0;
                    }
                    catch
                    {
                        return false; 
                    }
                }
            }
        }
        
        /// <summary>
        /// Satıcıya ait kitapları getirir
        /// </summary>
        public List<Book> GetBooksBySeller(int sellerId)
        {
            var books = new List<Book>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT * FROM vw_BookDetails WHERE SellerID = @SellerID ORDER BY CreatedDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SellerID", sellerId);
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            books.Add(new Book
                            {
                                BookID = reader.GetInt32("BookID"),
                                Title = reader.GetString("Title"),
                                ISBN = reader.IsDBNull("ISBN") ? null : reader.GetString("ISBN"),
                                AuthorName = reader.GetString("AuthorFullName"),
                                CategoryName = reader.GetString("CategoryName"),
                                Price = reader.GetDecimal("Price"),
                                StockQuantity = reader.GetInt32("StockQuantity"),
                                StockStatus = reader.GetString("StockStatus"),
                                ImageURL = reader.IsDBNull("ImageURL") ? null : reader.GetString("ImageURL"),
                                AverageRating = reader.GetDouble("AverageRating"),
                                ReviewCount = reader.GetInt32("ReviewCount"),
                                Publisher = reader.IsDBNull("Publisher") ? null : reader.GetString("Publisher"),
                                PageCount = reader.IsDBNull("PageCount") ? null : reader.GetInt32("PageCount"),
                                Language = reader.IsDBNull("Language") ? null : reader.GetString("Language"),
                                SellerID = sellerId
                            });
                        }
                    }
                }
            }
            return books;
        }


        /// <summary>
        /// Sipariş detaylarını getirir
        /// </summary>
        private List<OrderDetail> GetOrderDetails(int orderId)
        {
            var details = new List<OrderDetail>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT od.*, b.Title AS BookTitle
                             FROM OrderDetails od
                             INNER JOIN Books b ON od.BookID = b.BookID
                             WHERE od.OrderID = @OrderID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@OrderID", orderId);
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            details.Add(new OrderDetail
                            {
                                OrderDetailID = reader.GetInt32("OrderDetailID"),
                                OrderID = orderId,
                                BookID = reader.GetInt32("BookID"),
                                BookTitle = reader.GetString("BookTitle"),
                                Quantity = reader.GetInt32("Quantity"),
                                UnitPrice = reader.GetDecimal("UnitPrice"),
                                SubTotal = reader.GetDecimal("SubTotal")
                            });
                        }
                    }
                }
            }
            return details;
        }

        // =============================================
        // ADMIN DASHBOARD METOTLARI
        // =============================================

        /// <summary>
        /// Tüm kullanıcıları getirir
        /// </summary>
        public List<User> GetAllUsers()
        {
            var users = new List<User>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT * FROM Users ORDER BY CreatedDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            users.Add(new User
                            {
                                UserID = reader.GetInt32("UserID"),
                                Username = reader.GetString("Username"),
                                Email = reader.GetString("Email"),
                                FirstName = reader.IsDBNull("FirstName") ? null : reader.GetString("FirstName"),
                                LastName = reader.IsDBNull("LastName") ? null : reader.GetString("LastName"),
                                Role = reader.GetString("Role"),
                                IsActive = reader.GetBoolean("IsActive"),
                                CreatedDate = reader.GetDateTime("CreatedDate")
                            });
                        }
                    }
                }
            }
            return users;
        }

        /// <summary>
        /// Tüm satıcıları getirir
        /// </summary>
        public List<Seller> GetAllSellers()
        {
            var sellers = new List<Seller>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "SELECT * FROM Sellers ORDER BY CreatedDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            sellers.Add(new Seller
                            {
                                SellerID = reader.GetInt32("SellerID"),
                                Username = reader.GetString("Username"),
                                Email = reader.GetString("Email"),
                                CompanyName = reader.GetString("CompanyName"),
                                IsActive = reader.GetBoolean("IsActive"),
                                CreatedDate = reader.GetDateTime("CreatedDate")
                            });
                        }
                    }
                }
            }
            return sellers;
        }

        /// <summary>
        /// Tüm siparişleri getirir
        /// </summary>
        public List<Order> GetAllOrders()
        {
            var orders = new List<Order>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT o.*, u.Username 
                             FROM Orders o 
                             INNER JOIN Users u ON o.UserID = u.UserID 
                             ORDER BY o.OrderDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            var order = new Order
                            {
                                OrderID = reader.GetInt32("OrderID"),
                                UserID = reader.GetInt32("UserID"),
                                Username = reader.GetString("Username"),
                                OrderDate = reader.GetDateTime("OrderDate"),
                                TotalAmount = reader.GetDecimal("TotalAmount"),
                                Status = reader.GetString("Status"),
                                ShippingAddress = reader.IsDBNull("ShippingAddress") ? null : reader.GetString("ShippingAddress")
                            };
                            orders.Add(order);
                        }
                    }
                }
            }
            
            // Sipariş detaylarını da doldur (Lazy load alternatifi)
            foreach (var order in orders)
            {
                order.OrderDetails = GetOrderDetails(order.OrderID);
            }
            
            return orders;
        }

        /// <summary>
        /// Tüm yorumları getirir
        /// </summary>
        public List<Review> GetAllReviews()
        {
            var reviews = new List<Review>();
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"SELECT r.*, u.Username, b.Title as BookTitle 
                             FROM Reviews r 
                             INNER JOIN Users u ON r.UserID = u.UserID 
                             INNER JOIN Books b ON r.BookID = b.BookID 
                             ORDER BY r.ReviewDate DESC";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            reviews.Add(new Review
                            {
                                ReviewID = reader.GetInt32("ReviewID"),
                                BookID = reader.GetInt32("BookID"),
                                UserID = reader.GetInt32("UserID"),
                                Username = reader.GetString("Username"),
                                BookTitle = reader.GetString("BookTitle"),
                                Rating = reader.GetInt32("Rating"),
                                Comment = reader.IsDBNull("Comment") ? null : reader.GetString("Comment"),
                                ReviewDate = reader.GetDateTime("ReviewDate")
                            });
                        }
                    }
                }
            }
            return reviews;
        }

        /// <summary>
        /// Kullanıcı durumunu günceller (Aktif/Pasif)
        /// </summary>
        public bool UpdateUserStatus(int userId, bool isActive)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "UPDATE Users SET IsActive = @IsActive WHERE UserID = @UserID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@IsActive", isActive);
                    command.Parameters.AddWithValue("@UserID", userId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Satıcı durumunu günceller (Aktif/Pasif)
        /// </summary>
        public bool UpdateSellerStatus(int sellerId, bool isActive)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "UPDATE Sellers SET IsActive = @IsActive WHERE SellerID = @SellerID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@IsActive", isActive);
                    command.Parameters.AddWithValue("@SellerID", sellerId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Sipariş durumunu günceller
        /// </summary>
        public bool UpdateOrderStatus(int orderId, string status)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "UPDATE Orders SET Status = @Status WHERE OrderID = @OrderID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Status", status);
                    command.Parameters.AddWithValue("@OrderID", orderId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Yorumu siler
        /// </summary>
        public bool DeleteReview(int reviewId)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = "DELETE FROM Reviews WHERE ReviewID = @ReviewID";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@ReviewID", reviewId);
                    return command.ExecuteNonQuery() > 0;
                }
            }
        }

        /// <summary>
        /// Dashboard istatistiklerini getirir
        /// </summary>
        public dynamic GetDashboardStats()
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var stats = new System.Dynamic.ExpandoObject() as IDictionary<string, object>;

                // Toplam Kitap
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Books", connection))
                    stats["TotalBooks"] = cmd.ExecuteScalar() ?? 0;

                // Toplam Kullanıcı
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Customer'", connection))
                    stats["TotalCustomers"] = cmd.ExecuteScalar() ?? 0;

                // Toplam Satıcı
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Sellers", connection))
                    stats["TotalSellers"] = cmd.ExecuteScalar() ?? 0;

                // Toplam Sipariş
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Orders", connection))
                    stats["TotalOrders"] = cmd.ExecuteScalar() ?? 0;

                // Toplam Kazanç
                using (var cmd = new SqlCommand("SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE Status != 'Cancelled'", connection))
                    stats["TotalRevenue"] = cmd.ExecuteScalar() ?? 0;

                // Bekleyen Siparişler
                using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Orders WHERE Status = 'Pending'", connection))
                    stats["PendingOrders"] = cmd.ExecuteScalar() ?? 0;

                return stats;
            }
        }

        /// <summary>
        /// Yeni yazar ekler
        /// </summary>
        public int AddAuthor(string firstName, string lastName, string? biography)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"INSERT INTO Authors (FirstName, LastName, Biography, CreatedDate)
                             VALUES (@FirstName, @LastName, @Biography, GETDATE());
                             SELECT CAST(SCOPE_IDENTITY() as int)";
                
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@FirstName", firstName);
                    command.Parameters.AddWithValue("@LastName", lastName);
                    command.Parameters.AddWithValue("@Biography", (object?)biography ?? DBNull.Value);
                    
                    return (int)command.ExecuteScalar();
                }
            }
        }

        /// <summary>
        /// Yeni kategori ekler
        /// </summary>
        public int AddCategory(string categoryName, string? description)
        {
            using (var connection = GetConnection())
            {
                connection.Open();
                var query = @"INSERT INTO Categories (CategoryName, Description, CreatedDate)
                             VALUES (@CategoryName, @Description, GETDATE());
                             SELECT CAST(SCOPE_IDENTITY() as int)";
                
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CategoryName", categoryName);
                    command.Parameters.AddWithValue("@Description", (object?)description ?? DBNull.Value);
                    
                    return (int)command.ExecuteScalar();
                }
            }
        }
    }
}

