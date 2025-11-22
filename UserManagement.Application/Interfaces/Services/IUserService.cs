using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserManagement.Application.DTO;
using UserManagement.Domain.Entities;

namespace UserManagement.Application.Interfaces.Services
{
    public interface IUserService
    {
        Task<ApiResponse<List<User>>> GetAllAsync(string? query);
        Task<ApiResponse<User>> CreateAsync(UserRequest req);
        Task<ApiResponse<User?>> UpdateAsync(int id, UserRequest req);
        Task<ApiResponse<bool>> DeleteAsync(int id);

    }
}
