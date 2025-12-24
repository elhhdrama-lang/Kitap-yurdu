namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Kitap yorumu modeli - Veritabanındaki Reviews tablosunu temsil eder
    /// </summary>
    public class Review
    {
        public int ReviewID { get; set; }
        public int BookID { get; set; }
        public int UserID { get; set; }
        public string Username { get; set; } = string.Empty;
        public string BookTitle { get; set; } = string.Empty;
        public int Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime ReviewDate { get; set; }
    }
}

