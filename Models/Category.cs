namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Kategori modeli - Veritabanındaki Categories tablosunu temsil eder
    /// </summary>
    public class Category
    {
        public int CategoryID { get; set; }
        public string CategoryName { get; set; } = string.Empty;
        public string? Description { get; set; }
    }
}





