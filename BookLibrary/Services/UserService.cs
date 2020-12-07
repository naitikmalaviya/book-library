namespace BookLibrary.Services
{
    using System.Threading.Tasks;
    using BookLibrary.Constants;
    using BookLibrary.Interfaces;
    using Dapper;
    using Utility.DatabaseAccess;
    using Utility.Models;

    public class UserService : IUserService
    {
        private readonly IDatabaseIO databaseIO;

        public UserService(IDatabaseIO injectedDatabaseIO)
        {
            databaseIO = injectedDatabaseIO;
        }

        public async Task CreateUserAsync(UserCreationModel userModel)
        {
            string spName = SPConstants.CREATE_USER;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inUserName", userModel.userName);
            parameters.Add("inEmailId", userModel.emailId);
            parameters.Add("inPassword", userModel.password);
            parameters.Add("inFirstName", userModel.firstName);
            parameters.Add("inLastName", userModel.lastName);
            parameters.Add("inClearanceLevel", (int)userModel.clearanceLevel);
            parameters.Add("inUserId", userModel.userId);
            parameters.Add("inUserGUID", userModel.userGUID);

            await databaseIO.ExecuteAsync(spName, parameters);
        }
    }
}