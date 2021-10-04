<template>
    <div class="app_fullscreen content_page app_calendar">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back" v-text="$ml.get('button_exit')">Выйти</button>
                </div>
                <div class="content">
                    <h3>{{localeMonth}}</h3>
                    <div class="calendar_table">
                        <div class="cell_outer">
                            <datepicker
                                format="MM-dd-yyyy"
                                :monday-first="true"
                                :full-month-name=true
                                :language="en"
                                :inline="true"
                                :value="today()"
                                :disabled="true"
                            ></datepicker>
                        </div>
                    </div>
                </div>
            </div>
        </transition>
    </div>
</template>

<script>
import datepicker from 'vuejs-datepicker';
import {ru, en} from 'vuejs-datepicker/dist/locale'

export default {
    name: 'App_calendar',
    components: {
        datepicker
    },
    data() {
        return {
            page: 1,
            ru: ru,
            en: en
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
        },
        changepage(page) {
            this.page = page;
            this.$parent.whiteColor = false;
        },
        today() {
            var today = new Date();
            return today;
        }
    },
    computed: {
        localeDate() {
            var today = new Date();
            var week = today.getDay();
            var date = today.getDate();
            var month = today.getMonth();
            return week + ', ' + date + ' ' + month;
        },
        localeMonth() {
            var today = new Date();
            var month = today.toLocaleString('default', { month: 'long' });
            return month;
        },
        localeYear() {
            var today = new Date();
            var year = today.getFullYear();
            return year;
        },
        
    },
}
</script>