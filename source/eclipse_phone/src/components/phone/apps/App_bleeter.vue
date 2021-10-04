<template>
    <div class="app_fullscreen content_page app_bleeter">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back" v-text="$ml.get('button_exit')">Выйти</button>
                    <div class="blee_logo"></div>
                    <a class="blee_a" @click="changepage(3)" v-text="$ml.get('bleeter_profile')">Профиль</a>
                </div>
                <div class="content" id="bleets">
                    <div class="bleet" v-for="(bleet, index) in bleetList" :key="'bleet' + index">
                        <div class="bleet_logo">
                            <img  :src="bleet.authorImage" >
                        </div>
                        <div class="bleet_content">
                            <div class="d-flex justify-content-between">
                                <h4 :class="{verified: bleet.verifyed}">{{bleet.author}} </h4>
                                <span>{{getTime(bleet.date)}}</span>
                            </div>
                            
                            <p>{{bleet.text}}</p>
                            <div class="bleet_image_outer" v-if="bleet.image">
                                <div class="bleet_image" :class="{active: selected == index}" @click="zoomImage(index)">
                                    <img class="img-fluid" :src="bleet.image">
                                </div>
                                <div class="bg_image" @click="closeAllImages()">
                                    <img class="img-fluid" :src="bleet.image">
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>
                <div class="controls">
                    <button class="btn btn-bleet" @click="changepage(2)" v-text="$ml.get('bleeter_bleet')"></button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button @click="changepage(1)" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('bleeter_newbleet')">Новый блит</h4>
                </div>
                <div class="bleet_new">
                    <div class="bleet_logo">
                        <img :src="getImage(playerData.image)" class="img-fluid">
                    </div>
                    <div class="bleet_form">
                        <textarea type="text" rows="5" maxlength="140" v-model="newBleet.text" :placeholder="$ml.get('bleeter_text')"></textarea>
                        <input type="text" :placeholder="$ml.get('bleeter_image')" v-model="newBleet.image">
                    </div>
                </div>
                <div class="control">
                    <button class="btn btn-bleet" @click="sendNewBleet()" v-text="$ml.get('bleeter_bleet')">Блитнуть</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_3" v-show="page==3">
                <div class="contact_heading">
                    <button @click="changepage(1), changeLogin = false" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('bleeter_profile')">Профиль</h4>
                </div>
                <div class="profile">
                    <div class="author_image">
                        <img :src="getImage(playerData.image)" class="img-fluid">
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('bleeter_nickname')">Никнейм:</label>
                        <div class="" v-if="!changeLogin">
                            <h5>@{{playerData.bleetname}} <a class="change" @click="changeBleetLogin()" v-text="$ml.get('button_edit')">(изменить)</a></h5>
                            
                        </div>
                        <div class="" v-if="changeLogin">
                            <input type="text" v-model="newLogin">
                            <div class="d-flex justify-content-between">
                                <a class="change" @click="changeLogin = false, newLogin = playerData.bleetname;" v-text="$ml.get('button_cancel')">отменить</a>
                                <a class="change" @click="saveLogin()" v-text="$ml.get('button_save')">сохранить</a>
                            </div>
                            
                            <span class="errortext" v-show="showerror" v-text="$ml.get('bleeter_error')">Допускаются только латинские буквы и цифры. Длина от 3 до 20 символов!</span>
                        </div>
                    </div>
                </div>
            </div>
        </transition>


    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_bleeter',
    props: {
        playerData: Object,
    },
    data() {
        return {
            page: 1,
            selected: undefined,
            newBleet: {},
            changeLogin: false,
            newLogin: '',
            showerror: false,
            bleetList: []
        }
    },
    methods: {
        closeApp() {
            this.closeAllImages();
            this.$parent.page = 2;
        },
        changepage(page) {
            this.closeAllImages();
            this.page = page;
        },
        zoomImage(id) {
            if (this.selected == id) {
                this.selected = undefined;
            } else {
                this.selected = id;
            }
        },
        closeAllImages() {
            this.selected = undefined;
        },
        changeBleetLogin() {
            this.changeLogin = true;
        },
        sendNewBleet() {
            if (this.newBleet.text.length > 3) {
                this.newBleet.author = this.playerData.bleetname;
                this.newBleet.date = new Date();
                this.newBleet.authorImage = this.playerData.bleetimage;
                if (this.playerData.verifyed) {
                    this.newBleet.verifyed = this.playerData.verifyed;
                }
                this.bleetList.unshift(this.newBleet);
                // this.Bleet отправляем на бэк
                axios.post('https://eclipse_phone/sendNewBleet', {
                    author: this.newBleet.author,
                    messageId: this.newBleet.messageId,
                    authorImage: this.newBleet.authorImage,
                    text: this.newBleet.text,
                    image: this.newBleet.image,
                    date: this.newBleet.date,
                    authorPhone: this.$parent.playerPhone
                }).then(() => { return; }).catch(function () { console.log() });  
                this.newBleet = {};
                this.page = 1;
                setTimeout(() => {
                    this.scrollTop()
                }, 200);
            }
        },
        saveLogin() {
            var reg = /^[A-Za-z0-9]+$/i;
            if(this.newLogin.length > 3 && this.newLogin.length < 20 && reg.test(this.newLogin)) {
                this.changeLogin = false;
                this.$set(this.playerData, 'bleetname', this.newLogin);
                this.showerror = false;
                axios.post('https://eclipse_phone/saveLoginBleeter', {
                    login: this.newLogin,
                    playerPhone : this.$parent.playerPhone
                }).then(() => { return; }).catch(function () { console.log() });  
            } else {
                this.showerror = true;
            }
        },
        sortByDate(array) {
            array.sort(function(a, b){
                var dateA = new Date(a.date), dateB=new Date(b.date)
                return dateB-dateA
            });
        },
        getFullDate(date) {
            var item = new Date(date)
            var day = ('0'+item.getDate()).slice(-2);
            var month = ('0'+(item.getMonth() + 1)).slice(-2);
            var year = item.getFullYear()
            var hours = ('0'+item.getHours()).slice(-2);
            var minutes = ('0'+item.getMinutes()).slice(-2);
            return day + '.'+ month + '.'+ year +'|' + hours + '.' + minutes
        },
        getTime(date) {
            var item = new Date(date)
            var hours = ('0'+item.getHours()).slice(-2);
            var minutes = ('0'+item.getMinutes()).slice(-2);
            return hours + '.' + minutes
        },
        getImage(img) {
            if (img) {
                return img
            } else {
                img = "https://via.placeholder.com/160";
                return img;
            }
        },
        scrollTop() {
            var element = this.$el.querySelector("#bleets");
            element.scrollTop = 0;
        }
    },
    mounted() {
        this.sortByDate(this.bleetList);
        if (this.playerData.bleetname) {
            this.newLogin = this.playerData.bleetname;
        }
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "SendBleeterMessage") {
                this.bleetList = JSON.parse(event.data.data);
            }
            else if(event.data.type == "SendBleeterLogin") {
                this.$set(this.playerData, 'bleetname', event.data.data);
            }
        },
            false
        );
    }
}
</script>