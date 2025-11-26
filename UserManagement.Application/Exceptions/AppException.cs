using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UserManagement.Application.Exceptions
{
    public class AppException : Exception
    {
        public AppException(string message) : base(message) { }
    }
}
