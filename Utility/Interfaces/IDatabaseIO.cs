namespace Utility.DatabaseAccess
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Dapper;

    public interface IDatabaseIO
    {
        Task<List<T>> QueryAsync<T>(string spName, DynamicParameters parameters);

        Task<T> QueryFirstAsync<T>(string spName, DynamicParameters parameters);

        Task ExecuteAsync(string spName, DynamicParameters parameters);
    }
}