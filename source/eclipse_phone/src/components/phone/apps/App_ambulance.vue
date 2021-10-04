<template>
    <div class="app_fullscreen content_page app_ambulance">
        
    
        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==1">
                <button class="app_close black" @click="closeApp"></button>
                <div class="app_logo"></div>
                <h4 class="app_name" v-text="$ml.get('ambulance_name')">Ambulance</h4>
                <div class="main_menu">
                    <button class="btn btn-block btn_ambulance_red" @click="changePage(2)" v-text="$ml.get('ambulance_button_A')">Срочный вызов скорой</button>
                    <button class="btn btn-block btn_ambulance_red" @click="changePage(3), appointment={}" v-text="$ml.get('ambulance_button_B')">Записаться на приём</button>
                    <button class="btn btn-block btn_ambulance_red" @click="changePage(5)" v-text="$ml.get('ambulance_button_C')">Общая информация</button>
                </div>

                <div class="ambulance_logo">
                    <img class="img-fluid" src="../../../assets/img/phone/ambulance/ambulance_logo.png">
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==2">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
                <div class="content">
                    <h3 class="text-center" v-text="$ml.get('ambulance_A_title')">Срочный вызов скорой помощи</h3>
                    <h4 class="text-center" v-text="$ml.get('ambulance_A_description')">Внимание! Вы несете полную ответственность за ложный вызов. Используйте только для экстренных вызовов!</h4>
                    <div class="d-flex justify-content-center">
                        <button class="btn btn_ambulance emergency mt-3" @click="hospitalPanicButton(21)" v-text="$ml.get('ambulance_A_call')">Вызвать помощь</button>
                    </div>
                    
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==21">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
                <div class="content">
                    <h3 class="text-center" v-text="$ml.get('ambulance_A_call')">Помощь вызвана</h3>
                    <p v-text="$ml.get('ambulance_A_sended_titleA')">Пожалуйста, дождитесь врачей скорой помощи.</p>
                    <p v-text="$ml.get('ambulance_A_sended_titleB')">Если есть пострадавшие, окажите первую помощь.</p>
                </div>
            </div>
        </transition>



        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==3">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
                <div class="content">
                    <h3 class="" v-text="$ml.get('ambulance_B_title')">Запись на прием</h3>
                    <div class="form-group">
                        <label v-text="$ml.get('ambulance_B_name')">Имя и фамилия:</label>
                        <input class="" v-model="appointment.name" @change="checkErrorOne" :class="{green: !showErrorOne}">
                        <transition name="transition_02">
                            <div v-show="showErrorOne == true" class="invalid-feedback">
                                Enter name
                            </div>
                        </transition>
                        
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('ambulance_B_subject')">Тема обращения:</label>
                        <input class="" v-model="appointment.theme" @change="checkErrorTwo" :class="{green: !showErrorTwo}">
                        <transition name="transition_02">
                            <div v-show="showErrorTwo == true" class="invalid-feedback">
                                Enter subject
                            </div>
                        </transition>
                    </div>
                    <div class="form-group">
                        <p v-text="$ml.get('ambulance_B_description')">Регистратор получит ваше сообщения и свяжется с вами в ближайшее время.</p>
                        <button class="btn btn-block btn_ambulance" @click="toAppointment" v-text="$ml.get('ambulance_B_sign')">Записаться</button>
                    </div>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==31">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
                <div class="content">
                    <h5 v-text="$ml.get('ambulance_B_message_send')">Сообщение успешно отправлено</h5>
                </div>
            </div>
        </transition>


        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==4">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==5">
                <div class="contact_heading bottom-fix">
                    <button class="btn btn_ambulance" @click="changePage(1)" v-text="$ml.get('button_back')">Назад</button>
                </div>
                <div class="content">
                    <p><b v-text="$ml.get('ambulance_C_title')">Уважаемые жители штата!</b></p>
                    <p v-text="$ml.get('ambulance_C_text')">Мы стремимся к сохранению и укреплению Вашего здоровья и сделаем все, чтобы Ваше пребывание в нашей больнице стало комфортным, а выздоровление — быстрым. Наша конечная цель — предоставление Вам качественной медицинской помощи.</p>
                </div>
            </div>
        </transition>




    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_ambulance',
    components: {
        
    },
    data() {
        return {
            page: 1,
            appointment: {},
            playerPhone: '',
            showErrorOne: false,
            showErrorTwo: false,
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.page=1;
        },
        changePage(page) {
            this.page=page;
        },
        hospitalPanicButton(page) {
            this.page=page;
            axios.post('https://eclipse_phone/AmbulancePanicButton', {

            }).then(() => { return; }).catch(function () { console.log() });  
        },
        toAppointment() {
            this.checkErrorOne()
            this.checkErrorTwo()

            if (!this.showErrorOne && !this.showErrorTwo ) {
                this.page = 31;
                this.showErrorOne = false;
                this.showErrorTwo = false;
            }
            axios.post('https://eclipse_phone/AmbulanceCall', {
                PlayerName: this.$parent.playerData.name,
                PlayerPhone: this.$parent.playerPhone,
                Message: this.appointment.theme,
            }).then(() => { return; }).catch(function () { console.log() });  
        },
        checkErrorOne() {
            if (this.appointment.name) {
                this.showErrorOne = false;
            } else {
                this.showErrorOne = true;
            }
        },
        checkErrorTwo() {
            if (this.appointment.theme) {
                this.showErrorTwo = false;
            } else {
                this.showErrorTwo = true;
            }
        }
    },
    mounted() {
        this.playerPhone = this.$parent.playerPhone;
    }
}

</script>

<style scoped>

</style>