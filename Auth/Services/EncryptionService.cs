namespace Auth.Services
{
    using Auth.Interfaces;
    using BCrypt.Net;

    public class EncryptionService : IEncryptionService
    {
        public string GenerateHash(string password)
        {
            string salt = BCrypt.GenerateSalt(12);

            return BCrypt.HashPassword(password, salt);
        }

        public bool ValidateHash(string password, string hash)
        {
            return BCrypt.Verify(password, hash);
        }
    }
}