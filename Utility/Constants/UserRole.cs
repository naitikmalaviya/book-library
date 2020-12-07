namespace Utility.Constants
{
    public static class UserRole
    {
        public const string Admin = "Admin";
        public const string User = "User";

        public static string GetUserRole(EnumUserClearance userClearance)
        {
            switch(userClearance)
            {
                case EnumUserClearance.ADMIN:
                    return UserRole.Admin;
                case EnumUserClearance.USER:
                    return UserRole.User;
                default:
                    return string.Empty;
            }
        }
    }
}