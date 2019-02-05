using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentalSystem.DAL
{
    public partial class RentalSystemContext : DbContext
    {
        public static RentalSystemContext rentalSystemContext = null;

        public static RentalSystemContext Instance
        {
            get
            {
                if (rentalSystemContext == null)
                {
                    rentalSystemContext = new RentalSystemContext();
                }
                return rentalSystemContext;
            }
        }

    }
}
