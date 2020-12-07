namespace Auth.Models
{
    using System.ComponentModel.DataAnnotations;

    public class UserLoginModel
    {
        [Required]
        public string emailId
        {
            get;
            set;
        }

        [Required]
        public string password
        {
            get;
            set;
        }
    }
}