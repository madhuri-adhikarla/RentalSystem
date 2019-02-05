using AutoMapper;
using RentalSystem.DAL;
using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentalSystem.BL.Helper
{
    public class AutoMapperHelperClass : Profile
    {
        public AutoMapperHelperClass()
        {
            CreateMap<UserLoginModel,UserLogin>();
            CreateMap<UserLogin, UserLoginModel>();

            CreateMap<ProductModel, Product>();
            CreateMap<Product, ProductModel>();

            CreateMap<Feedback, FeedbackModel>();
            CreateMap<FeedbackModel, Feedback>();

            CreateMap<User, UserModel>();
            CreateMap<UserModel, User>();

            CreateMap<RentModel, RentProduct>();
            CreateMap<RentProduct, RentModel>();

        }
    }
}
