using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentalSystem.Models
{
    public class ProductModel
    {
        public int ProductId { get; set; }
        public int VendorId { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public string Image1 { get; set; }
        public string Image2 { get; set; }
        public string Image3 { get; set; }
        public bool Availability { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public Nullable<int> CategoryId { get; set; }
        public double Rent { get; set; }

    }
}
