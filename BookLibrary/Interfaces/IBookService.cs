namespace BookLibrary.Interfaces
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using BookLibrary.Models;

    public interface IBookService
    {
        Task<List<BookDetailsModel>> GetAllBooksAsync();

        Task UpdateBookAsync(BookDetailsModel book);

        Task CreateBookAsync(BookCreationModel book);

        Task DeleteBookAsync(string bookGUID);

        Task MarkAsFavoriteAsync(string bookGUID, int userId);

        Task MarkAsReadAsync(string bookGUID, int userId);

        Task CreateBookReviewAsync(BookReviewCreationModel bookReview);

        Task<List<BookReviewModel>> GetBookReviewsAsync(string userGUID);
    }
}