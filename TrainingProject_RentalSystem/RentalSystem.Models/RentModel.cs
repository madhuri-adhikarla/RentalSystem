using System;

namespace RentalSystem.Models
{
    public class RentModel
    {
        public int Id { get; set; }
        public int VendorId { get; set; }
        public string Email { get; set; }
        public int ProductId { get; set; }
        public int CategoryId { get; set; }
        public double UnitCost { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public double TotalCost { get; set; }
        public bool Payment { get; set; }
        public bool Status { get; set; }


    }
}
