namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Kullanıcı modeli - Veritabanındaki Users tablosunu temsil eder
    /// </summary>
    public class User
    {
        public int UserID { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Phone { get; set; }
        public string? Address { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsActive { get; set; }
        public string Role { get; set; } = "Customer";
    }
}





