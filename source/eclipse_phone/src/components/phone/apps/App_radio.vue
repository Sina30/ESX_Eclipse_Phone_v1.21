<template>
    <div class="app_fullscreen content_page app_radio">
        

        <transition name="transition_03">
            <div class="content_page_l2 fw" v-show="page==1">
                <div class="top_bar">
                    <button class="app_close list" @click="changepage(2)"></button>
                    <h4 class="app_name">Fm radio</h4>
                    <button class="app_close" @click="closeApp"></button>
                </div>
                <div class="center_bar">
                    <h2 v-show="currentRadio != 0">{{radioStations[currentRadio].frequency}}</h2>
                    <h4>{{radioStations[currentRadio].name}}</h4>
                    
                </div>
                <div class="frequency">
                    <div class="lines">
                        <div class="horizontal">
                            <div :class="'line line_' + n" v-for="n in 25" :key="n"></div>
                        </div>
                        <div class="vertical">
                            <div :class="'line line_' + n" v-for="n in 5" :key="n">{{n*5 + 85}}</div>
                        </div>
                        <div class="radio-mark" v-show="currentRadio !=0" :style="{left: (((radioStations[currentRadio].frequency - 90) * 9) + 33) + 'px', }"></div>
                    </div>
                </div>
                <div class="control">
                    <button class="btn r-left" @click="radioPrevious" v-text="$ml.get('button_previous')">Назад</button>
                    <button class="btn r-right" @click="radioNext" v-text="$ml.get('button_next')">Вперед</button>
                </div>
            </div>
        </transition>

         <transition name="transition_03">
            <div class="content_page_l2 fw page_2" v-show="page==2">
                <div class="top_bar">
                    <button class="app_close back" @click="changepage(1)"></button>
                    <h4 class="app_name" v-text="$ml.get('radio_all')">Все станции</h4>
                    <button class="app_close" @click="closeApp"></button>
                </div>
                <div class="station_list scrolled">
                    <div :class="[{active: index == currentRadio}, 'station_item']" v-for="(item, index) in radioStations" :key="index" @click="chooseRadio(index)">
                        <h5>{{item.name}}</h5><h5 v-show="item.frequency != 0">{{item.frequency}}</h5>
                    </div>
                </div>
            </div>
         </transition>


    </div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'App_radio',
    components: {
        
    },
    data() {
        return {
            page: 1,
            currentRadio: 0,
            radioStations: [
                {name: "Turn off", frequency: 0},
                {name: 'Radio Los Santos', frequency: 106.1},
                {name: 'Space 103.2', frequency: 103.2},
                {name: 'West Coast Classics', frequency: 95.6},
                {name: 'Rebel Radio', frequency: 101.9},
                {name: 'Los Santos Rock Radio', frequency: 102.3},
                {name: 'The Lowdown 91.1', frequency: 91.1},
                {name: 'Blue Ark', frequency: 103.0},
                {name: 'Non-Stop-Pop FM', frequency: 100.7},
                {name: 'East Los FM', frequency: 106.2},
                {name: 'WorldWide FM', frequency: 103.7},
                {name: 'Channel X', frequency: 99.1},
                {name: 'Radio Mirror Park', frequency: 88.9},
                {name: 'Vinewood Boulevard Radio', frequency: 107.4},
                {name: 'Soulwax FM', frequency: 104.5},
                {name: 'FlyLo FM', frequency: 105.6},
                {name: 'Blaine County Radio', frequency: 96.5},
                {name: 'WCTR', frequency: 95.6},
                {name: 'The Lab', frequency: 94.5},
                {name: 'blonded Los Santos 97.8 FM', frequency: 97.8},
                {name: 'Los Santos Underground Radio', frequency: 106.7},
                {name: 'iFruit Radio', frequency: 108.3},
                {name: 'Kult FM 99.1', frequency: 99.1},
                {name: 'Self Radio', frequency: 110.5}
            ]
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.page = 1;
            this.$parent.whiteColor = true;
        },
        radioPrevious() {
            this.currentRadio -= 1;
            if (this.currentRadio == -1) {
                this.currentRadio = 23
            }
            this.sendRadio()
        },
        radioNext() {
            this.currentRadio += 1;
            if (this.currentRadio == 24) {
                this.currentRadio = 0;
            }
            this.sendRadio()
        },
        chooseRadio(index) {
            this.page = 1;
            this.currentRadio = index;
            this.sendRadio();
        },
        sendRadio() {
            if (this.currentRadio != 0) {
                axios.post('https://eclipse_phone/SetRadioStation', {
                    station: this.currentRadio,
                }).then(() => { return; }).catch(function () { console.log() });
            } else {
                this.stopRadio();
            }
        },
        stopRadio() {
            axios.post('https://eclipse_phone/StopRadio', {
            }).then(() => { return; }).catch(function () { console.log() });
        },
        changepage(page) {
            this.page = page;
        },
    }
}

</script>

<style scoped>

</style>