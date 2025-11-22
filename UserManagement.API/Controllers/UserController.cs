using Microsoft.AspNetCore.Mvc;
using UserManagement.Application.DTO;
using UserManagement.Application.Interfaces.Services;
using UserManagement.Application.Services;
using UserManagement.Domain.Entities;

namespace UserManagement.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly IUserService _service;

        public UsersController(IUserService service)
        {
            _service = service;
        }

        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<List<User>>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAll([FromQuery] string? query)
        {
            var result = await _service.GetAllAsync(query);
            return Ok(result);
        }

        [HttpPost]
        [ProducesResponseType(typeof(ApiResponse<User>), StatusCodes.Status200OK)]
        public async Task<IActionResult> Create([FromBody] UserRequest request)
        {
            var result = await _service.CreateAsync(request);
            if (!result.Success)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpPut("{id:int}")]
        [ProducesResponseType(typeof(ApiResponse<User?>), StatusCodes.Status200OK)]
        public async Task<IActionResult> Update(int id, [FromBody] UserRequest request)
        {
            var result = await _service.UpdateAsync(id, request);
            if (!result.Success && result.Message == "User not found")
                return NotFound(result);

            if (!result.Success)
                return BadRequest(result);

            return Ok(result);
        }

        [HttpDelete("{id:int}")]
        [ProducesResponseType(typeof(ApiResponse<bool>), StatusCodes.Status200OK)]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _service.DeleteAsync(id);
            if (!result.Success && result.Message == "User not found")
                return NotFound(result);

            return Ok(result);
        }
    }
}
