using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using WebKitapyurdu.Models;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Kullanıcı kimlik doğrulama işlemleri için controller
    /// </summary>
    public class AuthController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public AuthController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Giriş işlemi
        /// </summary>
        [HttpPost]
        public IActionResult Login(string username, string password, bool rememberMe = false)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ViewBag.Error = "Kullanıcı adı ve şifre gereklidir.";
                return View();
            }

            try
            {
                var user = _dbHelper.LoginUser(username, password);
                if (user != null)
                {
                    HttpContext.Session.SetInt32("UserID", user.UserID);
                    HttpContext.Session.SetInt32("UserID", user.UserID);
                    HttpContext.Session.SetString("Username", user.Username);
                    HttpContext.Session.SetString("Role", user.Role);

                    // "Beni hatırla" özelliği
                    if (rememberMe)
                    {
                        var options = new CookieOptions
                        {
                            Expires = DateTimeOffset.UtcNow.AddDays(30),
                            HttpOnly = true,
                            IsEssential = true
                        };
                        Response.Cookies.Append("RememberMe_UserID", user.UserID.ToString(), options);
                        Response.Cookies.Append("RememberMe_Username", user.Username, options);
                    }
                    else
                    {
                        // Cookie'yi temizle
                        Response.Cookies.Delete("RememberMe_UserID");
                        Response.Cookies.Delete("RememberMe_Username");
                    }

                    return RedirectToAction("Index", "Home");
                }

                ViewBag.Error = "Kullanıcı adı veya şifre hatalı.";
                return View();
            }
            catch (Exception ex)
            {
                ViewBag.Error = "Giriş yapılırken bir hata oluştu: " + ex.Message;
                return View();
            }
        }

        /// <summary>
        /// Giriş sayfası - Cookie kontrolü
        /// </summary>
        [HttpGet]
        public IActionResult Login()
        {
            // "Beni hatırla" cookie kontrolü
            if (Request.Cookies.ContainsKey("RememberMe_UserID"))
            {
                var userId = Request.Cookies["RememberMe_UserID"];
                var username = Request.Cookies["RememberMe_Username"];
                
                if (!string.IsNullOrEmpty(userId) && int.TryParse(userId, out int id))
                {
                    HttpContext.Session.SetInt32("UserID", id);
                    HttpContext.Session.SetString("Username", username ?? "");
                    return RedirectToAction("Index", "Home");
                }
            }

            return View();
        }

        /// <summary>
        /// Kayıt sayfası
        /// </summary>
        public IActionResult Register()
        {
            return View();
        }

        /// <summary>
        /// Kayıt işlemi
        /// </summary>
        [HttpPost]
        public IActionResult Register(User user)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Basit şifre hash (gerçek uygulamada güvenli hash kullanılmalı)
                    user.PasswordHash = user.PasswordHash; // Burada hash yapılmalı
                    
                    if (_dbHelper.RegisterUser(user))
                    {
                        return RedirectToAction("Login");
                    }
                    
                    ViewBag.Error = "Kayıt işlemi başarısız. Kullanıcı adı veya e-posta zaten kullanılıyor olabilir.";
                }
                catch (Exception ex)
                {
                    ViewBag.Error = "Kayıt işlemi sırasında bir hata oluştu: " + ex.Message;
                }
            }
            
            return View(user);
        }

        /// <summary>
        /// Çıkış işlemi
        /// </summary>
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            // "Beni hatırla" cookie'lerini temizle
            Response.Cookies.Delete("RememberMe_UserID");
            Response.Cookies.Delete("RememberMe_Username");
            return RedirectToAction("Index", "Home");
        }
    }
}

