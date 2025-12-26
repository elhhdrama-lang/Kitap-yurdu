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
                if (books == null || books.Count == 0)
                {
                    ViewBag.Warning = "Veritabanından hiç kitap gelmedi (Liste boş).";
                    // Debug verisi:
                    ViewBag.DebugInfo = "Bağlantı başarılı ama veri yok.";
                }


                var bestSelling = _dbHelper.GetBestSellingBooks(5);
                ViewBag.BestSelling = bestSelling;
                
                return View(books);
            }
            catch (Exception ex)
            {
                // Hatanın tamamını göster
                ViewBag.Error = "Veri çekme hatası: " + ex.Message;
                ViewBag.ErrorDetail = ex.ToString(); 
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

