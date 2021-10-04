<template>
    <div class="app_fullscreen content_page app_message">

        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back" v-text="$ml.get('button_exit')">Выйти</button>
                    <h5 class="heading text-center" v-text="$ml.get('messages_title')">Сообщения</h5>
                    <button @click="changepage(2)" class="blue_button_right" v-text="$ml.get('messages_write')">Написать</button>
                </div>
                <div class="contact_list">
                    <div class="contact" v-for="(item, index) in messageList" :key="item.author" :class="{active: item.messages[item.messages.length - 1].readed == false}" @click="openmessages(index)">
                        <div class="d-flex justify-content-between">
                            <h4>{{findNameById(item.author)}}</h4>
                            <h4 class="date">{{getDate(item.messages[item.messages.length - 1].date)}}</h4>
                        </div>
                        <span>{{item.messages[item.messages.length - 1].message}}</span>
                    </div>
                </div>
            </div>
            
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button @click="changepage(1)" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    <h5 class="heading text-center" v-text="$ml.get('messages_new')">Новое сообщение</h5>
                </div>
                <div class="contact_search">
                    <input type="text" class="search" :placeholder="$ml.get('button_search')" v-model="searchInput" @input="search">
                </div>
                <div class="contact_list"> 
                    <div class="contact" v-for="(contact, index) in contactList" :key="contact.phone" v-show="contact.show"> 
                        <h6 class="name" @click="showfullcontact(index)">{{contact.name}}</h6>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_3" v-show="page==3">
                <div class="contact_heading_outer">
                    <div class="contact_heading">
                        <button @click="changepage(1)" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    </div>
                    <h5 class="heading text-center">{{findNameById(activeMessages.author)}}</h5>
                </div>
                <div class="messages" id="message_list">
                    <transition-group name="list">
                        <div class="message_cloud" v-for="(item, index) in activeMessages.messages" :key="index" :class="{left: item.from}">
                            <div class="message_text">
                                {{item.message}}
                                <span class="date_a">{{getDate(item.date)}}</span>
                            </div>
                        </div>
                    </transition-group>
                </div>
                <div class="controls">
                    <button class="send_photo"></button>
                    <input class="text flex-fill" type="text" v-model="sendMessage" @keyup.enter="sendmessage" >
                    <button class="send_message" @click="trySendMessage" :disabled="!sendFlag"></button>
                </div>
            </div>
        </transition>

    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_message',
    components: {
        
    },
    props: {
        contacts: Array,
        messages: Array,
    },
    data() {
        return {
            contactList: [],
            messageList: [],
            page: 1,

            activeMessages: {},
            sendMessage: '',
            sendFlag: true,
            searchInput: '',
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
            this.page = 1;
        },
        changepage(page) {
            this.showallcontacts();
            this.searchInput = '';
            this.page = page;
            this.$parent.whiteColor = false;
        },
        findNameById(phone) {
            var result = this.contactList.find(item => item.phone == phone);
            if (result) {
                return result.name;
            } else {
                return phone;
            }
        },
        getDate(date) {
            var item = new Date(date)
            var hours = ('0'+item.getHours()).slice(-2);

            var minutes = ('0'+item.getMinutes()).slice(-2);
            return hours + ':' + minutes
        },
        openmessages(index) {
            this.activeMessages = this.messageList[index];
            var amount = this.messageList[index].messages.length - 1;
            this.messageList[index].messages[amount].readed = true;
            this.page = 3;
        },
        newmessages(id) {
            this.activeMessages = {};
            this.activeMessages.author = id;
            this.page = 3;
        },
        trySendMessage() {
            var phone = this.activeMessages.author;
            axios.post('https://eclipse_phone/isPlayerOnline', {
                number: phone
            }).then(() => { return; }).catch(function () { console.log() }); 
        },
        sendmessage() {
            if (this.sendMessage && this.sendFlag) {
                this.sendFlag = false;
                var message = {};
                message.from = false;
                message.readed= true;
                message.numb = 0;
                message.date = new Date();
                message.message = this.sendMessage;

                if(!this.activeMessages.messages) {
                    this.activeMessages.messages = [];
                }

                this.activeMessages.messages.push(message);
                this.sendMessage = '';

                if (this.activeMessages.messages.length == 1) {
                    this.messageList.push(this.activeMessages)
                }
                this.sortByDate();

                this.sendMessageData(message.from, message.readed, message.numb, message.date, message.message, this.activeMessages.author);

                var element = this.$el.querySelector("#message_list");
                var oldScroll = element.scrollHeight;
                setTimeout(() => {
                    var newScroll = element.scrollHeight;
                    var delta = (newScroll - oldScroll) / 100;
                    for (var i = 0; i < 10; i++) {
                        (function(i) {
                            setTimeout(function() {
                                element.scrollTop = oldScroll + delta;
                            }, 100 * i);
                        })(i);
                    }
                }, 300);
                setTimeout(() => {
                    this.sendFlag = true;
                }, 700);
            }
        },
        sendMessageData(from, readed, numb, date, message, author) {
            axios.post('https://eclipse_phone/sendMessageData', {
                from: from,
                readed: true,
                numb: numb,
                date: date,
                message: message,
                author: author,
                playerphone: this.$parent.playerPhone
            }).then(() => { return; }).catch(function () { console.log() }); 
        },
        sortMainArray() {
            this.contactList.sort(function(a, b){
                var nameA=a.name.toLowerCase(), nameB=b.name.toLowerCase()
                if (nameA < nameB)
                    return -1
                if (nameA > nameB)
                    return 1
                return 0
            });
        },
        sortByDate() {
            this.messageList.sort(function(a, b){
                var dateA =new Date(a.messages[a.messages.length - 1].date), dateB=new Date(b.messages[a.messages.length - 1].date)
                return dateB-dateA
            });
        },
        showallcontacts() {
            this.contactList.forEach(element => element.show = true);
        },
        hideallcontacts() {
            this.contactList.forEach(element => element.show = false);
        },
        search() {
            var searchText = this.searchInput
            if (searchText) {
                var exp = new RegExp(searchText, 'igm');
                this.contactList.forEach(element => {
                    var result = element.name.search(exp);
                    if (result == -1) {
                        element.show = false;
                    } else {
                        element.show = true;
                    }
                })
            } else {
                this.showallcontacts();
            }
        },
        showfullcontact(index) {
            var targetPhone = this.contactList[index].phone;
            var messageIndex = this.findMessagesByPhone(targetPhone);
            if (messageIndex != -1) {
                this.openmessages(messageIndex);
            } else {
                this.newmessages(targetPhone);
            }
        },
        findMessagesByPhone(phone) {
            return this.messageList.findIndex(item => item.author == phone);
        },
        findIndexOfContact(phone) {
            return this.contactList.findIndex(item => item.phone == phone);
        },
        openMessagePhone(phone) {
            this.page = 4;
            var index = this.findIndexOfContact(phone);
            this.showfullcontact(index);
        }
    },
    mounted() {
        this.contactList = this.contacts;
        this.sortMainArray();
        this.messageList = this.messages;
        this.sortByDate();
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "PlayerOnline") {
                this.sendmessage();   
            }
            else if(event.data.type == "PlayerNotOnline") {
                console.log("PlayerNotOnline");
            }
        },
        false
        );
    }
}

</script>
