using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using static CitizenFX.Core.Native.API;
using CitizenFX.Core;
using CitizenFX.Core.Native;
using Phone.Models;

namespace Phone
{
    public class MainController : BaseController
    {
        private int currentTemperature = 0;
        private Random rnd = new Random();
        public MainController()
        {
            EventHandlers["ECLIPSE:getContacts"] += new Action<string>(GetContacts);
            EventHandlers["ECLIPSE:getMessages"] += new Action<string>(GetMessages);
            EventHandlers["ECLIPSE:StartCall"] += new Action<string>(StartCall);
            EventHandlers["ECLIPSE:AcceptCall"] += new Action<int, string>(AcceptCall);
            EventHandlers["ECLIPSE:DeclineCall"] += new Action(DeclineCall);
            EventHandlers["ECLIPSE:CallStarted"] += new Action<string>(CallStarted);
            EventHandlers["ECLIPSE:TargetStopCall"] += new Action(TargetStopCall);
            EventHandlers["ECLIPSE:SendContactsToNui"] += new Action<string, string>(SendContactsToNui);
            EventHandlers["ECLIPSE:SendMessagesToNui"] += new Action<string, string>(SendMessagesToNui);
            EventHandlers["ECLIPSE:SendNewsToNui"] += new Action<string>(SendNewsToNui);
            EventHandlers["ECLIPSE:SendMessageToNui"] += new Action<string>(SendMessageToNui);
            EventHandlers["ECLIPSE:GetNews"] += new Action(GetNews);
            EventHandlers["ECLIPSE:PlayerOnline"] += new Action<string>(PlayerOnline);
            EventHandlers["ECLIPSE:PlayerNotOnline"] += new Action<string>(PlayerNotOnline);
            EventHandlers["ECLIPSE:SetPlayerName"] += new Action<string, string>(SetPlayerName);
            EventHandlers["ECLIPSE:TaxiFound"] += new Action(TaxiFound);
            EventHandlers["ECLIPSE:TaxiNotFound"] += new Action(TaxiNotFound);
            //TriggerEvent("ECLIPSE:getContacts", "kek");

            Tick += OnTick;
        }
        public void TaxiFound()
        {
            var model = new { type = "TaxiFound" };
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }

        public void TaxiNotFound()
        {
            var model = new { type = "TaxiNotFound" };
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }
        [Tick]
        public async Task OnTick()
        {
            await Delay(60000);
            var currentWeather = GetPrevWeatherTypeHashName();
            var position = GetEntityCoords(PlayerPedId(), true); 
            uint mapZone = 0;
            uint road = 0;
            GetStreetNameAtCoord(position.X, position.Y, position.Z, ref mapZone, ref road);
            var time = GetClockHours();
            if (time > 10 && time < 18)
            {
                currentTemperature = rnd.Next(25, 32);
            }
            else
            {
                currentTemperature = rnd.Next(16, 20);
            }
            var model = new {type = "GetWeather", weather = currentWeather, zone = GetStreetNameFromHashKey(mapZone), temperature = currentTemperature};
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
        public void TargetStopCall()
        {
            var model = new { type = "TargetStopCall" };
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }
        public void SetPlayerName(string playerName, string job)
        {
            var model = new { type = "SetPlayerName", name = playerName, job = job };

            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
        public void CallStarted(string number)
        {
            var model = new { type = "CallStarted", phone = number};
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }

        public void GetNews()
        {
            TriggerServerEvent("ECLIPSE_PHONE:GetNews");
        }
        public void DeclineCall()
        {
            Exports["mumble-voip"].SetCallChannel(0);
        }
        public void AcceptCall(int id, string number)
        {
            Exports["mumble-voip"].SetCallChannel(id);
            var model = new { type = "TargetPhone", phone = number };
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }
        public void StartCall(string number)
        {
            SendMessageToCEF("OpenPhone");
            var model = new {type = "StartCall", phoneNumber = number};
            var jsonData = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonData);
        }
        public void PlayerOnline(string number)
        {
            var model = new {type = "PlayerOnline", phoneNumber = number};
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }

        public void PlayerNotOnline(string number)
        {
            var model = new { type = "PlayerNotOnline", phoneNumber = number };
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
        public void GetContacts(string number)
        { 
            TriggerServerEvent("ECLIPSE_PHONE:getContacts", number);
        }

        public void GetMessages(string number)
        {
            TriggerServerEvent("ECLIPSE_PHONE:getMessages", number);
        }

        public void SendMessageToNui(string message)
        {
            var jsonData = JsonConvert.DeserializeObject<MessageModel>(message);
            var authorNumber = jsonData.author;
            var playerNumber = jsonData.playerphone;
            jsonData.from = true;
            jsonData.author = playerNumber;
            jsonData.playerphone = authorNumber;
            jsonData.readed = false;
            var newMessage = JsonConvert.SerializeObject(jsonData);
            var model = new { type = "SendMessage", data = JsonConvert.SerializeObject(jsonData) };
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
        public void SendMessagesToNui(string messagesFromPlayer, string messagesToPlayer)
        {
            var jsonDataFromPlayer = JsonConvert.DeserializeObject<List<MessageModel>>(messagesFromPlayer);
            var messages = new List<MessagesModel>();
            foreach (var message in jsonDataFromPlayer)
            {
                var newMessage = new List<MessageModel>();
                var isAuthorExist = messages.FirstOrDefault(x => x.author == message.author);
                newMessage.Add(new MessageModel { author = message.author, date = message.date, message = message.message, from = message.from, numb = message.numb, readed = message.readed });
                if (isAuthorExist != null)
                {
                    var findAuthorIndex = messages.FindIndex(x => x.author == message.author);
                    messages[findAuthorIndex].messages.Add(new MessageModel { author = message.author, date = message.date, message = message.message, from = message.from, numb = message.numb, readed = message.readed });
                }
                else
                {
                    messages.Add(new MessagesModel {author = message.author, messages = newMessage});
                }
            }

            var jsonDataToPlayer = JsonConvert.DeserializeObject<List<MessageModel>>(messagesToPlayer);
            foreach (var messageToPlayer in jsonDataToPlayer)
            {
                var newMessage = new List<MessageModel>();
                var isAuthorExist = messages.FirstOrDefault(x => x.author == messageToPlayer.playerphone);
                newMessage.Add(new MessageModel { author = messageToPlayer.playerphone, date = messageToPlayer.date, message = messageToPlayer.message, from = !messageToPlayer.from, numb = messageToPlayer.numb, readed = messageToPlayer.readed });
                if (isAuthorExist != null)
                {
                    var findAuthorIndex = messages.FindIndex(x => x.author == messageToPlayer.playerphone);
                    messages[findAuthorIndex].messages.Add(new MessageModel { author = messageToPlayer.playerphone, date = messageToPlayer.date, message = messageToPlayer.message, from = !messageToPlayer.from, numb = messageToPlayer.numb, readed = messageToPlayer.readed });
                }
                else
                {
                    messages.Add(new MessagesModel { author = messageToPlayer.playerphone, messages = newMessage });
                }
            }

            var model = new {type = "SendMessages", data = JsonConvert.SerializeObject(messages)};
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }

        public void SendNewsToNui(string data)
        {
            var model = new {type = "SendNews", news = data};
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
        public void SendContactsToNui(string number, string contacts)
        {
            var model = new {type = "SendContacts", data = contacts, phoneNumber = number};
            var jsonModel = JsonConvert.SerializeObject(model);
            SendNuiMessage(jsonModel);
        }
    }
}
