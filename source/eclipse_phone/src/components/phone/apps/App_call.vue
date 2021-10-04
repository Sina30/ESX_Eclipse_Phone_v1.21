<template>
    <div class="app_fullscreen content_page app_call">
        
        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==1">
                <button @click="closeApp" class="backtocontacts" v-text="$ml.get('button_exit')">Выйти</button>
                <div class="phone_number_block">
                    <h3 class="phone_number">{{phoneNumber}}</h3>

                </div>
                <div class="number_block">
                    <div class="number">
                        <button class="number_button" @click="addnumb(1)">
                            <span>1</span>
                        </button>
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(2)">
                            <span>2</span>
                            <span class="letters">ABC</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(3)">
                            <span>3</span>
                            <span class="letters">DEF</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(4)">
                            <span>4</span>
                            <span class="letters">GHI</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(5)">
                            <span>5</span>
                            <span class="letters">JKL</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(6)">
                            <span>6</span>
                            <span class="letters">MNO</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(7)">
                            <span>7</span>
                            <span class="letters">PQRS</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(8)">
                            <span>8</span>
                            <span class="letters">TUV</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(9)">
                            <span>9</span>
                            <span class="letters">WXYZ</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button alone1" @click="addnumb('*')">
                            <span>*</span>
                        </button>
                    </div>
                    <div class="number">
                        <button class="number_button" @click="addnumb(0)">
                            <span>0</span>
                            <span class="letters">+</span>
                        </button>
                        
                    </div>
                    <div class="number">
                        <button class="number_button alone2" @click="addnumb('#')">
                            <span>#</span>
                        </button>
                    </div>
                </div>
                <div class="number_block justify-content-end">
                    <div class="number">
                        <button class="number_button call_button justify-content-center" @click="calltoplayer()">
                            <i class="call_icon"></i>
                        </button>
                    </div>
                    <div class="number">
                        <button class="number_button delete_numb" @click="deletelastsymbol">
                            <span></span>
                        </button>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button @click="closeApp" class="backtocontacts" v-text="$ml.get('button_exit')">Выйти</button>
                    <h5 class="heading" v-text="$ml.get('call_contacts')">Контакты</h5>
                    <button @click="addcontact()" class="editcontact" v-text="$ml.get('button_add')">Добавить</button>
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
                <button @click="changepage(2)" class="backtocontacts" v-text="$ml.get('call_contacts')">Контакты</button>
                <button @click="editcontact()" class="editcontact" v-text="$ml.get('button_edit')">Редактировать</button>
                <div class="d-flex justify-content-center">
                    <div class="image"></div>
                </div>
                <h3>{{activeContact.name}}</h3>
                <div class="d-flex justify-content-center">
                    <div class="button_call">
                        <button @click="calltoplayer(1)"></button>
                        <span v-text="$ml.get('call_button_call')">Позвонить</span>
                    </div>
                    <div class="button_message">
                        <button @click="smstoplayer(activeContact.phone)"></button>
                        <span v-text="$ml.get('call_button_message')">Сообщение</span>
                    </div>
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_number')">Номер:</span>
                    <h5>{{activeContact.phone}}</h5>
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_note')">Заметка:</span>
                    <h6>{{activeContact.about}}</h6>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_4" v-show="page==4">
                <button @click="changepage(3)" class="backtocontacts" v-text="$ml.get('button_back')">Назад</button>
                <div class="about">
                    <span v-text="$ml.get('call_name')">Имя:</span>
                    <input type="text" class="name" v-model="editedContact.name">
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_number')">Телефон:</span>
                    <input type="text" class="name" v-model="editedContact.phone">
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_note')">Заметка:</span>
                    <textarea rows="5" maxlength="100" class="name" v-model="editedContact.about">
                    </textarea>
                </div>
                <button class="delete_contact" @click="showdeletewindow" v-text="$ml.get('call_button_delete')">Удалить контакт</button>
                <transition name="transition_03">
                    <div class="delete_contact_mask" v-show="showDeleteContact">
                        <div class="delete_contact_accept" >
                            <button class="deletecontact" @click="deletecontact" v-text="$ml.get('button_delete')">Удалить</button>
                            <button class="deletecancel" @click="deletecancel" v-text="$ml.get('button_cancel')">Отмена</button>
                        </div>
                    </div>
                </transition>
                <div class="save_contact_outer">
                    <button class="save_contact" @click="savecontact" v-text="$ml.get('button_save')">Сохранить</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_5" v-show="page==5">
                <button @click="changepage(2)" class="backtocontacts" v-text="$ml.get('button_back')">Назад</button>
                <div class="about">
                    <span v-text="$ml.get('call_name')">Имя:</span>
                    <input type="text" class="name" v-model="addContact.name">
                    <span v-show="addContactErrorName" class="errortext" v-text="$ml.get('call_error1')">Add name</span>
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_number')">Телефон:</span>
                    <input type="text" class="name" v-model="addContact.phone">
                    <span v-show="addContactErrorPhone" class="errortext" v-text="$ml.get('call_error2')">Add numb</span>
                </div>
                <div class="about">
                    <span v-text="$ml.get('call_note')">Заметка:</span>
                    <textarea rows="5" maxlength="100" class="name" v-model="addContact.about">
                    </textarea>
                </div>
                <div class="add_contact_outer">
                    <button class="add_contact" @click="addcontacttoarray" v-text="$ml.get('button_add')">Добавить</button>
                </div>
            </div>
        </transition>



        <transition name="transition_03">
            <div class="content_page_l2 page_10" v-show="page==10">
                <h3 class="text-center" v-text="$ml.get('call_call')">Звоним</h3>
                <h4 class="text-center" v-show="callName"><b>{{callName}}</b></h4>
                <h4 class="text-center" v-show="callNumber">{{callNumber}}</h4>

                <button class="cancel_button" @click="declineCall">
                    <i class="call_icon"></i>
                </button>

            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_11" v-show="page==11">
                <h3 class="text-center" v-text="$ml.get('call_incoming')">Входящий:</h3>
                <h4 class="text-center" v-show="incomingName">{{incomingName}}</h4>
                <h4 class="text-center" v-show="incomingNumber"><b>{{incomingNumber}}</b></h4>
                

                <button class="cancel_button" @click="declineCall">
                    <i class="call_icon"></i>
                </button>
                <button class="accept_button" @click="acceptCall">
                    <i class="call_icon"></i>
                </button>

            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_10" v-show="page==12">
                <h4 class="text-center" v-show="incomingName">{{incomingName}}</h4>
                <h4 class="text-center" v-show="incomingNumber"><b>{{incomingNumber}}</b></h4>
                <h5 class="timer text-center">{{showMinutes}}:{{showSeconds}}</h5>
                <button class="cancel_button" @click="declineCall">
                    <i class="call_icon"></i>
                </button>
            </div>
        </transition>


        

        <div class="bottom_part" v-show="page==1||page==2">
            <button @click="changepage(1)" :class="{active: page == 1}" v-text="$ml.get('call_keys')">Клавиши</button>
            <button @click="changepage(2)" :class="{active: page == 2}" v-text="$ml.get('call_contacts')">Контакты</button>
        </div>
    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_call',
    components: {
        
    },
    props: {
        contacts: Array,
    },
    data() {
        return {
            page: 1,
            phoneNumber: '',

            callNumber: '',
            callName: '',

            contactList: [],
            showFull: false,
            showDeleteContact: false,
            activeContact: {},
            editedContact: {},
            addContact: {},
            addContactErrorName: false,
            addContactErrorPhone: false,

            searchInput:'',
            incomingNumber: '',
            incomingName: '',
            realtimer: 0,
            timerActive: false,
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
            this.page = 1;
            this.phoneNumber = '';
            this.searchInput = '';
            this.showallcontacts();
        },
        changepage(page) {
            this.page = page;
            this.$parent.whiteColor = false;
        },
        calltoplayer(flag){
            if (flag == 1) {
                this.phoneNumber = this.activeContact.phone;
                this.callName = this.activeContact.name;
            } 
            this.callNumber = this.phoneNumber;
            var length = this.callNumber.length;
            if (length >= 3) {
                this.$parent.whiteColor = true;
                this.page = 10;
                axios.post('https://eclipse_phone/tryStartCall', {
                    targetNumber: this.phoneNumber,
                    playerNumber: this.$parent.playerPhone,
                }).then(() => { return; }).catch(function () { console.log() });
            }
        },
        callcancel() {
            this.callName = '';
            this.changepage(1)
        },
        addnumb(numb) {
            var length = this.phoneNumber.length;
            if (length == 3) {
                this.phoneNumber = this.phoneNumber + '-'
            }
            // if (length == 6) {
            //     this.phoneNumber = this.phoneNumber + '-'
            // }
            this.phoneNumber = this.phoneNumber + String(numb);
        },
        deletelastsymbol() {
            this.phoneNumber = this.phoneNumber.substring(0, this.phoneNumber.length - 1);
            var length = this.phoneNumber.length;
            // if (length == 7) {
            //     this.phoneNumber = this.phoneNumber.substring(0, this.phoneNumber.length - 1);
            // }
            if (length == 4) {
                this.phoneNumber = this.phoneNumber.substring(0, this.phoneNumber.length - 1);
            }
        },
        showfullcontact(numb) {
            this.activeContact = this.contactList[numb];
            this.activeContact.numb = numb;
            this.changepage(3);
        },
        addcontact() {
            this.addContact = {};
            this.page = 5;
            this.searchInput = '';
            this.showallcontacts();
        },
        addcontacttoarray() {
            var isName = false;
            var isPhone = false;
            if (this.addContact.name) {
                isName = true;
                this.addContactErrorName = false;
            } else {
                this.addContactErrorName = true;
            }
            if (this.addContact.phone) {
                isPhone = true;
                this.addContactErrorPhone = false;
            } else {
                this.addContactErrorPhone = true;
            }
            if (isName && isPhone) {
                this.page = 2;
                this.contactList.push(this.addContact);
                this.showallcontacts();
                this.sortMainArray()
                axios.post('https://eclipse_phone/SendContactsData', {
                    Contacts: this.contactList,
                    Number: this.$parent.playerPhone,
                }).then(() => { return; }).catch(function () { console.log() });
            }
        },
        editcontact() {
            Object.assign(this.editedContact, this.activeContact);
            this.page = 4;
        },
        showdeletewindow() {
            this.showDeleteContact = true;
        },
        deletecancel() {
            this.showDeleteContact = false;
        },
        deletecontact() {
            this.contactList.splice([this.editedContact.numb], 1);
            this.page = 2;
            this.showDeleteContact = false;
            axios.post('https://eclipse_phone/SendContactsData', {
                    Contacts: this.contactList,
                    Number: this.$parent.playerPhone,
            }).then(() => { return; }).catch(function () { console.log() });
        },
        savecontact() {
            Object.assign(this.contactList[this.activeContact.numb], this.editedContact);
            axios.post('https://eclipse_phone/SendContactsData', {
                    Contacts: this.contactList,
                    Number: this.$parent.playerPhone,
            }).then(() => { return; }).catch(function () { console.log() });
            this.page = 3;
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
        smstoplayer(id) {
            this.closeApp();
            this.$parent.runApp(11);
            this.$parent.$refs.appMessage.openMessagePhone(id);
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
        incomingCall(phone) {
            this.$parent.page = 10;
            this.page = 11;
            this.$parent.whiteColor = true;
            this.incomingNumber = phone;
            this.incomingName = this.findNameByPhone(phone);
        },
        findNameByPhone(phone) {
            var item = this.contactList.find(item => item.phone == phone)
            if (item) {
                return item.name;
            } else {
                return '';
            }
        },
        acceptCall() {
            this.page = 12;
            this.$parent.whiteColor = true;
            this.timerActive = true;
            this.realtimer = 0;
            this.runTimer();
            axios.post('https://eclipse_phone/AcceptCall', {
                    targetNumber: this.incomingNumber,
                    playerNumber: this.$parent.playerPhone,
            }).then(() => { return; }).catch(function () { console.log() });
        },
        declineCall() {
            this.$parent.whiteColor = true;
            this.timerActive = false;
            this.page = 1;
            
            axios.post('https://eclipse_phone/DeclineCall', {
                    targetNumber: this.phoneNumber,
                    playerNumber: this.$parent.playerPhone,
            }).then(() => { return; }).catch(function () { console.log() });
        },
        runTimer() {
            this.realtimer++;
            if (this.timerActive) {
                setTimeout(this.runTimer, 1000);
            }
        }
    },
    mounted() {
        this.contactList = this.contacts;
        this.sortMainArray()
        this.showallcontacts();
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "StartCall") {
                this.incomingCall(event.data.phoneNumber);
            }
            else if(event.data.type == "CallStarted") {
                this.page = 12;
                this.$parent.whiteColor = true;
                this.timerActive = true;
                this.realtimer = 0;
                this.runTimer();
                this.incomingNumber = event.data.phone;
                this.incomingName = this.findNameByPhone(this.incomingNumber);

            }
            else if(event.data.type == "TargetStopCall") {
                // отмена вызова 
                this.page = 1;
                this.incomingNumber = '';
                this.incomingName = '';
                this.timerActive = false;
            }
            else if(event.data.type == "TargetPhone") {
                this.phoneNumber = event.data.phone;
            }
        },
        false
        );
    },
    computed: {
        showSeconds() {
            var result = (this.realtimer % 60)
            return ('0' + result).slice(-2);
        },
        showMinutes() {
            var result = Math.trunc((this.realtimer / 60));
            return ('0' + result).slice(-2);
        },
    }

}
</script>