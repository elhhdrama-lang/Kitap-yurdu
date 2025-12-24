namespace WebKitapyurdu.Models
{
    public class Author
    {
        public int AuthorID { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string? Biography { get; set; }
        
        public string FullName => $"{FirstName} {LastName}".Trim();
    }
}
