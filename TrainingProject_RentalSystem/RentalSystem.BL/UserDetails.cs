using AutoMapper;
using RentalSystem.BL.Interface;
using RentalSystem.DAL;
using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RentalSystem.BL
{
    public class UserDetails : IBase<UserLoginModel>
    {
        //singleton Instance of the context class
        public RentalSystemContext dbContext => RentalSystemContext.Instance;


        // Insert a User Registration into the database

        public bool Insert(UserLoginModel entity)
        {
            UserLogin userLogin = null;
            bool status = false;
            try
            {
                userLogin = Mapper.Map<UserLogin>(entity);
                dbContext.UserLogins.Add(userLogin);
                dbContext.SaveChanges();
                status = true;
            }
            catch (Exception e)
            {

                throw e;
            }
            return status;
        }

        // User Login
        // returns the roleId of the user 
        public int Login(UserLoginModel entity)
        {

            UserLogin user = null;
            bool status = false;
           
                user = Mapper.Map<UserLogin>(entity);
                status = dbContext.UserLogins.Any(u => u.Email == user.Email && u.Password == user.Password);
                
           
            if (status)
            {
                user = dbContext.UserLogins.SingleOrDefault(i => i.Email == user.Email);
                int roleId = user.RoleId;
                HttpContext.Current.Session.Add("UserEmail", user.Email);
                HttpContext.Current.Session.Add("RoleId", roleId);
                HttpContext.Current.Session.Add("UserId", user.Id);
                return roleId;
            }
                
            else
                return 999;
        }

        public bool UpdateProfile(UserModel Entity)
        {
            bool status = false;
            User user = new User();
            try
            {
                Entity.Id = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                user = Mapper.Map<User>(Entity);
                dbContext.Users.Add(user);
                dbContext.SaveChanges();
                status = true;
            }
            catch (Exception e)
            {
                throw e;
            }
            return status;
        }

        public UserModel ProfileExists()
        {
            User model = new User();
            UserModel userModel = new UserModel();
            int userId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
            bool status = dbContext.Users.Any(i => i.Id == userId);
            if(status)
            {
                model = dbContext.Users.SingleOrDefault(i => i.Id == userId);
                userModel = Mapper.Map<UserModel>(model);
            }
            return userModel;
        }

       

        public IEnumerable<UserLoginModel> GetAll()
        {
            throw new NotImplementedException();
        }

        public bool Update(UserLoginModel Entity)
        {
            throw new NotImplementedException();
        }
    }
}
