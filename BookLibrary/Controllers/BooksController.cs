using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using BookLibrary.Interfaces;
using BookLibrary.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Utility.Constants;

namespace BookLibrary.Controllers
{
    [Authorize]
    [Route("api/books")]
    [ApiController]
    public class BooksController : Controller
    {
        private readonly IBookService bookService;

        public BooksController(IBookService injectedBookService)
        {
            bookService = injectedBookService;
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpGet]
        public async Task<ActionResult<List<BookDetailsModel>>> GetAllBooks()
        {
            List<BookDetailsModel> books = await bookService.GetAllBooksAsync();

            return StatusCode(StatusCodes.Status200OK, books);
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpPost("update")]
        public async Task<ActionResult> UpdateBook([FromBody] BookDetailsModel book)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            await bookService.UpdateBookAsync(book);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpPost]
        public async Task<ActionResult> CreateBook([FromBody] BookCreationModel book)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            await bookService.CreateBookAsync(book);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpDelete("{bookGUID}")]
        public async Task<ActionResult> DeleteBook(string bookGUID)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            await bookService.DeleteBookAsync(bookGUID);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize]
        [HttpPost("favorite")]
        public async Task<ActionResult> MarkAsFavorite([FromBody] string bookGUID)
        {
            if(string.IsNullOrEmpty(bookGUID))
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            int userId =
                Int32.Parse(HttpContext.User.Claims.FirstOrDefault((claim) => claim.Type == ClaimTypes.Sid).Value);

            await bookService.MarkAsFavoriteAsync(bookGUID, userId);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize]
        [HttpPost("mark-as-read")]
        public async Task<ActionResult> MarkAsRead([FromBody] string bookGUID)
        {
            if(string.IsNullOrEmpty(bookGUID))
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            int userId =
                Int32.Parse(HttpContext.User.Claims.FirstOrDefault((claim) => claim.Type == ClaimTypes.Sid).Value);

            await bookService.MarkAsReadAsync(bookGUID, userId);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize]
        [HttpPost("review")]
        public async Task<ActionResult> CreateBookReview([FromBody] BookReviewCreationModel bookReview)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            bookReview.userId =
                Int32.Parse(HttpContext.User.Claims.FirstOrDefault((claim) => claim.Type == ClaimTypes.Sid).Value);

            await bookService.CreateBookReviewAsync(bookReview);

            return StatusCode(StatusCodes.Status200OK);
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpGet("review")]
        public async Task<ActionResult> GetBookReview([FromQuery] string bookGUID)
        {
            if(string.IsNullOrEmpty(bookGUID))
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            List<BookReviewModel> bookReviews =
                    await bookService.GetBookReviewsAsync(bookGUID);
            
            return StatusCode(StatusCodes.Status200OK, bookReviews);
        }
    }
}
