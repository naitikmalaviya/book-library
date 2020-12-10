namespace Auth.Services
{
    using System;
    using System.Threading.Tasks;
    using Auth.Constants;
    using Auth.Interfaces;
    using Auth.Models;
    using Dapper;
    using Microsoft.Extensions.Configuration;
    using Utility.DatabaseAccess;
    using Utility.Models;

    public class UserService : IUserService
    {
        private readonly IDatabaseIO databaseIO;
        private readonly IMessageSenderService messageSenderService;
        private readonly IEncryptionService encryptionService;
        private readonly ITokenService tokenService;
        private readonly string queueName;

        public UserService(
            IConfiguration config,
            IDatabaseIO injectedDatabaseIO,
            IMessageSenderService injectedMSS,
            IEncryptionService injectedEncryptionService,
            ITokenService injectedTokenService)
        {
            databaseIO = injectedDatabaseIO;
            messageSenderService = injectedMSS;
            encryptionService = injectedEncryptionService;
            tokenService = injectedTokenService;
            queueName = config["RabbitMQ:QueueName"];
        }

        public async Task<string> AuthenticateAsync(UserLoginModel user)
        {
            string spName = SPConstants.GET_USER_DETAILS;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inEmailId", user.emailId);

            UserModel dbUserData = await databaseIO.QueryFirstAsync<UserModel>(spName, parameters);
            
            if(dbUserData == null || !encryptionService.ValidateHash(user.password, dbUserData.password))
            {
                return null;
            }

            return tokenService.GenerateToken(dbUserData);
        }

        public async Task CreateUserAsync(UserCreationModel userModel)
        {
            string spName = SPConstants.CREATE_USER;
            string passwordHash = encryptionService.GenerateHash(userModel.password);
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inUserName", userModel.userName);
            parameters.Add("inEmailId", userModel.emailId);
            parameters.Add("inPassword", passwordHash);
            parameters.Add("inFirstName", userModel.firstName);
            parameters.Add("inLastName", userModel.lastName);
            parameters.Add("inClearanceLevel", (int)userModel.clearanceLevel);

            UserCreationModel dbUserModel =
                await databaseIO.QueryFirstAsync<UserCreationModel>(spName, parameters);

            if(dbUserModel == null)
            {
                throw new InvalidOperationException("User Creation Failed!");
            }

            messageSenderService.SendMessage(queueName, dbUserModel);
        }
    }
}