namespace Auth.Services
{
    using System.Text;
    using System.Threading.Tasks;
    using Auth.Interfaces;
    using Microsoft.Extensions.Configuration;
    using Newtonsoft.Json;
    using RabbitMQ.Client;

    public class MessageSenderService : IMessageSenderService
    {
        private readonly string hostName;
        private readonly string userName;
        private readonly string password;
        private IConnection connection;

        public MessageSenderService(IConfiguration config)
        {
            hostName = config["RabbitMQ:HostName"];
            userName = config["RabbitMQ:UserName"];
            password = config["RabbitMQ:Password"];
        }

        public void SendMessage(string queueName, object message)
        {
            IConnection conn = GetConnection();
            using (IModel channel = conn.CreateModel())
            {
                channel.QueueDeclare(
                    queue: queueName,
                    durable: true,
                    exclusive: false,
                    autoDelete: false,
                    arguments: null
                );

                string serializedObject = JsonConvert.SerializeObject(message);
                byte[] body = Encoding.UTF8.GetBytes(serializedObject);

                channel.BasicPublish(
                    exchange: string.Empty,
                    routingKey: queueName,
                    basicProperties: null,
                    body: body
                );
            }
        }

        private IConnection GetConnection()
        {
            if(connection == null)
            {
                ConnectionFactory connectionFactory = new ConnectionFactory()
                {
                    HostName = hostName,
                    UserName = userName,
                    Password = password
                };

                connection = connectionFactory.CreateConnection();
            }

            return connection;
        }
    }
}