using Microsoft.AspNetCore.Mvc;
using WebKitapyurdu.Data;
using WebKitapyurdu.Models;
using System;

namespace WebKitapyurdu.Controllers
{
    /// <summary>
    /// Kitap işlemleri için controller
    /// </summary>
    public class BookController : Controller
    {
        private readonly DatabaseHelper _dbHelper;

        public BookController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        /// <summary>
        /// Kategoriye göre kitapları listeler
        /// </summary>
        public IActionResult Category(int id, int page = 1)
        {
            try
            {
                var books = _dbHelper.GetBooksByCategory(id, page, 10);
                var categories = _dbHelper.GetAllCategories();
                
                ViewBag.Categories = categories;
                ViewBag.CurrentCategoryId = id;
                ViewBag.CurrentPage = page;
                
                return View(books);
            }
            catch (Exception)
            {
                ViewBag.Error = "Veri yüklenirken bir hata oluştu.";
                return View(new List<Book>());
            }
        }

        /// <summary>
        /// Kitap detay sayfası
        /// </summary>
        public IActionResult Details(int id)
        {
            try
            {
                var books = _dbHelper.GetAllBooks();
                var book = books.FirstOrDefault(b => b.BookID == id);
                
                if (book == null)
                {
                    return NotFound();
                }

                // Yorumları getir
                var reviews = _dbHelper.GetBookReviews(id) ?? new List<Review>();
                ViewBag.Reviews = reviews;
                
                // Ortalama puanı hesapla ve modele ata
                if (reviews.Any())
                {
                    book.AverageRating = reviews.Average(r => r.Rating);
                    book.ReviewCount = reviews.Count;
                }
                else
                {
                    book.AverageRating = 0;
                    book.ReviewCount = 0;
                }

                ViewBag.AverageRating = book.AverageRating;
                ViewBag.ReviewCount = book.ReviewCount;

                // Favori mi kontrol et
                var userId = HttpContext.Session.GetInt32("UserID");
                ViewBag.IsFavorite = userId.HasValue && _dbHelper.IsFavorite(userId.Value, id);
                
                return View(book);
            }
            catch (Exception)
            {
                ViewBag.Error = "Kitap detayları yüklenirken bir hata oluştu.";
                return RedirectToAction("Index", "Home");
            }
        }
    }
}

