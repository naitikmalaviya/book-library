namespace BookLibrary.Interfaces
{
    using System.Threading.Tasks;
    using Utility.Models;

    public interface IUserService
    {
        Task CreateUserAsync(UserCreationModel userModel);
    }
}