using System.Net;
using UserManagement.Application.DTO;
using UserManagement.Application.Exceptions;

namespace UserManagement.API.Middleware
{

    public class ErrorHandlingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ErrorHandlingMiddleware> _logger;

        public ErrorHandlingMiddleware(RequestDelegate next, ILogger<ErrorHandlingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (NotFoundException ex)
            {
                _logger.LogWarning(ex, "Not Found");
                await WriteResponse(context, HttpStatusCode.NotFound, ex.Message);
            }
            catch (AppException ex)
            {
                _logger.LogWarning(ex, "Application Error");
                await WriteResponse(context, HttpStatusCode.BadRequest, ex.Message);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unhandled exception");
                await WriteResponse(context, HttpStatusCode.InternalServerError, "Something went wrong");
            }
        }

        private async Task WriteResponse(HttpContext context, HttpStatusCode status, string message)
        {
            context.Response.StatusCode = (int)status;
            context.Response.ContentType = "application/json";

            var response = ApiResponse<string>.Fail(message);

            await context.Response.WriteAsJsonAsync(response);
        }
    }

    public static class ErrorHandlingMiddlewareExtensions
    {
        public static IApplicationBuilder UseGlobalErrorHandling(this IApplicationBuilder app)
        {
            return app.UseMiddleware<ErrorHandlingMiddleware>();
        }
    }
}
