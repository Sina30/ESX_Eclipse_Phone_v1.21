<template>
    <div class="app_fullscreen content_page app_darkchat">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back white" v-text="$ml.get('button_exit')">Выйти</button>
                </div>
                <div class="dark_loading">
                    <div class="loader"></div>
                    
                </div>
                <h4 class="text-center" v-text="$ml.get('darkchat_loading')">Подключение к серверам</h4>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back white" v-text="$ml.get('button_exit')">Выйти</button>
                </div>
                <div class="content">
                    <button class="btn" @click="changePage(3)" v-text="$ml.get('darkchat_menuA')">Coded chat</button>
                    <button class="btn" @click="changePage(4)" v-text="$ml.get('darkchat_menuB')">Anonymous feed</button>
                    <button class="btn" @click="changePage(5)" v-text="$ml.get('darkchat_menuC')">Help</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_3" v-show="page==3">
                <div class="contact_heading">
                    <button @click="changePage(2)" class="blue_button_back white" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name">Your code #{{playerDarkData.code}}</h4>
                </div>
                <div class="content">
                    <div class="dark_message" v-for="(message, index) in playerDarkData.messages" :key="'message'+index">
                        
                        <div class="message_author" :class="{to_me: message.to == playerDarkData.code}">
                            <span :class="{author_me: message.from == playerDarkData.code}">{{message.from}}</span> to <span :class="{author_me: message.to == playerDarkData.code}">{{message.to}}</span>
                        </div>
                        <div class="message_text">
                            <p>{{message.text}}</p>
                        </div>
                    </div>
                </div>
                <div class="control">
                    <textarea type="text" rows="3" maxlength="200" v-model="newMessage.text" :placeholder="$ml.get('darkchat_message')"></textarea>
                    <div class="width100 d-flex justify-content-between">
                        <input type="text" :placeholder="$ml.get('darkchat_recipient_code')" v-model="newMessage.to">
                        <button class="btn" @click="sendMessage()" v-text="$ml.get('button_send')">Отправить</button>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_4" v-show="page==4">
                <div class="contact_heading">
                    <button @click="changePage(2)" class="blue_button_back white" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name">Anonymous</h4>
                </div>

                <div class="content">
                    <div class="dark_message" v-for="(message, index) in playerDarkData.anonmessages" :key="'message'+index">
                        
                        <div class="message_author text-right">
                            <span class="author_me" v-if="message.from == playerDarkData.code">{{message.from}}</span>
                            <span v-if="message.from != playerDarkData.code">Anonymous</span>
                        </div>
                        <div class="message_text">
                            <p>{{message.text}}</p>
                        </div>
                    </div>
                </div>

                <div class="control">
                    <textarea type="text" rows="3" maxlength="200" v-model="anonMessage.text" :placeholder="$ml.get('darkchat_message')"></textarea>
                    <div class="width100 d-flex justify-content-center">
                        <button class="btn" @click="sendAnonMessage()" v-text="$ml.get('button_send')"></button>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_4" v-show="page==5">
                <div class="contact_heading">
                    <button @click="changePage(2)" class="blue_button_back white" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('darkchat_menuC')">Help</h4>
                </div>
                <p v-text="$ml.get('darkchat_helpA')">The coded chat section: enter the code of the interlocutor and he will get your message. You will also receive all messages sent to your code.</p>
                <p v-text="$ml.get('darkchat_helpB')">The anonymous feed section. You will see all messages from the general chat. Everyone will see your message. No one will see the sender's address. Completely anonymous!</p>
            </div>
        </transition>


    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_darkchat',
    props: {
    },
    data() {
        return {
            page: 1,
            newMessage: {"text": "", "to": ""},
            anonMessage: {"text": ""},
            playerDarkData: {
                "code": null,
                "messages": [
                    // {"from": 91240, "to": 435556, "text": "Нужна срочно информацию по оружию. Желательно Ак-47. Подойдет и оружие местного производства."},
                ],
                "anonmessages": [
                    // {"from": 12315, 'text': "Анонимная лента, привет"},
                ]
            },

        }
    },
    mounted() {
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "SendDarkNetId") {
                this.playerDarkData.code = event.data.code;
            }
            else if(event.data.type == "SetCodedMessages") {
                this.playerDarkData.messages = JSON.parse(event.data.data);
            }
            else if(event.data.type == "SendAnonChatMessage") {
                this.playerDarkData.anonmessages = JSON.parse(event.data.data)
                this.sortById();
            }
            else if(event.data.type == "SendCodedMessageToNui") {
                this.playerDarkData.messages.unshift(JSON.parse(event.data.data))
            }
        },
            false
        );
    },
    methods: {
        closeApp() {
            this.page = 1;
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
        },
        changePage(page) {
            this.page = page;
        },
        startLoad() {
            setTimeout(() => {
                this.page = 2;
            }, 3000);
        },
        sortById() {
            this.playerDarkData.anonmessages.sort(function(a, b){
                return b.id - a.id
            });
        },
        sendMessage() {
            if (this.newMessage.text.length > 2 && this.newMessage.text.to != 0) {
                this.newMessage.from = this.playerDarkData.code;
                this.playerDarkData.messages.unshift(this.newMessage);
                axios.post('https://eclipse_phone/sendSecretChatMessage', {
                    from: this.newMessage.from,
                    to: this.newMessage.to,
                    text: this.newMessage.text
                }).then(() => { return; }).catch(function () { console.log() });
                this.newMessage = {};
            }
        },
        sendAnonMessage() {
            if (this.anonMessage.text.length > 2) {
                this.anonMessage.from = this.playerDarkData.code;
                this.playerDarkData.anonmessages.unshift(this.anonMessage);
                axios.post('https://eclipse_phone/sendAnonMessage', {
                    from: this.anonMessage.from,
                    text: this.anonMessage.text
                }).then(() => { return; }).catch(function () { console.log() });
                this.anonMessage = {};
            }
            
        }
    }
}
</script>

<style scoped>
.loader {
    width: 6em;
    height: 6em;
    font-size: 25px;
    box-sizing: border-box;
    border-top: 0.3em solid hotpink;
    border-radius: 50%;
    position: relative;
    animation: rotating 2s ease-in-out infinite;
    --direction: 1;
}

.loader::before,
.loader::after {
    content: '';
    position: absolute;
    width: inherit;
    height: inherit;
    border-radius: 50%;
    box-sizing: border-box;
    top: -0.2em;
}

.loader::before {
    border-top: 0.3em solid dodgerblue;
    transform: rotate(120deg);
}

.loader::after {
    border-top: 0.3em solid gold;
    transform: rotate(240deg);
}

.loader span {
    position: absolute;
    color: white;
    width: inherit;
    height: inherit;
    text-align: center;
    line-height: 10em;
    font-family: sans-serif;
    animation: rotating 2s linear infinite;
    --direction: -1;
}

@keyframes rotating {
    50% {
        transform: rotate(calc(180deg * var(--direction)));
    }

    100% {
        transform: rotate(calc(360deg * var(--direction)));
    }
}

</style>