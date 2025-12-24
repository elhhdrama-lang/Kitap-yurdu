using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Yorum işlemleri için controller
    /// </summary>
    public class ReviewController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public ReviewController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Yorum ekle
        /// </summary>
        [HttpPost]
        public IActionResult Add(int bookId, int rating, string? comment)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            if (rating < 1 || rating > 5)
            {
                return Json(new { success = false, message = "Yıldız 1-5 arasında olmalıdır." });
            }

            try
            {
                if (_dbHelper.AddReview(userId.Value, bookId, rating, comment))
                {
                    return Json(new { success = true, message = "Yorumunuz eklendi." });
                }
                return Json(new { success = false, message = "Yorum eklenemedi." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }
    }
}

