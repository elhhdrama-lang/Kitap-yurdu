namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Favori ürün modeli
    /// </summary>
    public class Favorite
    {
        public int FavoriteID { get; set; }
        public int UserID { get; set; }
        public int BookID { get; set; }
        public string BookTitle { get; set; } = string.Empty;
        public string AuthorName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public DateTime AddedDate { get; set; }
    }
}

