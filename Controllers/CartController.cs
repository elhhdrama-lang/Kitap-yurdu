using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Sepet işlemleri için controller
    /// </summary>
    public class CartController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public CartController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Sepeti görüntüle
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
                var cartItems = _dbHelper.GetUserCart(userId.Value);
                return View(cartItems);
            }
            catch (Exception)
            {
                ViewBag.Error = "Sepet yüklenirken bir hata oluştu.";
                return View(new List<Models.CartItem>());
            }
        }

        /// <summary>
        /// Sepete ürün ekle
        /// </summary>
        [HttpPost]
        public IActionResult Add(int bookId, int quantity = 1)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            try
            {
                var result = _dbHelper.AddToCart(userId.Value, bookId, quantity);
                var cartCount = _dbHelper.GetCartCount(userId.Value);
                return Json(new { success = result.Success, message = result.Message, cartCount = cartCount });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }

        /// <summary>
        /// Sepet öğesi güncelle (miktar değiştir)
        /// </summary>
        [HttpPost]
        public IActionResult Update(int cartId, int quantity)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            try
            {
                var result = _dbHelper.UpdateCartItem(cartId, quantity);
                var cartCount = _dbHelper.GetCartCount(userId.Value);
                return Json(new { success = result.Success, message = result.Message, cartCount = cartCount });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }

        /// <summary>
        /// Sepet öğesi sil
        /// </summary>
        [HttpPost]
        public IActionResult Remove(int cartId)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { success = false, message = "Giriş yapmanız gerekiyor." });
            }

            try
            {
                if (_dbHelper.RemoveCartItem(cartId))
                {
                    var cartCount = _dbHelper.GetCartCount(userId.Value);
                    return Json(new { success = true, message = "Ürün sepetten çıkarıldı.", cartCount = cartCount });
                }
                return Json(new { success = false, message = "Ürün sepetten çıkarılamadı." });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Bir hata oluştu: " + ex.Message });
            }
        }

        /// <summary>
        /// Sepet sayısını getir
        /// </summary>
        [HttpGet]
        public IActionResult GetCount()
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return Json(new { count = 0 });
            }

            try
            {
                var count = _dbHelper.GetCartCount(userId.Value);
                return Json(new { count = count });
            }
            catch
            {
                return Json(new { count = 0 });
            }
        }
    }
}

