namespace Auth.Controllers
{
    using System.Threading.Tasks;
    using Auth.Constants;
    using Auth.Interfaces;
    using Auth.Models;
    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Http;
    using Microsoft.AspNetCore.Mvc;
    using Utility.Constants;
    using Utility.Models;

    [Authorize]
    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService userService;
        public UserController(IUserService injectedUserService)
        {
            userService = injectedUserService;
        }

        [Authorize(Roles = UserRole.Admin)]
        [HttpPost]
        public async Task<ActionResult> CreateUser([FromBody] UserCreationModel user)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            await userService.CreateUserAsync(user);

            return StatusCode(StatusCodes.Status200OK);
        }

        [AllowAnonymous]
        [HttpPost("authenticate")]
        public async Task<ActionResult> AuthenticateUser ([FromBody] UserLoginModel user)
        {
            if(!ModelState.IsValid)
            {
                return StatusCode(StatusCodes.Status400BadRequest);
            }

            string token = await userService.AuthenticateAsync(user);

            if(string.IsNullOrEmpty(token))
            {
                return StatusCode(StatusCodes.Status401Unauthorized);
            }

            return StatusCode(StatusCodes.Status200OK, token);
        }
    }
}
