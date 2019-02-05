using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RentalSystem.Controllers
{
    public class ErrorController : Controller
    {
        // redirect too error page 
        public ActionResult Error()
        {
            return View();
        }
    }
}