using AutoMapper;
using RentalSystem.BL.Interface;
using RentalSystem.DAL;
using RentalSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RentalSystem.BL
{
   public class FeedbackDetails : IBase<FeedbackModel>
    {
        public RentalSystemContext dbContext => RentalSystemContext.Instance;


        // Retrieve all the Feedback from the database and return a list of type FeedbackModel
        public IEnumerable<FeedbackModel> GetAll()
        {
            IEnumerable<Feedback> feedbackList = null;
            IEnumerable<FeedbackModel> feedbackModel = null;
            try
            {
                feedbackList = dbContext.Feedbacks.ToList();
                feedbackModel = feedbackList.Select(p => Mapper.Map<FeedbackModel>(p));
            }
            catch(Exception e)
            {
                throw e;
            }
            return feedbackModel;
        }

        // Insert new feedback to the database and return the boolean status
        public bool Insert(FeedbackModel Entity)
        {
            bool status = false;
            try
            {
                Feedback feedbackData = Mapper.Map<Feedback>(Entity);
                dbContext.Feedbacks.Add(feedbackData);
                dbContext.SaveChanges();
                status = true;
            }
            catch (Exception e)
            {

                throw e;
            }
            return status;
        }

        public bool Update(FeedbackModel Entity)
        {
            throw new NotImplementedException();
        }
    }
}
