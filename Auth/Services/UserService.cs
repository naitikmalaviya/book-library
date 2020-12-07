namespace Auth.Services
{
    using System;
    using System.IdentityModel.Tokens.Jwt;
    using System.Security.Claims;
    using System.Text;
    using System.Threading.Tasks;
    using Auth.Constants;
    using Auth.Interfaces;
    using Auth.Models;
    using Dapper;
    using Microsoft.Extensions.Configuration;
    using Microsoft.IdentityModel.Tokens;
    using Utility.Constants;
    using Utility.DatabaseAccess;
    using Utility.Models;

    public class UserService : IUserService
    {
        private readonly IDatabaseIO databaseIO;
        private readonly IMessageSenderService messageSenderService;
        private readonly IEncryptionService encryptionService;
        private readonly string queueName;
        private readonly string jwtSecret;
        private readonly int tokenExpiry;

        public UserService(
            IConfiguration config,
            IDatabaseIO injectedDatabaseIO,
            IMessageSenderService injectedMSS,
            IEncryptionService injectedEncryptionService)
        {
            databaseIO = injectedDatabaseIO;
            messageSenderService = injectedMSS;
            encryptionService = injectedEncryptionService;
            queueName = config["RabbitMQ:QueueName"];
            jwtSecret = config["JWT:Secret"];
            tokenExpiry = Int32.Parse(config["JWT:Expiry"]);
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

            return GenerateJWTToken(dbUserData);
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

        private string GenerateJWTToken(UserModel userData)
        {
            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
            byte[] key = Encoding.ASCII.GetBytes(jwtSecret);
            SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[] 
                {
                    new Claim(ClaimTypes.Sid, userData.userId.ToString()),
                    new Claim(ClaimTypes.Role, UserRole.GetUserRole(userData.clearanceLevel))
                }),
                Expires = DateTime.UtcNow.AddDays(tokenExpiry),
                SigningCredentials = new SigningCredentials(
                                        new SymmetricSecurityKey(key),
                                        SecurityAlgorithms.HmacSha256Signature)
            };
            SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}