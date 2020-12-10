namespace Auth.Services
{
    using System;
    using System.IdentityModel.Tokens.Jwt;
    using System.Security.Claims;
    using System.Text;
    using Auth.Interfaces;
    using Auth.Models;
    using Microsoft.Extensions.Configuration;
    using Microsoft.IdentityModel.Tokens;
    using Utility.Constants;

    public class TokenService : ITokenService
    {
        
        private readonly string jwtSecret;
        private readonly int tokenExpiry;

        public TokenService(
            IConfiguration config
        )
        {
            jwtSecret = config["JWT:Secret"];
            tokenExpiry = Int32.Parse(config["JWT:Expiry"]);
        }

        public string GenerateToken(UserModel userData)
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