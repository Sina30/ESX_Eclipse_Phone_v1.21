using CitizenFX.Core;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Phone_server.Models;

namespace Phone_server
{
    public class BaseController : BaseScript
    {
        public BaseController()
        {

        }
        public static IDictionary<String, Object> LoadJson(string file)
        {
            using (StreamReader r = new StreamReader(file))
            {
                return JsonConvert.DeserializeObject<IDictionary<String, Object>>(r.ReadToEnd());
            }
        }
        public T ConvertObjectToType<T>(object obj)
        {
            Debug.WriteLine($"name: {typeof(T).Name}");
            switch (typeof(T).Name)
            {
                case "Int16":
                    return (T)Convert.ChangeType(Convert.ToInt16(obj), typeof(T));
                case "Int32":
                    return (T)Convert.ChangeType(Convert.ToInt32(obj), typeof(T));
                case "Int64":
                    return (T)Convert.ChangeType(Convert.ToInt64(obj), typeof(T));
                case "UInt16":
                    return (T)Convert.ChangeType(Convert.ToUInt16(obj), typeof(T));
                case "UInt32":
                    return (T)Convert.ChangeType(Convert.ToUInt32(obj), typeof(T));
                case "UInt64":
                    return (T)Convert.ChangeType(Convert.ToUInt64(obj), typeof(T));

                case "String":
                    return (T)Convert.ChangeType(Convert.ToString(obj), typeof(T));
                case "Boolean":
                    return (T)Convert.ChangeType(Convert.ToBoolean(obj), typeof(T));
                case "Double":
                    return (T)Convert.ChangeType(Convert.ToDouble(obj), typeof(T));
                case "Float":
                    return (T)Convert.ChangeType(Convert.ToSingle(obj), typeof(T));
                case "DateTime":
                    return (T)Convert.ChangeType(Convert.ToDateTime(obj), typeof(T));

                default:
                    throw new Exception($"ConvertObjectToType error: unacceptable type {typeof(T).Name}");
            }
        }
        public async Task SaveLog(string filename, string log)
        {
            try
            {
                File.AppendAllText($"log/{filename}.json", $"{log},\n");
            }
            catch (Exception e)
            {
                Debug.WriteLine($"ServerLog TRY-CATCH {log} | {e}");
            }
        }
        private async Task HandlePlayerException([FromSource] Player player, string jsonModel)
        {
            await TryAsync(async () =>
            {
                var exceptionModel = JsonConvert.DeserializeObject<ExceptionModel>(jsonModel);
                //var userId = await GetUserId(player);
                var userId = player.Handle;
                Log($"[CLIENT_{userId}_ERR!] Message: {exceptionModel.Message}\r\nStackTrace:{exceptionModel.StackTrace}");
                if (exceptionModel.InnerMessage != null)
                {
                    Log($"[CLIENT_{userId}_ERR!] Message: {exceptionModel.InnerMessage}\r\nStackTrace:{exceptionModel.InnerStackTrace}");
                }
            });
        }

        public async Task TryAsync(Func<Task> func)
        {
            try
            {
                await func();
            }
            catch (Exception e)
            {
                HandleException(e);
            }

        }

        public void Try(Action action)
        {
            try
            {
                action();
            }
            catch (Exception e)
            {
                HandleException(e);
            }
        }

        private void HandleException(Exception e)
        {
            Log($"[ERR!] Message: {e.Message}\r\nStackTrace:{e.StackTrace}");
            if (e.InnerException != null)
            {
                Log($"[ERR!] Message: {e.InnerException.Message}\r\nStackTrace:{e.StackTrace}");
            }
        }
        public void Log(string str)
        {
            Debug.WriteLine($"[{DateTime.Now:dd.MM.yyyy hh:mm:ss}]: {str}");
        }
    }
}
