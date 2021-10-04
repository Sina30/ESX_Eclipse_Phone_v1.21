using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phone_server.Models
{
    public class ExceptionModel
    {
        public string Message { get; set; }
        public string StackTrace { get; set; }

        public string InnerMessage { get; set; }
        public string InnerStackTrace { get; set; }
    }
}
