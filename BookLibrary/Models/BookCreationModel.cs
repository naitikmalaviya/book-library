namespace BookLibrary.Models
{
    using System.ComponentModel.DataAnnotations;
    using Utility.Constants;

    public class BookCreationModel
    {
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