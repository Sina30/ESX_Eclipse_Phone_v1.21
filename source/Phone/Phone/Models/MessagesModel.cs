using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phone.Models
{
    public class MessagesModel
    {
        public string author { get; set; }
        public List<MessageModel> messages { get; set; }
    }

    public class MessageModel
    {
        public string author { get; set; }
        public bool from { get; set; }
        public bool readed { get; set; }
        public int numb { get; set; }
        public string date { get; set; }
        public string message { get; set; }
        public string playerphone { get; set; }
    }
}
