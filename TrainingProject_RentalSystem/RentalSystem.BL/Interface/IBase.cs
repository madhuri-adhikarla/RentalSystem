using System;
using RentalSystem.DAL;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentalSystem.BL.Interface
{
    public interface IBase<T>
    {
        RentalSystemContext dbContext { get; }
        IEnumerable<T> GetAll();
        bool Insert(T Entity);
        bool Update(T Entity);
        
    }
}
