using AutoMapper;
using RentalSystem.BL.Interface;
using RentalSystem.DAL;
using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;

namespace RentalSystem.BL
{
    public class ProductDetails : IBase<ProductModel>
    {
        //singleton Instance of the context class
        public RentalSystemContext dbContext => RentalSystemContext.Instance;
        
        // Insert new product into the database from a vendor
        public bool Insert(ProductModel entity)
        {
            Product product = null;
            bool status = false;
            try
            {
                product = Mapper.Map<Product>(entity);
                dbContext.Products.Add(product);
                dbContext.SaveChanges();
                status = true;
            }
            catch (Exception e)
            {

                throw e;
            }
            return status;
        }


        // Retrieve product from database based on the Id
        public ProductModel GetProductById(int productId)
        {
            Product product = null;
            try
            {
                product = dbContext.Products.SingleOrDefault(id => id.ProductId == productId);
            }
            catch (Exception e)
            {

                throw e;
            }

            return Mapper.Map<ProductModel>(product);
        }

        // Gets All the Products of a particular vendor and returns as a list of type ProductModel
        // the vendor id is retrieved from the session variables
        public IEnumerable<ProductModel> GetAllProductsOfVendor(int vendorId)
        {
            IEnumerable<Product> result = new List<Product>();
            List<ProductModel> prodList = new List<ProductModel>();
            try
            {
                // spGetAllProducts is a stored procedure , which returns all the products of a specific vendor based on vendor id
                var r = dbContext.spGetAllProducts(vendorId).ToList();

                foreach (var item in r)
                {
                    prodList.Add(Mapper.Map<ProductModel>(item));
                }
                prodList.AsEnumerable();
            }
            catch (Exception e)
            {
                throw e;
            }
            return prodList;
        }


        // Update the productdetails from the vendor and return a boolean status value, whether the update is succesful or not
        public bool Update(ProductModel Entity)
        {
            Product product = new Product();
            bool updateStatus = false;
            try
            {
                product = Mapper.Map<Product>(Entity);
                product = dbContext.Products.SingleOrDefault(i => i.ProductId == Entity.ProductId);
                if(product != null)
                {
                    product.ProductName = Entity.ProductName;
                    product.Description = Entity.Description;
                    product.StartDate = Entity.StartDate;
                    product.EndDate = Entity.EndDate;
                    product.Rent = Entity.Rent;


                    dbContext.SaveChanges();
                    updateStatus = true;
                }
                

            }catch(Exception e)
            {
                throw e;
            }

            return updateStatus;
        }


        //delete a product from the database which a vendor wants to delete
        
        public bool Delete(ProductModel Entity)
        {
            bool deleteStatus = false;
            try
            {
                Product product = dbContext.Products.Find(Entity.ProductId);
               
     
                if (product!=null)
                {
                    dbContext.Products.Remove(product);
                    dbContext.SaveChanges();
                    deleteStatus = true;
                } 
                
            }catch(Exception e)
            {
                throw e;
            }
            return deleteStatus;
        }


        //get all the available products
        // returns a list of type ProductModel
        public IEnumerable<ProductModel> GetAll()
        {
            List<ProductModel> prodList = new List<ProductModel>();
            try
            {
                //spGetAllProductsAdmin is a stored procedure , to get all the available products irrespective of the usertype

                var r = dbContext.spGetAllProductsAdmin().ToList();

                foreach (var item in r)
                {
                    prodList.Add(Mapper.Map<ProductModel>(item));
                }
                prodList.AsEnumerable();
            }
            catch (Exception e)
            {
                throw e;
            }
            return prodList;
        }

        public bool InsertRentedProduct(RentModel entity)
        {
            bool status = false;
            RentProduct prod = new RentProduct();
            try
            {
                prod = Mapper.Map<RentProduct>(entity);
                dbContext.RentProducts.Add(prod);
                Product product = dbContext.Products.Where(p => p.ProductId == entity.ProductId).Single();
                product.Availability = false;
                int res=dbContext.SaveChanges();
                if(res != 0)
                {
                    status = true;
                }
            }
            catch (Exception e)
            {

                throw e;
            }
            return status;
        }

        public IEnumerable<ProductModel> CustomerOrders(int userId)
        {
            List<ProductModel> result = new List<ProductModel>();
            List<RentProduct> prodList = new List<RentProduct>();
            try
            {
                prodList  = dbContext.RentProducts.Where(p => p.VendorId == userId).ToList();

                foreach (var item in prodList)
                {
                    var prod = dbContext.Products.SingleOrDefault(e => e.ProductId == item.ProductId);
                    result.Add(Mapper.Map<ProductModel>(prod));
                }
                result.AsEnumerable();
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;
           
        }
    }
}
