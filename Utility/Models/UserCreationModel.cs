namespace Utility.Models
{
    using System.ComponentModel.DataAnnotations;
    using Utility.Constants;

    public class UserCreationModel
    {
        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string userName
        {
            get;
            set;
        }

        [Required]
        [EmailAddress]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string emailId
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string firstName
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string lastName
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string password
        {
            get;
            set;
        }

        [Required]
        public EnumUserClearance clearanceLevel
        {
            get;
            set;
        }

        public int userId
        {
            get;
            set;
        }

        public string userGUID
        {
            get;
            set;
        }
    }
}