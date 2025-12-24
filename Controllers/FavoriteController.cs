using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Favori işlemleri için controller
    /// </summary>
    public class FavoriteController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public FavoriteController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Favorilerim sayfası
        /// </summary>
        public IActionResult Index()
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return RedirectToAction("Login", "Auth");
            }

            try
            {
                var favorites = _dbHelper.GetUserFavorites(userId.Value);
                return View(favorites);
            }
            catch (Exception)
            {
                ViewBag.Error = "Favoriler yüklenirken bir hata oluştu.";
                return View(new List<Models.Favorite>());
            }
        }

        /// <summary>
        /// Favorilere ekle
        /// </summary>
        [HttpPost]
        public IActionResult Add(int bookId)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            try
            {
                if (_dbHelper.AddToFavorites(userId.Value, bookId))
                {
                    return Json(new { success = true, message = "Favorilere eklendi." });
                }
                return Json(new { success = false, message = "Bu ürün zaten favorilerinizde." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }

        /// <summary>
        /// Favorilerden çıkar
        /// </summary>
        [HttpPost]
        public IActionResult Remove(int bookId)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            try
            {
                if (_dbHelper.RemoveFromFavorites(userId.Value, bookId))
                {
                    return Json(new { success = true, message = "Favorilerden çıkarıldı." });
                }
                return Json(new { success = false, message = "Favorilerden çıkarılamadı." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }
    }
}

