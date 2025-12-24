namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Kitap modeli - Veritabanındaki Books tablosunu temsil eder
    /// </summary>
    public class Book
    {
        public int BookID { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? ISBN { get; set; }
        public int AuthorID { get; set; }
        public string AuthorName { get; set; } = string.Empty;
        public int CategoryID { get; set; }
        public string CategoryName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int StockQuantity { get; set; }
        public string? Description { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string StockStatus { get; set; } = string.Empty;
        public string? ImageURL { get; set; }
        public double AverageRating { get; set; }
        public int ReviewCount { get; set; }
        public string? Publisher { get; set; }
        public int? PageCount { get; set; }
        public string? Language { get; set; }
        public int? SellerID { get; set; }
    }
}





