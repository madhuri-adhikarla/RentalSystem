using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RentalSystem.BL;
using AutoMapper;

namespace RentalSystem.Controllers
{
    // Feedback Operations
    public class FeedbackController : Controller
    {
        //Add new feedback to the datbase
        public ActionResult AddFeedback(FeedbackModel feedbackModel)
        {
            FeedbackDetails feedbackDetailsInstace = new FeedbackDetails();
            try
            {
                feedbackDetailsInstace.Insert(feedbackModel);
                HttpContext.Session["FeedbackStatus"] = "success";
                int id =Convert.ToInt32(HttpContext.Session["UserId"]);
                if (id == 1)
                {
                    return RedirectToAction("ShowAllVendorProducts", "Product");
                }
                else
                {
                    return RedirectToAction("ShowAllProducts", "Product");
                }
                
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
            
        }

        // create the feedback form
        public ActionResult Create()
        {
            return View();
        }

        //To display the feedback to the Admin
        public ActionResult ViewFeedback()
        {
            FeedbackDetails feedbackDetailsInstace = new FeedbackDetails();
            try
            {
                IEnumerable<FeedbackModel> model = feedbackDetailsInstace.GetAll();
                return View(model);
            }
            catch (Exception e)
            {
                Log.Error("Exception -- > " + e.ToString());
                return RedirectToAction("Error", "Error");
            }
            
        }
    }
}