//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RentalSystem.DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class RentProduct
    {
        public int Id { get; set; }
        public int VendorId { get; set; }
        public string Email { get; set; }
        public int ProductId { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public double TotalCost { get; set; }
        public double UnitCost { get; set; }
        public bool Payment { get; set; }
        public bool Status { get; set; }
        public Nullable<int> CategoryId { get; set; }
    
        public virtual Category Category { get; set; }
        public virtual Product Product { get; set; }
        public virtual User User { get; set; }
    }
}
