using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Ödeme işlemleri için controller
    /// </summary>
    public class PaymentController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public PaymentController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Ödeme sayfası (kredi kartı simülasyonu)
        /// </summary>
        public IActionResult Index(string shippingAddress)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return RedirectToAction("Login", "Auth");
            }

            try
            {
                var cartItems = _dbHelper.GetUserCart(userId.Value);
                if (!cartItems.Any())
                {
                    TempData["Error"] = "Sepetiniz boş.";
                    return RedirectToAction("Index", "Cart");
                }

                var total = cartItems.Sum(item => item.SubTotal);
                ViewBag.Total = total;
                ViewBag.ShippingAddress = shippingAddress;
                return View();
            }
            catch (Exception)
            {
                TempData["Error"] = "Ödeme sayfası yüklenirken bir hata oluştu.";
                return RedirectToAction("Index", "Cart");
            }
        }

        /// <summary>
        /// Ödeme işlemini tamamla (simülasyon)
        /// </summary>
        [HttpPost]
        public IActionResult Process(string cardNumber, string cardName, string expiryDate, string cvv, string shippingAddress)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return RedirectToAction("Login", "Auth");
            }

            if (string.IsNullOrEmpty(shippingAddress))
            {
                TempData["Error"] = "Teslimat adresi gereklidir.";
                return RedirectToAction("Index", "Cart");
            }

            // Basit validasyon (simülasyon)
            if (string.IsNullOrWhiteSpace(cardNumber) || cardNumber.Replace(" ", "").Length < 16)
            {
                TempData["Error"] = "Geçerli bir kredi kartı numarası giriniz.";
                return RedirectToAction("Index", new { shippingAddress });
            }

            try
            {
                // Sipariş oluştur
                var orderId = _dbHelper.CreateOrder(userId.Value, shippingAddress);
                if (orderId > 0)
                {
                    TempData["Success"] = "Ödemeniz başarıyla tamamlandı. Sipariş numaranız: " + orderId;
                    return RedirectToAction("Details", "Order", new { id = orderId });
                }

                TempData["Error"] = "Sipariş oluşturulamadı.";
                return RedirectToAction("Index", "Cart");
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Ödeme işlemi sırasında bir hata oluştu: " + ex.Message;
                return RedirectToAction("Index", new { shippingAddress });
            }
        }
    }
}

