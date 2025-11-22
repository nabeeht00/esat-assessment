using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserManagement.Application.DTO;
using UserManagement.Application.Interfaces.Repositories;
using UserManagement.Application.Interfaces.Services;
using UserManagement.Domain.Entities;

namespace UserManagement.Application.Services
{


    public class UserService : IUserService
    {
        private readonly IUserRepository _repo;

        public UserService(IUserRepository repo)
        {
            _repo = repo;
        }

        public async Task<ApiResponse<List<User>>> GetAllAsync(string? query)
        {
            var users = await _repo.GetAllAsync(query);
            return ApiResponse<List<User>>.Ok(users);
        }

        public async Task<ApiResponse<User>> CreateAsync(UserRequest req)
        {
            if (string.IsNullOrWhiteSpace(req.Name))
                return ApiResponse<User>.Fail("Name is required");

            if (string.IsNullOrWhiteSpace(req.Email))
                return ApiResponse<User>.Fail("Email is required");

            var user = new User
            {
                Name = req.Name,
                Email = req.Email,
                Phone = req.Phone,
                DateJoined = DateTime.UtcNow
            };

            var created = await _repo.CreateAsync(user);
            return ApiResponse<User>.Ok(created, "User created successfully");
        }

        public async Task<ApiResponse<User?>> UpdateAsync(int id, UserRequest req)
        {
            var updatedUser = new User
            {
                Id = id,
                Name = req.Name,
                Email = req.Email,
                Phone = req.Phone
            };

            var result = await _repo.UpdateAsync(id, updatedUser);
            if (result == null)
                return ApiResponse<User?>.Fail("User not found");

            return ApiResponse<User?>.Ok(result, "User updated successfully");
        }

        public async Task<ApiResponse<bool>> DeleteAsync(int id)
        {
            var deleted = await _repo.DeleteAsync(id);
            if (!deleted)
                return ApiResponse<bool>.Fail("User not found");

            return ApiResponse<bool>.Ok(true, "User deleted successfully");
        }
    }

}
