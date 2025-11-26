using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using UserManagement.Application.Exceptions;
using UserManagement.Application.Interfaces.Repositories;
using UserManagement.Domain.Entities;


namespace UserManagement.Infrastructure.Repositories
{
    public class FileUserRepository : IUserRepository
    {
        private readonly string _filePath;
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            WriteIndented = true
        };

        public FileUserRepository(IHostEnvironment env)
        {
            var folder = Path.Combine(env.ContentRootPath, "FileStorage");

            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);

            _filePath = Path.Combine(folder, "users.json");

            if (!File.Exists(_filePath))
                File.WriteAllText(_filePath, "[]");
        }

        private List<User> Load()
        {
            try
            {
                var json = File.ReadAllText(_filePath);
                return JsonSerializer.Deserialize<List<User>>(json, _jsonOptions)
                        ?? new List<User>();
            }
            catch (Exception ex)
            {
                throw new AppException($"Failed to load users: {ex.Message}");
            }
        }

        private void Save(List<User> users)
        {
            try
            {
                var json = JsonSerializer.Serialize(users, _jsonOptions);
                File.WriteAllText(_filePath, json);
            }
            catch (Exception ex)
            {
                throw new AppException($"Failed to save users: {ex.Message}");
            }
        }

        public Task<List<User>> GetAllAsync(string? query)
        {
            try
            {
                var users = Load();

                if (!string.IsNullOrWhiteSpace(query))
                {
                    query = query.ToLower();
                    users = users.Where(u =>
                        u.Name.ToLower().Contains(query) ||
                        u.Email.ToLower().Contains(query)
                    ).ToList();
                }

                return Task.FromResult(users);
            }
            catch (Exception ex)
            {
                throw new AppException(ex.Message);
            }
        }

        public Task<User> CreateAsync(User user)
        {
            try
            {
                var users = Load();
                user.Id = users.Count == 0 ? 1 : users.Max(u => u.Id) + 1;
                user.DateJoined = DateTime.UtcNow;

                users.Add(user);
                Save(users);
                return Task.FromResult(user);
            }
            catch (Exception ex)
            {
                throw new AppException($"Create failed: {ex.Message}");
            }
        }

        public Task<User?> UpdateAsync(int id, User user)
        {
            try
            {
                var users = Load();
                var existing = users.FirstOrDefault(u => u.Id == id);

                if (existing == null)
                    throw new NotFoundException($"User with Id {id} not found");

                existing.Name = user.Name;
                existing.Email = user.Email;
                existing.Phone = user.Phone;

                Save(users);
                return Task.FromResult<User?>(existing);
            }
            catch (Exception ex)
            {
                throw new AppException($"Update failed: {ex.Message}");
            }
        }

        public Task<bool> DeleteAsync(int id)
        {
            try
            {
                var users = Load();
                var existing = users.FirstOrDefault(u => u.Id == id);

                if (existing == null)
                    throw new NotFoundException($"User with Id {id} not found");

                users.Remove(existing);
                Save(users);

                return Task.FromResult(true);
            }
            catch (Exception ex)
            {
                throw new AppException($"Delete failed: {ex.Message}");
            }
        }
    }
}
