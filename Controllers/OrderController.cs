using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using System;
using WebKitapyurdu.Models;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Sipariş işlemleri için controller
    /// </summary>
    public class OrderController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public OrderController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Siparişleri listele
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
                var orders = _dbHelper.GetUserOrders(userId.Value);
                return View(orders);
            }
            catch (Exception)
            {
                ViewBag.Error = "Siparişler yüklenirken bir hata oluştu.";
                return View(new List<Order>());
            }
        }

        /// <summary>
        /// Sipariş oluştur - ödeme sayfasına yönlendir
        /// </summary>
        [HttpPost]
        public IActionResult Create(string shippingAddress)
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

            return RedirectToAction("Index", "Payment", new { shippingAddress });
        }

        /// <summary>
        /// Sipariş detayı
        /// </summary>
        public IActionResult Details(int id)
        {
            var userId = HttpContext.Session.GetInt32("UserID");
            if (userId == null)
            {
                return RedirectToAction("Login", "Auth");
            }

            try
            {
                var orders = _dbHelper.GetUserOrders(userId.Value);
                var order = orders.FirstOrDefault(o => o.OrderID == id);
                
                if (order == null)
                {
                    return NotFound();
                }

                return View(order);
            }
            catch (Exception)
            {
                ViewBag.Error = "Sipariş detayları yüklenirken bir hata oluştu.";
                return RedirectToAction("Index");
            }
        }
    }
}

