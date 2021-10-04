<template>
    <div class="app_fullscreen content_page app_settings">
        <transition name="transition_03">
            <div class="content_page_l2 fw page_1" v-show="page==1">
                <div class="contact_heading">
                    <h4 class="app_name" v-text="$ml.get('setting_app')">Settings</h4>
                    <button @click="closeApp" class="blue_button_back" v-text="$ml.get('button_exit')">Выйти</button>
                </div>
                <div class="content">
                    <hr class="iphone">
                    <div class="menu_block">
                        <div class="menu" @click="changePage(2)"><span class="icon "><b-icon icon="person-fill"></b-icon></span><span v-text="$ml.get('setting_account')"></span> <span class="right-icon"><b-icon icon="chevron-right"></b-icon></span></div>
                        <div class="menu" @click="changePage(3)"><span class="icon gear"><b-icon icon="gear-fill"></b-icon></span><span v-text="$ml.get('setting_design')"></span><span class="right-icon"><b-icon icon="chevron-right"></b-icon></span></div>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button @click="changePage(1)" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('setting_myacoung')">Мой аккаунт</h4>
                </div>
                <div class="content">
                    <div class="image">
                        <img :src=playerData.image class="img-fluid">
                    </div>
                    <label v-text="$ml.get('setting_myname')">Моё имя:</label>
                    <h4 class="myphone">{{playerData.name}}</h4>
                    <label v-text="$ml.get('setting_myphone')">Номер телефона:</label>
                    <h4 class="myphone">{{playerData.phone}}</h4>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_3" v-show="page==3">
                <div class="contact_heading">
                    <button @click="changePage(1)" class="blue_button_back" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('setting_design')">Дизайн</h4>
                </div>
                <div class="content">
                    <label v-text="$ml.get('setting_bgtext')">Фоновое изображение:</label>
                    <input class="form-control" v-model="newimage">
                    <span class="help" v-text="$ml.get('setting_helptext')">*Оставьте поле пустым для стандартного изображения.</span>
                </div>
                <div class="controls">
                    <div class="btn" @click="save" v-text="$ml.get('button_save')">Сохранить</div>
                </div>
            </div>
        </transition>


    </div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'App_settings',
    components: {
        
    },
    props: {
        playerData: Object,
    },
    data() {
        return {
            page: 1,
            newimage: undefined,
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
        },
        changePage(page) {
            this.page = page;
        },
        save() {
            this.$parent.$parent.playerData.bgImage = this.newimage;
            axios.post('https://eclipse_phone/ChangeBgImage', {
                    bgImage: this.newimage
                }).then(() => { return; }).catch(function () { console.log() });  
            this.page = 1;
        }
    }
}
</script>