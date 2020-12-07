namespace BookLibrary.Services
{
    using System;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using BookLibrary.Interfaces;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.Hosting;
    using Newtonsoft.Json;
    using Polly;
    using Polly.Retry;
    using RabbitMQ.Client;
    using RabbitMQ.Client.Events;
    using Utility.Models;

    public class QueueMessageReceiver : BackgroundService
    {
        public readonly IUserService userService;
        private readonly string hostName;
        private readonly string userName;
        private readonly string password;
        private readonly string queueName;

        public QueueMessageReceiver(
            IConfiguration config,
            IUserService injectedUserService
        )
        {
            hostName = config["RabbitMQ:HostName"];
            userName = config["RabbitMQ:UserName"];
            password = config["RabbitMQ:Password"];
            queueName = config["RabbitMQ:QueueName"];
            userService = injectedUserService;
        }

        protected override Task ExecuteAsync(CancellationToken stoppingToken)
        {
            stoppingToken.ThrowIfCancellationRequested();

            RetryPolicy retryPolicy = Policy.Handle<Exception>()
                                            .WaitAndRetryForever(retryAttempt => TimeSpan.FromSeconds(30));
            
            // At service startup time rabbitmq service might be not reachable.
            // Adding retry policy to handle that case
            retryPolicy.Execute(() =>
            {
                SetupMessageQueueCallback();
            });

            return Task.CompletedTask;
        }

        private void SetupMessageQueueCallback()
        {
            ConnectionFactory connectionFactory = new ConnectionFactory()
            {
                HostName = hostName,
                UserName = userName,
                Password = password
            };
            IConnection connection = connectionFactory.CreateConnection();
            IModel channel = connection.CreateModel();
            EventingBasicConsumer consumer = new EventingBasicConsumer(channel);

            consumer.Received += async (sender, eventArgs) =>
            {
                var content = Encoding.UTF8.GetString(eventArgs.Body.ToArray());
                UserCreationModel userModel = JsonConvert.DeserializeObject<UserCreationModel>(content);

                await userService.CreateUserAsync(userModel);

                channel.BasicAck(eventArgs.DeliveryTag, false);
            };

            channel.BasicConsume(queueName, false, consumer);
        }
    }
}