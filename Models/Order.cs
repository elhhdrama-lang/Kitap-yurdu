namespace WebKitapyurdu.Models
{
    /// <summary>
    /// Sipariş modeli - Veritabanındaki Orders tablosunu temsil eder
    /// </summary>
    public class Order
    {
        public int OrderID { get; set; }
        public int UserID { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; } = "Pending";
        public string? ShippingAddress { get; set; }
        public string? TrackingNumber { get; set; }
        public string? ShippingInfo { get; set; }
        public string Username { get; set; } = string.Empty;
        public List<OrderDetail> OrderDetails { get; set; } = new();
    }

    /// <summary>
    /// Sipariş detay modeli - Veritabanındaki OrderDetails tablosunu temsil eder
    /// </summary>
    public class OrderDetail
    {
        public int OrderDetailID { get; set; }
        public int OrderID { get; set; }
        public int BookID { get; set; }
        public string BookTitle { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal SubTotal { get; set; }
    }
}





