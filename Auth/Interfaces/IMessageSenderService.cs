namespace Auth.Interfaces
{
    using System.Threading.Tasks;

    public interface IMessageSenderService
    {
        void SendMessage(string queueName, object message);        
    }   
}