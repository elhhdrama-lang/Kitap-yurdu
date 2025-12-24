using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using WebKitapyurdu.Models;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Site genel yönetimi için Admin Controller
    /// </summary>
    public class AdminController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public AdminController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Admin olup olmadığını kontrol eden yardımcı metot
        /// </summary>
        private bool IsAdmin()
        {
            return HttpContext.Session.GetString("Role") == "Admin";
        }

        /// <summary>
        /// Admin Dashboard - Genel Bakış
        /// </summary>
        public IActionResult Dashboard()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var stats = _dbHelper.GetDashboardStats();
            ViewBag.Stats = stats;
            return View();
        }

        /// <summary>
        /// Kullanıcı Yönetimi
        /// </summary>
        public IActionResult Users()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var users = _dbHelper.GetAllUsers();
            return View(users);
        }

        [HttpPost]
        public IActionResult UpdateUserStatus(int userId, bool isActive)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            var result = _dbHelper.UpdateUserStatus(userId, isActive);
            return Json(new { success = result });
        }

        /// <summary>
        /// Satıcı Yönetimi
        /// </summary>
        public IActionResult Sellers()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var sellers = _dbHelper.GetAllSellers();
            return View(sellers);
        }

        [HttpPost]
        public IActionResult UpdateSellerStatus(int sellerId, bool isActive)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            var result = _dbHelper.UpdateSellerStatus(sellerId, isActive);
            return Json(new { success = result });
        }

        /// <summary>
        /// Kitap Yönetimi (Satıcıların kitaplarını da görebilir)
        /// </summary>
        public IActionResult Books()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var books = _dbHelper.GetAllBooks();
            return View(books);
        }

        /// <summary>
        /// Sipariş Yönetimi
        /// </summary>
        public IActionResult Orders()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var orders = _dbHelper.GetAllOrders();
            return View(orders);
        }

        [HttpPost]
        public IActionResult UpdateOrderStatus(int orderId, string status)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            var result = _dbHelper.UpdateOrderStatus(orderId, status);
            return Json(new { success = result });
        }

        /// <summary>
        /// Yorum Yönetimi
        /// </summary>
        public IActionResult Reviews()
        {
            if (!IsAdmin()) return RedirectToAction("Login", "Auth");

            var reviews = _dbHelper.GetAllReviews();
            return View(reviews);
        }

        [HttpPost]
        public IActionResult DeleteReview(int reviewId)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            var result = _dbHelper.DeleteReview(reviewId);
            return Json(new { success = result });
        }

        /// <summary>
        /// Yeni yazar ekler
        /// </summary>
        [HttpPost]
        public IActionResult AddAuthor(string firstName, string lastName, string? biography)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            try
            {
                var authorId = _dbHelper.AddAuthor(firstName, lastName, biography);
                return Json(new { success = true, authorId = authorId, message = "Yazar başarıyla eklendi" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Hata: " + ex.Message });
            }
        }

        /// <summary>
        /// Yeni kategori ekler
        /// </summary>
        [HttpPost]
        public IActionResult AddCategory(string categoryName, string? description)
        {
            if (!IsAdmin()) return Json(new { success = false, message = "Yetkisiz erişim" });

            try
            {
                var categoryId = _dbHelper.AddCategory(categoryName, description);
                return Json(new { success = true, categoryId = categoryId, message = "Kategori başarıyla eklendi" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Hata: " + ex.Message });
            }
        }
    }
}
