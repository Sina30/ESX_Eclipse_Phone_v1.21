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
    public class NuiController : BaseController
    {
        public bool phone = false;
        public bool frontCam = false;
        public bool controlActive = false;
        public bool phoneActive = false;
        public int textureId = 0;
        public NuiController()
        {
            RegisterNuiCallbacks();

            

            Tick += OnTick;
        }

        
        public bool CellFrontCamActivate(bool activate)
        {
            return Function.Call<bool>((Hash)0x2491A93618B7D838, activate);
        }
        private async Task OnTick()
        {
            if (IsControlJustPressed(0, OpenPhoneButton))
            {
                if (!phoneActive)
                {
                    phoneActive = true;
                    SetNuiFocus(true, true);
                    //SetNuiFocusKeepInput(true);
                    SendMessageToCEF("OpenPhone");
                }
                else if (phoneActive)
                {
                    phoneActive = false;
                    SetNuiFocus(false, false);
                    SetNuiFocusKeepInput(false);
                    SendMessageToCEF("ClosePhone");
                }
            }

            if (IsControlJustPressed(0, GameControlButton))
            {
                if (!controlActive)
                {
                    controlActive = true;
                    SetNuiFocus(true, true);
                    SetNuiFocusKeepInput(true);
                }
                else if (controlActive)
                {
                    controlActive = false;
                    SetNuiFocus(false, false);
                    SetNuiFocusKeepInput(false);
                }
            }

            if (IsControlJustPressed(0, 27) && phone)
            {
                frontCam = !frontCam;
                CellFrontCamActivate(frontCam);
            }

            if (IsControlJustPressed(0, 177) && phone)
            {
                DestroyMobilePhone();
                phone = false;
                CellCamActivate(false, false);
            }

            if (phone)
            {
                HideHudComponentThisFrame(7);
                HideHudComponentThisFrame(8);
                HideHudComponentThisFrame(9);
                HideHudComponentThisFrame(6);
                HideHudComponentThisFrame(19);
                HideHudAndRadarThisFrame();
            }
        }

        public void RegisterNuiCallbacks()
        {
            RegisterNuiCallbackType("SendContactsData", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:setContacts", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("ClosePhone", (data, cb) =>
            {
                SetNuiFocus(false, false);
                SendMessageToCEF("ClosePhone");
            });

            RegisterNuiCallbackType("AddNews", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:AddNews", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("sendMessageData", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:setMessage", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("LoadNews", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:GetNews");
            });

            RegisterNuiCallbackType("Tilda", (data, cb) =>
            {
                controlActive = true;
                SetNuiFocus(true, true);
                SetNuiFocusKeepInput(true);
            });

            RegisterNuiCallbackType("tryStartCall", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:tryStartCall", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("AmbulancePanicButton", (data, cb) =>
            {
                var position = GetEntityCoords(PlayerPedId(), true);
                TriggerServerEvent("ECLIPSE_PHONE:AmbulancePanicButton", position, "ambulance");
            });

            RegisterNuiCallbackType("AmbulanceCall", (data, cb) =>
            {
                var position = GetEntityCoords(PlayerPedId(), true);
                var date = DateTime.Now;
                TriggerServerEvent("ECLIPSE_PHONE:AmbulanceCall", JsonConvert.SerializeObject(data), position, "ambulance", date.ToString());
            });

            RegisterNuiCallbackType("PolicePanicButton", (data, cb) =>
            {
                var position = GetEntityCoords(PlayerPedId(), true);
                TriggerServerEvent("ECLIPSE_PHONE:AmbulancePanicButton", position, "police");
            });

            RegisterNuiCallbackType("PoliceCall", (data, cb) =>
            {
                var position = GetEntityCoords(PlayerPedId(), true);
                var date = DateTime.Now;
                TriggerServerEvent("ECLIPSE_PHONE:AmbulanceCall", JsonConvert.SerializeObject(data), position, "police", date.ToString());
            });

            RegisterNuiCallbackType("AcceptCall", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:AcceptCall", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("DeleteNews", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:DeleteNews", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("SetRadioStation", (data, cb) =>
            {
                SetMobilePhoneRadioState(true);
                SetAudioFlag("MobileRadioInGame", true);
                SetAudioFlag("AllowRadioDuringSwitch", true);
                SetRadioToStationIndex(Convert.ToInt32(data["station"]));
            });

            RegisterNuiCallbackType("StopRadio", (data, cb) =>
            {
                SetMobilePhoneRadioState(false);
                SetAudioFlag("MobileRadioInGame", false);
                SetAudioFlag("AllowRadioDuringSwitch", false);
            });

            RegisterNuiCallbackType("TaxiRequest", (data, cb) =>
            {
                var position = GetEntityCoords(PlayerPedId(), true);
                TriggerServerEvent("ECLIPSE_PHONE:TaxiRequest", JsonConvert.SerializeObject(data), position);
            });

            RegisterNuiCallbackType("DeclineCall", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:DeclineCall", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("isPlayerOnline", (data, cb) =>
            {
                TriggerServerEvent("ECLIPSE_PHONE:isPlayerOnline", JsonConvert.SerializeObject(data));
            });

            RegisterNuiCallbackType("Camera", (data, cb) =>
            {
                CreateMobilePhone(0);
                CellCamActivate(true, true);
                phone = true;
                SetNuiFocus(false, false);
            });
        }
    }
}
