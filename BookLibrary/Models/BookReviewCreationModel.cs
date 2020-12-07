namespace BookLibrary.Models
{
    using System.ComponentModel.DataAnnotations;
    using System.Text.Json.Serialization;
    using Utility.Constants;

    public class BookReviewCreationModel
    {
        [Required]
        [StringLength(StringConstraintConstants.GUID_LENGTH)]
        public string bookGUID
        {
            get;
            set;
        }

        [Required]
        [StringLength(StringConstraintConstants.DESCRIPTION_LENGTH)]
        public string review
        {
            get;
            set;
        }

        [JsonIgnore]
        public int userId
        {
            get;
            set;
        }
    }
}