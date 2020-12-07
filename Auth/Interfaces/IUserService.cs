namespace Auth.Interfaces
{
    using System.Threading.Tasks;
    using Auth.Models;
    using Utility.Models;

    public interface IUserService
    {
        Task CreateUserAsync(UserCreationModel userModel);

        Task<string> AuthenticateAsync(UserLoginModel user);
    }
}