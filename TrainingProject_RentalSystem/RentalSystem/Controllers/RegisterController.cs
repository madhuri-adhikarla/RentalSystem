using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RentalSystem.Models;
using RentalSystem.BL.Helper;
using RentalSystem.BL;
using AutoMapper;

namespace RentalSystem.Controllers
{
    // UserOperations  Controller
    public class RegisterController : Controller
    {
        private static UserDetails UserDetailsInstance = null;
       
        public RegisterController()
        {

        }

        public static UserDetails UDInstance
        {
            
            get
            {
                if (UserDetailsInstance == null)
                {
                    UserDetailsInstance = new UserDetails();
                }
                return UserDetailsInstance;
            }
        }
    
        
       
        // GET: Register a new user 
        [HttpPost]
        public ActionResult RegisterCustomer(string customer_email, string pass, string confpass, string userType)
        {
            UserLoginModel uLoginModel = new UserLoginModel();
            uLoginModel.Email = customer_email;
            uLoginModel.Password = pass;
            uLoginModel.RoleId = Convert.ToInt32(userType);
            bool registrationStatus = RegisterController.UDInstance.Insert(uLoginModel);
            if (registrationStatus == true)
                ViewBag.registrationStatus = true;
            else
                ViewBag.registrationStatus = false;

            return View("~/Views/Home/index.cshtml");
        }


        //User Login - Redirects to the specific Products page
        public ActionResult  LoginUser(string email, string password)
        {
            int roleId = 999;
            UserLoginModel uLoginModel = new UserLoginModel();
            uLoginModel.Email = email;
            uLoginModel.Password = password;
            roleId = UDInstance.Login(uLoginModel);
            

            //check if the user  is a vendor
                if(roleId == 1)
            {
                HttpContext.Session["loginStatus"] = true;
                return RedirectToAction("ShowAllVendorProducts", "Product");
            }

            //check if the user  is a customer
            else if (roleId == 2)
            {
                string name = Convert.ToString(HttpContext.Session["_userName"]);
                HttpContext.Session["loginStatus"] = true;
                return RedirectToAction("ShowAllProducts", "Product");
            }

            //check if the user  is an Admin
            else if (roleId == 3)
            {
                HttpContext.Session["loginStatus"] = true;
                var val = HttpContext.Session["RoleId"];
                return RedirectToAction("ShowAllProducts", "Product");
            }
            else
            {
                HttpContext.Session["loginStatus"] = "loginFailed";
                return RedirectToAction("Index", "Home");
            }

        }

        // user logout
        public ActionResult Logout()
        {
            HttpContext.Session.RemoveAll();
            return View("~/Views/Home/Index.cshtml");
        }


        // update user profile to the database
        public ActionResult UpdateProfile(UserModel userModel)
        {
           
            try
            {
                UserModel model = new UserModel();
                userModel.Id = Convert.ToInt32(HttpContext.Session["UserId"]);
                //checking if the data already exists and user is trying to insert the same data again 
                model = UDInstance.ProfileExists();
                if(model.Name == userModel.Name && model.Address==userModel.Address && model.Age == userModel.Age && model.Email == userModel.Email &&
                    model.Contact == userModel.Contact)
                {
                    if(userModel.Id == 1)
                        return RedirectToAction("ShowAllVendorProducts", "Product");
                    else
                    {
                        return RedirectToAction("ShowAllProducts", "Product");
                    }
                }else
                {
                    UDInstance.UpdateProfile(userModel);
                    return RedirectToAction("ShowAllProducts", "Product");
                }
                
            }
            catch(Exception e)
            {
                Log.Error("Exception -- > "+ e.ToString());
                return RedirectToAction("Error", "Error");
               
            }
            
        }

        // update user profile 
        public ActionResult UpdateProfileForm()
        {
            UserModel userModel = new UserModel();
            userModel = UDInstance.ProfileExists();
            if (userModel.Email == null)
            {
                userModel.Email =Convert.ToString(HttpContext.Session["UserEmail"]);
            }
            
            return View(userModel);
        }

       

    }
}