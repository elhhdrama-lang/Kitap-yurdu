using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using WebKitapyurdu.Models;

namespace WebKitapyurdu.Controllers
{
    public class SellerController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public SellerController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        // --- Auth ---

        [HttpGet]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Login(string username, string password)
        {
            var seller = _dbHelper.LoginSeller(username, password);
            if (seller != null)
            {
                HttpContext.Session.SetInt32("SellerID", seller.SellerID);
                HttpContext.Session.SetString("SellerUsername", seller.Username);
                HttpContext.Session.SetString("Role", "Seller"); 
                return RedirectToAction("Dashboard");
            }
            ViewBag.Error = "Kullanıcı adı veya şifre hatalı.";
            return View();
        }

        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Register(Seller seller)
        {
            if (ModelState.IsValid)
            {
                // Simple pass through, real app needs hash
                seller.PasswordHash = seller.PasswordHash; 
                if (_dbHelper.RegisterSeller(seller))
                {
                    TempData["Success"] = "Kayıt başarılı. Lütfen giriş yapın.";
                    return RedirectToAction("Login");
                }
                ViewBag.Error = "Kayıt başarısız (Kullanıcı adı/Email kullanımda olabilir).";
            }
            return View(seller);
        }

        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }

        // --- Dashboard & Products ---

        public IActionResult Dashboard()
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            // Summary stats could go here
            return View();
        }

        public IActionResult MyProducts()
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            var books = _dbHelper.GetBooksBySeller(sellerId.Value);
            return View(books);
        }

        [HttpGet]
        public IActionResult AddProduct()
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            ViewBag.Authors = _dbHelper.GetAllAuthors();
            ViewBag.Categories = _dbHelper.GetAllCategories();
            return View();
        }

        [HttpPost]
        public IActionResult AddProduct(Book book)
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            book.SellerID = sellerId.Value;

            if (ModelState.IsValid)
            {
                if (_dbHelper.AddBook(book))
                {
                    TempData["Success"] = "Ürün başarıyla eklendi.";
                    return RedirectToAction("MyProducts");
                }
                ViewBag.Error = "Ürün eklenirken bir veritabanı hatası oluştu. Lütfen bilgileri kontrol edip tekrar deneyin (ISBN benzersiz olmalıdır).";
            }
            else
            {
                ViewBag.Error = "Lütfen formdaki eksik veya hatalı alanları düzeltin.";
            }

            ViewBag.Authors = _dbHelper.GetAllAuthors();
            ViewBag.Categories = _dbHelper.GetAllCategories();
            return View(book);
        }

        [HttpGet]
        public IActionResult EditProduct(int id)
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            var books = _dbHelper.GetBooksBySeller(sellerId.Value);
            var book = books.FirstOrDefault(b => b.BookID == id);

            if (book == null) return NotFound("Bu kitap size ait değil veya bulunamadı.");

            ViewBag.Authors = _dbHelper.GetAllAuthors();
            ViewBag.Categories = _dbHelper.GetAllCategories();
            return View(book);
        }

        [HttpPost]
        public IActionResult EditProduct(Book book)
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            // Ownership check
            var existingBooks = _dbHelper.GetBooksBySeller(sellerId.Value);
            if (!existingBooks.Any(b => b.BookID == book.BookID))
            {
                return Unauthorized();
            }
            
            if (ModelState.IsValid)
            {
                if (_dbHelper.UpdateBook(book))
                {
                    TempData["Success"] = "Ürün başarıyla güncellendi.";
                    return RedirectToAction("MyProducts");
                }
                ViewBag.Error = "Güncelleme sırasında bir hata oluştu. Lütfen bilgileri kontrol edin.";
            }
            else
            {
                ViewBag.Error = "Lütfen formdaki eksik veya hatalı alanları düzeltin.";
            }

            ViewBag.Authors = _dbHelper.GetAllAuthors();
            ViewBag.Categories = _dbHelper.GetAllCategories();
            return View(book);
        }

        [HttpPost]
        public IActionResult DeleteProduct(int id)
        {
            var sellerId = HttpContext.Session.GetInt32("SellerID");
            if (sellerId == null) return RedirectToAction("Login");

            var books = _dbHelper.GetBooksBySeller(sellerId.Value);
            if (!books.Any(b => b.BookID == id))
            {
                return Unauthorized();
            }

            if (_dbHelper.DeleteBook(id))
            {
                TempData["Success"] = "Ürün silindi.";
            }
            else
            {
                TempData["Error"] = "Silinirken hata oluştu.";
            }
            return RedirectToAction("MyProducts");
        }
    }
}
