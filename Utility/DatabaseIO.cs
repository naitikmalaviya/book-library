namespace Utility.DatabaseAccess
{
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using System.Linq;
    using System.Threading.Tasks;
    using Dapper;
    using Microsoft.Extensions.Configuration;
    using MySqlConnector;

    public class DatabaseIO : IDatabaseIO
    {
        private readonly string connectionString;

        public DatabaseIO(IConfiguration config)
        {
            connectionString = config["DBConnectionString"];
        }

        public async Task ExecuteAsync(string spName, DynamicParameters parameters)
        {
            using (DbConnection conn = GetConnection())
            {
                await conn.ExecuteAsync(
                    spName,
                    parameters,
                    commandType: CommandType.StoredProcedure
                );
            }
        }

        public async Task<List<T>> QueryAsync<T>(string spName, DynamicParameters parameter)
        {
            IEnumerable<T> outputList;

            using (DbConnection conn = GetConnection())
            {
                outputList = await conn.QueryAsync<T>(
                                        spName,
                                        parameter,
                                        commandType: CommandType.StoredProcedure);
            }

            return outputList.ToList();
        }

        public async Task<T> QueryFirstAsync<T>(string spName, DynamicParameters parameter)
        {
            T response;

            using (DbConnection conn = GetConnection())
            {
                response = await conn.QueryFirstAsync<T>(
                                        spName,
                                        parameter,
                                        commandType: CommandType.StoredProcedure);
            }

            return response;
        }

        private MySqlConnection GetConnection()
        {
            return new MySqlConnection(connectionString);
        }  
    }
}
