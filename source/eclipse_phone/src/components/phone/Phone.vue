<template>
    <section class="phone">
        <div class="phone_outer iphone_bg" :class="{wallpaper_1: playerData.bgImage == 0}" :style="styleObject"></div>
        <div class="phone_outer iphone" :class="{rotated: rotatePhone}">
            <div class="phone_design" >
                <div class="phone_inner">
                    <div class="top_bar">
                        <div class="time" :class="{white: whiteColor}">
                            {{localeTime}}
                        </div>
                        <div class="battery" :class="{white: whiteColor}">
                            <b-icon icon="reception4" class=""></b-icon>
                            <b-icon icon="battery-full" class="battery_icon"></b-icon>
                        </div>
                    </div>

                    <button class="block_phone" @click="lockPhone"></button>

                    <div class="iphone_brow"></div>

                    <transition name="unlock">
                        <div class="content_page page_01" v-show="page == 1">
                            <div class="big_timer">
                                <h2>{{localeTime}}</h2>
                                <h5>{{localeDate}}</h5>
                            </div>

                            <div class="unlock">
                                <button @click="unlockPhone">
                                    <b-icon icon="lock-fill" class="" v-show="locked"></b-icon>
                                    <b-icon icon="unlock-fill" class="" v-show="!locked"></b-icon>
                                </button>
                            </div>
                            

                        </div>
                    </transition>

                    <transition name="transition_02">
                        <div class="content_page page_02" v-show="page == 2">
                            <div class="app_menu">
                                <div class="app_icon">
                                    <button class="app app_button_calendar" @click="runApp('12')" :class="{active: anim == 12}">
                                        <h5>{{appWeek}}</h5>
                                        <h4>{{appDay}}</h4>
                                    </button>
                                    <span>Calendar</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_weather" @click="runApp('13')" :class="{active: anim == 13}"></button>
                                    <span>Weather</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_camera" @click="openCamera()" :class="{active: anim == 14}"></button>
                                    <span>Camera</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_calculator" @click="runApp('200')" :class="{active: anim == 200}"></button>
                                    <span>Calc</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_weazel" @click="runApp('101')" :class="{active: anim == 101}"></button>
                                    <span>Weazel news</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_police" @click="runApp('102')" :class="{active: anim == 102}"></button>
                                    <span>911 call police</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_ambulance" @click="runApp('103')" :class="{active: anim == 103}"></button>
                                    <span>Ambu-lance</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_taxi" @click="runApp('100')" :class="{active: anim == 100}"></button>
                                    <span>Taxi</span>
                                </div>

                                <div class="app_icon">
                                    <button class="app app_button_settings" @click="runApp('17')" :class="{active: anim == 17}"></button>
                                    <span>Settings</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_bleeter" @click="runApp('104')" :class="{active: anim == 104}"></button>
                                    <span>Bleeter</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_dark_chat" @click="runApp('105'), $refs.appDark.startLoad()" :class="{active: anim == 105}"></button>
                                    <span>Dark chat</span>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_yellow" @click="runApp('106')" :class="{active: anim == 106}"></button>
                                    <span>Dynasty8 exchange</span>
                                </div>

                            </div>

                            <div class="bottom_bar app_menu">
                                <div class="app_icon">
                                    <button class="app app_button_call" @click="runApp('10')" :class="{active: anim == 10}"></button>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_youtube" @click="runApp('15')" :class="{active: anim == 15}"></button>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_messages" @click="runApp('11')" :class="{active: anim == 11}"></button>
                                </div>
                                <div class="app_icon">
                                    <button class="app app_button_radio" @click="runApp('16')" :class="{active: anim == 16}"></button>
                                </div>
                            </div>
                        </div>
                    </transition>

                    <AppCalendar v-show="page == 12" />
                    <AppWeather v-show="page == 13" />
                    <AppCalculator v-show="page == 200" />

                    <AppWeazel :roles=playerData.roles v-show="page == 101" />
                    <AppPolice v-show="page == 102" />
                    <AppAmbulance v-show="page == 103" />
                    <AppTaxi  v-show="page == 100" />

                    <AppSettings :playerData=playerData v-show="page == 17" />
                    <AppBleeter :playerData=playerData v-show="page == 104" />
                    <AppDarkChat ref="appDark" v-show="page == 105" />
                    <AppYellowPages :playerData=playerData v-show="page == 106" />
                    
                    <AppCall :contacts="contacts" :key="callKey" v-show="page == 10" />
                    <AppYoutube v-show="page == 15" />
                    <AppMessage ref="appMessage" :key="callKey2" :contacts="contacts" :messages="messages" v-show="page == 11" />
                    <AppRadio v-show="page == 16" />



                </div>
            </div>
        </div>
    </section>
</template>

<script>

import axios from 'axios';

import AppCalendar from '../phone/apps/App_calendar'
import AppWeather from '../phone/apps/App_weather'
import AppCall from '../phone/apps/App_call'
import AppMessage from '../phone/apps/App_message'
import AppYoutube from '../phone/apps/App_youtube'
import AppTaxi from '../phone/apps/App_taxi'
import AppWeazel from '../phone/apps/App_weazel'
import AppPolice from '../phone/apps/App_police'
import AppAmbulance from '../phone/apps/App_ambulance'
import AppCalculator from '../phone/apps/App_calculator'
import AppRadio from '../phone/apps/App_radio'
import AppSettings from '../phone/apps/App_settings'
import AppBleeter from '../phone/apps/App_bleeter'
import AppDarkChat from '../phone/apps/App_darkchat'
import AppYellowPages from '../phone/apps/App_yellowpages'


export default {
    name: 'Inventory',
    components: {
        AppCalendar,
        AppWeather,
        AppCall,
        AppMessage,
        AppYoutube,
        AppTaxi,
        AppWeazel,
        AppPolice,
        AppAmbulance,
        AppCalculator,
        AppRadio,
        AppSettings,
        AppBleeter,
        AppDarkChat,
        AppYellowPages
    },
    props: {
        playerData: Object,
    },
    data() {
        return {
            time: 0,
            mothText: ['January','February','March','April','May','June','July','August','September','October','November','December'],
            weekText: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],

            contacts: [],

            messages: [],

            page: 2,
            anim: 0,
            locked: true,
            whiteColor: true,
            playerPhone: null,
            activeApp: [],
            rotatePhone: false,
            callKey: 123,
            callKey2: 234,
        }
    },
    methods: {
        unlockPhone() {
            this.locked = false;
            this.page = 0;
            setTimeout(() => {
                this.page = 2;
            }, 500);

        },
        doCommand(e) {
            if(this.page == 2) {
                if(e.keyCode == 27 || e.keyCode == 8 || e.keyCode == 112) { // не будь пидорасом
                    axios.post('https://eclipse_phone/ClosePhone', {
                    }).then(() => { return; }).catch(function () { console.log() });  
                }
            }
            if(e.keyCode == 192) {
                    axios.post('https://eclipse_phone/Tilda', {
                    }).then(() => { return; }).catch(function () { console.log() });  
            }
        },
        lockPhone() {
            this.locked = true;
            this.page = 1;
            this.whiteColor = true;
        },
        openCamera() {
            axios.post('https://eclipse_phone/Camera', {

            }).then(() => { return; }).catch(function () { console.log() });  
        },
        runApp(app) {
            this.anim = app;
            
            if(app == 101) {
                axios.post('https://eclipse_phone/LoadNews', {

                }).then(() => { return; }).catch(function () { console.log() });  
            }

            if(app == 106) {
                axios.post('https://eclipse_phone/GetAdds', {

                }).then(() => { return; }).catch(function () { console.log() });  
            }

            if(app == 104) {
                axios.post('https://eclipse_phone/GetBleet', {

                }).then(() => { return; }).catch(function () { console.log() });  
            }

            if(app == 105) {
                axios.post('https://eclipse_phone/GetDark', {

                }).then(() => { return; }).catch(function () { console.log() });  
            }

            setTimeout(() => {
                this.page = app;
                this.anim = 0;
                if (app == 10 || app == 100 || app == 11 || app == 12 || app == 15 || app == 16 || app == 17) {
                    this.whiteColor = false;
                }
                if (app == 15 ) {
                    this.rotatePhone = true;
                }
            }, 500);
            
        },
        addNewMessage(data) {
            var phone = data.author;
            var index = this.messages.findIndex(item => item.author == phone);
            if (index != -1 ) {
                this.messages[index].messages.push(data);
            } else {
                var newMessage = {}
                newMessage.author = phone;
                newMessage.messages = [];
                newMessage.messages.push(data);
                this.messages.push(newMessage);
            }
        }
    },
    computed: {
        localeTime() {
            var today = new Date();
            var time = ('0' + today.getHours()).slice(-2);
            var minutes = ('0' + today.getMinutes()).slice(-2);
            return time + ':' + minutes;
        },
        localeDate() {
            var today = new Date();
            var week = today.getDay();
            var date = today.getDate();
            var month = today.getMonth();
            return this.weekText[week] + ', ' + date + ' ' + this.mothText[month];
        },
        appWeek() {
            var today = new Date();
            var week = today.getDay();
            if (week == 0) {
                week = 7;
            }
            var text = this.weekText[week - 1].substring(0, 5);
            return text;
        },
        appDay() {
            var today = new Date();
            var date = today.getDate();
            return date;
        },
        styleObject() {
            if (this.playerData.bgImage) {
                var style = {'background-image': 'url(' + this.playerData.bgImage + ')'};
                return style;
            } else {
                return '';
            }
            
        }
    },
    mounted() {
    window.addEventListener(
      "message",
      (event) => {
        if (event.data.type == "SendContacts") {
            console.log('kek')
            console.log(event.data.phoneNumber)
            this.contacts = JSON.parse(event.data.data);
            this.playerPhone = event.data.phoneNumber;
            this.playerData.phone = event.data.phoneNumber;
            console.log(event.data.phoneNumber)
            this.callKey += 1;
        }
        else if(event.data.type == "SendMessages") {
            this.messages = JSON.parse(event.data.data)
            this.callKey2 += 1;
        }
        else if(event.data.type == "SendMessage") {
            this.addNewMessage(JSON.parse(event.data.data))
        }
      },
      false
    );
  },
  created() {
      window.addEventListener('keydown', this.doCommand);
  },
  destroyed() {
      window.addEventListener('keydown', this.doCommand);
  }
}
</script>

<style scoped>


</style>