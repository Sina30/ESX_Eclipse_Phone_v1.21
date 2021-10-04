using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phone_server
{
    public class MainController : BaseController
    {
        private dynamic ESX;
        private dynamic MySQL;
        public MainController()
        {
            TriggerEvent("esx:getSharedObject", new object[] { new Action<dynamic>(esx => {
                ESX = esx;
            })});

            MySQL.Async.execute(
                "INSERT INTO users (`accounts`, `identifier`, `group`) VALUES ('dawdawda', 'dawdwadaw', 'dwadadw'");

        }
    }
}
