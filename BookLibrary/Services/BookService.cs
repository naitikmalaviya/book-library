namespace BookLibrary.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using BookLibrary.Constants;
    using BookLibrary.Interfaces;
    using BookLibrary.Models;
    using Dapper;
    using Utility.DatabaseAccess;

    public class BookService : IBookService
    {
        private readonly IDatabaseIO databaseIO;
        public BookService(IDatabaseIO injectedDatabaseIO)
        {
            databaseIO = injectedDatabaseIO;
        }

        public async Task CreateBookAsync(BookCreationModel book)
        {
            string spName = SPConstants.CREATE_BOOK;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inBookName", book.name);
            parameters.Add("inAuthorName", book.authorName);

            string bookGUID = await databaseIO.QueryFirstAsync<string>(spName, parameters);

            if(string.IsNullOrEmpty(bookGUID))
            {
                throw new InvalidOperationException("Book Creation Failed!");
            }
        }

        public async Task CreateBookReviewAsync(BookReviewCreationModel bookReview)
        {
            string spName = SPConstants.CREATE_BOOOK_REVIEW;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inBookGUID", bookReview.bookGUID);
            parameters.Add("inReview", bookReview.review);
            parameters.Add("inUserId", bookReview.userId);

            string reviewGUID = await databaseIO.QueryFirstAsync<string>(spName, parameters);

            if(string.IsNullOrEmpty(reviewGUID))
            {
                throw new InvalidOperationException("Book Review Creation Failed!");
            }
        }

        public async Task DeleteBookAsync(string bookGUID)
        {
            string spName = SPConstants.DELETE_BOOK;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inBookGUID", bookGUID);

            await databaseIO.ExecuteAsync(spName, parameters);
        }

        public async Task<List<BookDetailsModel>> GetAllBooksAsync()
        {
            string spName = SPConstants.GET_ALL_BOOK;
            DynamicParameters parameters = new DynamicParameters();
            IEnumerable<BookDetailsModel> books;

            books = await databaseIO.QueryAsync<BookDetailsModel> (spName, parameters);

            return books.ToList();
        }

        public async Task<List<BookReviewModel>> GetBookReviewsAsync(string bookGUID)
        {
            string spName = SPConstants.GET_BOOK_REVIEWS;
            DynamicParameters parameters = new DynamicParameters();
            IEnumerable<BookReviewModel> reviews;

            parameters.Add("inBookGUID", bookGUID);

            reviews = await databaseIO.QueryAsync<BookReviewModel> (spName, parameters);

            return reviews.ToList();
        }

        public async Task MarkAsFavoriteAsync(string bookGUID, int userId)
        {
            string spName = SPConstants.MARK_AS_FAVORITE;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inUserId", userId);
            parameters.Add("inBookGUID", bookGUID);

            await databaseIO.ExecuteAsync(spName, parameters);
        }

        public async Task MarkAsReadAsync(string bookGUID, int userId)
        {
            string spName = SPConstants.MARK_AS_READ;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inUserId", userId);
            parameters.Add("inBookGUID", bookGUID);

            await databaseIO.ExecuteAsync(spName, parameters);
        }

        public async Task UpdateBookAsync(BookDetailsModel book)
        {
            string spName = SPConstants.UPDATE_BOOK;
            DynamicParameters parameters = new DynamicParameters();

            parameters.Add("inBookGUID", book.GUID);
            parameters.Add("inBookName", book.name);
            parameters.Add("inAuthorName", book.authorName);

            await databaseIO.ExecuteAsync(spName, parameters);
        }
    }
}