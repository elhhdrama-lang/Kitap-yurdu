using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using WebKitapyurdu.Models;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Ana sayfa ve genel işlemler için controller
    /// </summary>
    public class HomeController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public HomeController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Ana sayfa - Tüm kitapları listeler
        /// </summary>
        public IActionResult Index()
        {
            try
            {
                var books = _dbHelper.GetAllBooks();
                var bestSelling = _dbHelper.GetBestSellingBooks(5);
                
                ViewBag.BestSelling = bestSelling;
                return View(books);
            }
            catch (Exception ex)
            {
                // Veritabanı bağlantı hatası durumunda kullanıcıya bilgi ver
                ViewBag.Error = "Veritabanı bağlantı hatası. Lütfen veritabanının oluşturulduğundan emin olun.";
                ViewBag.Details = ex.Message;
                return View(new List<Book>());
            }
        }

        /// <summary>
        /// Hakkında sayfası
        /// </summary>
        public IActionResult About()
        {
            return View();
        }

        /// <summary>
        /// İletişim sayfası
        /// </summary>
        public IActionResult Contact()
        {
            return View();
        }

        /// <summary>
        /// Hata sayfası
        /// </summary>
        public IActionResult Error()
        {
            return View();
        }

        /// <summary>
        /// Kitap arama
        /// </summary>
        public IActionResult Search(string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return RedirectToAction("Index");
            }

            try
            {
                var books = _dbHelper.SearchBooks(query);
                ViewBag.SearchQuery = query;
                ViewBag.ResultCount = books.Count;
                return View(books);
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Arama yapılırken bir hata oluştu: " + ex.Message;
                return View(new List<Book>());
            }
        }
    }
}

