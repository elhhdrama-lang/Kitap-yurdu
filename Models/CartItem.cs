namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Sepet öğesi modeli - Veritabanındaki Cart tablosunu temsil eder
    /// </summary>
    public class CartItem
    {
        public int CartID { get; set; }
        public int UserID { get; set; }
        public int BookID { get; set; }
        public string BookTitle { get; set; } = string.Empty;
        public string AuthorName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal SubTotal { get; set; }
        public int StockQuantity { get; set; }
    }
}





