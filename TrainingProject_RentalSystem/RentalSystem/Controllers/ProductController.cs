    using AutoMapper;
using RentalSystem.BL;
using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Web.Mvc;


namespace RentalSystem.Controllers
{
    // ProductOperations Controller
    public class ProductController : Controller
    {
        private static ProductDetails ProductDetailsInstance = null;

        public ProductController()
        {

        }

        // product details instance
        public static ProductDetails PDInstance
        {

            get
            {
                if (ProductDetailsInstance == null)
                {
                    ProductDetailsInstance = new ProductDetails();
                }
                return ProductDetailsInstance;
            }
        }

        // Show All the available products (For Customers who are not logged in and the vendor)

        public ActionResult ShowAllProducts(bool? lgStatus)
        {

            IEnumerable<ProductModel> prodList = new List<ProductModel>();
            try
            {
                prodList = PDInstance.GetAll();
               
            }
            catch (Exception e)
            {
                throw e;
            }
            return View(prodList);
            
        }

        // View to add new Product for Vendors
        public ActionResult CreateNewProduct()
        {
            return View();
        }

        //Add a new product to the database
        public ActionResult InsertProduct(ProductModel product)
        {
            ProductModel productModel = null;
            productModel = Mapper.Map<ProductModel>(product);
            productModel.VendorId = Convert.ToInt32(HttpContext.Session["UserId"]);
            // default image for the product
            productModel.Image1 = "~/Images/default.jpg";
            bool status = PDInstance.Insert(productModel);
            return RedirectToAction("ShowAllProducts");
        }

        // Individual ProductDetails 
        public ActionResult ProductDetails(int prodId)
        {
            ProductModel productModel = new ProductModel();
            try
            {
                productModel =  PDInstance.GetProductById(prodId);
                return View(productModel);
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
 
        }


        public ActionResult Rent(int productId=0)
        {
            int userId = 0;
            string email = null;
            if(Session["UserId"] != null && Session["UserEmail"] != null)
            {
                userId = Convert.ToInt32(Session["UserId"]);
                email = Convert.ToString(Session["UserEmail"]);
            }
            if(userId==0 || String.IsNullOrEmpty(email))
            {
                return RedirectToAction("ProductDetails", new { prodId = productId });
            }
            ProductModel prod = PDInstance.GetProductById(productId);
            RentModel rent = new RentModel
            {
                Email = email,
                VendorId = userId,
                ProductId = productId,
                StartDate = prod.StartDate,
                EndDate = prod.EndDate,
                Status = true,
                Payment=true,
                CategoryId=prod.CategoryId??0,
                UnitCost=prod.Rent
            };
            int totalDays = (int)(prod.EndDate - prod.StartDate).TotalDays;
            rent.TotalCost = totalDays * prod.Rent;
            PDInstance.InsertRentedProduct(rent);
            return Redirect(Request.UrlReferrer.ToString());
        }

        // To get vendor specific products
        public ActionResult GetAllProductsVendor()
        {
            IEnumerable<ProductModel> productList = null;
            try
            {
                int vendorId = Convert.ToInt32(Session["UserId"]);
                productList = PDInstance.GetAllProductsOfVendor(vendorId);
                return View(productList);

            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
        }

        //Edit product Details - vendor
        public ActionResult EditProduct(int productId)
        {
            ProductModel productModel = new ProductModel();
            try
            {
                productModel = PDInstance.GetProductById(productId);
                return View(productModel);
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
        }

        //Update Product Details - vendor
        public ActionResult UpdateProduct(ProductModel productModel)
        {
            bool updateStatus = PDInstance.Update(productModel);
            if (updateStatus == true)
            {
                ViewBag.updateStatus = true;
                return RedirectToAction("ShowAllProducts");
            }
                
            else
            {
                ViewBag.updateStatus = false;
                return RedirectToAction("GetAllProductsVendor");
            }

        }

        // Delete Product-Vendor
        public ActionResult DeleteProduct(ProductModel productModel)
        {
            try
            {
                bool status = PDInstance.Delete(productModel);
                HttpContext.Session.Add("ProductDeleteStatus", status);
                return RedirectToAction("GetAllProductsVendor");
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
        }

        // Get Vendor Specific Products for Product page
       public ActionResult ShowAllVendorProducts()
        {
            IEnumerable<ProductModel> prodList = new List<ProductModel>();
            try
            {
                int vendorId = Convert.ToInt32(Session["UserId"]);
                prodList = PDInstance.GetAllProductsOfVendor(vendorId);
                return View(prodList);
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
            
        }


        public ActionResult MyOrders()
        {
            int userId = Convert.ToInt32(HttpContext.Session["UserId"]);
            IEnumerable<ProductModel> prodList = PDInstance.CustomerOrders(userId);
            
            return View(prodList);
        }


    }
}
