namespace BookLibrary.Models
{
    using System.ComponentModel.DataAnnotations;
    using Utility.Constants;

    public class BookDetailsModel
    {
        [Required]
        [StringLength(StringConstraintConstants.GUID_LENGTH)]
        public string GUID
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string name
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.NAME_LENGTH)]
        public string authorName
        {
            get;
            set;
        }
    }
}