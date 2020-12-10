namespace Auth.Interfaces
{
    using Auth.Models;

    public interface ITokenService
    {
        string GenerateToken(UserModel userModel);        
    }
}