<template>
    <div class="app_fullscreen content_page app_police">
        <button class="app_close" @click="closeApp"></button>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==1">
                 <div class="app_logo"></div>
                <h4 class="app_name" v-text="$ml.get('police_name')"></h4>
                <div class="text-center mt-3 mb-3">
                    <button class="panic_button" @click="panicbutton()">
                        Panic button
                    </button>
                </div>
                <p class="pt-2" v-text="$ml.get('police_main_description')"></p>

                <button class="btn btn-police absolute btn-block" @click="changepage(3)" v-text="$ml.get('police_button_standart')"></button>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==2">
                <h4 class="text-center" v-text="$ml.get('police_main_sent')">Вызов отправлен!</h4>
                <p v-text="$ml.get('police_main_descriptionA')"><p>
                <p v-text="$ml.get('police_main_descriptionB')"></p>
                <p class="text-center slogan">LSPD: TO PROTECT AND TO SERVE</p>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==3">
                <h4 class="text-center" v-text="$ml.get('police_call_police')">Вызвать полицию</h4>
                <p v-text="$ml.get('police_secondary_description')"></p>
                <textarea type="text" rows="5" maxlength="100" v-model="message"></textarea>
                <button class="btn btn-police btn-block mt-3" @click="sendMessage()" v-text="$ml.get('button_send')">Отправить</button>
                <p class="text-center slogan">LSPD: TO PROTECT AND TO SERVE</p>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==4">
                <h4 class="text-center" v-text="$ml.get('police_call_thx')"></h4>
                <p class="text-center" v-text="$ml.get('police_call_description')"></p>
                <p class="text-center slogan">LSPD: TO PROTECT AND TO SERVE</p>
            </div>
        </transition>


       

    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_police',
    components: {
        
    },
    data() {
        return {
            page: 1,
            message: '',
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.page = 1;
        },
        panicbutton() {
            this.page = 2;
            axios.post('https://eclipse_phone/PolicePanicButton', {

            }).then(() => { return; }).catch(function () { console.log() });  
        },
        changepage(page) {
            this.page = page;
        },
        sendMessage() {
            if (this.message) {
                this.changepage(4);
                axios.post('https://eclipse_phone/PoliceCall', {
                    PlayerName: this.$parent.playerData.name,
                    PlayerPhone: this.$parent.playerPhone,
                    Message: this.message,
                }).then(() => { return; }).catch(function () { console.log() });  
                this.message='';
            }
        }
    }
}

</script>

<style scoped>

</style>