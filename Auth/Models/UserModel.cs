namespace Auth.Models
{
    using Utility.Constants;

    public class UserModel
    {
        public string userName
        {
            get;
            set;
        }

        public string password
        {
            get;
            set;
        }

        public int userId
        {
            get;
            set;
        }

        public EnumUserClearance clearanceLevel
        {
            get;
            set;
        }
    }
}