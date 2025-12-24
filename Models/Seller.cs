using System.ComponentModel.DataAnnotations;

namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Seller model - Represents the Sellers table
    /// </summary>
    public class Seller
    {
        public int SellerID { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public string CompanyName { get; set; } = string.Empty;
        public string? ContactInfo { get; set; }
        public bool IsActive { get; set; } = true;
        public DateTime CreatedDate { get; set; }
    }
}
