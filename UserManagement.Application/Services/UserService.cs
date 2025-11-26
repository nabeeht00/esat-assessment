using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserManagement.Application.DTO;
using UserManagement.Application.Exceptions;
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
            try
            {
                var users = await _repo.GetAllAsync(query);
                return ApiResponse<List<User>>.Ok(users);
            }
            catch (Exception ex)
            {
                return ApiResponse<List<User>>.Fail(ex.Message);
            }
        }

        public async Task<ApiResponse<User>> CreateAsync(UserRequest req)
        {
            if (string.IsNullOrWhiteSpace(req.Name))
                return ApiResponse<User>.Fail("Name is required");

            if (string.IsNullOrWhiteSpace(req.Email))
                return ApiResponse<User>.Fail("Email is required");

            try
            {
                var user = new User
                {
                    Name = req.Name,
                    Email = req.Email,
                    Phone = req.Phone
                };

                var created = await _repo.CreateAsync(user);
                return ApiResponse<User>.Ok(created, "User created successfully");
            }
            catch (Exception ex)
            {
                return ApiResponse<User>.Fail(ex.Message);
            }
        }

        public async Task<ApiResponse<User?>> UpdateAsync(int id, UserRequest req)
        {
            try
            {
                var updatedUser = new User
                {
                    Id = id,
                    Name = req.Name,
                    Email = req.Email,
                    Phone = req.Phone
                };

                var result = await _repo.UpdateAsync(id, updatedUser);
                return ApiResponse<User?>.Ok(result, "User updated successfully");
            }
            catch (NotFoundException ex)
            {
                return ApiResponse<User?>.Fail(ex.Message);
            }
            catch (Exception ex)
            {
                return ApiResponse<User?>.Fail(ex.Message);
            }
        }

        public async Task<ApiResponse<bool>> DeleteAsync(int id)
        {
            try
            {
                var deleted = await _repo.DeleteAsync(id);
                return ApiResponse<bool>.Ok(deleted, "User deleted successfully");
            }
            catch (NotFoundException ex)
            {
                return ApiResponse<bool>.Fail(ex.Message);
            }
            catch (Exception ex)
            {
                return ApiResponse<bool>.Fail(ex.Message);
            }
        }
    }

}
