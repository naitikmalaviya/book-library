namespace Auth.Interfaces
{
    public interface IEncryptionService
    {
        string GenerateHash(string password);

        bool ValidateHash(string password, string hash);
    }
}