<template>
    <div class="app_fullscreen content_page app_taxi">
        <button class="app_close black" @click="closeApp"></button>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==1">
                
                <div class="app_logo"></div>
                <h4 class="app_name" v-text="$ml.get('taxi_title')">Вызов такси</h4>
                <div class="text-center mt-3">
                    <button class="btn btn-taxi" @click="searchCar()" v-text="$ml.get('taxi_call')">Вызвать</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==2">
                <div class="app_logo"></div>
                <div class="searching" v-show="searching">
                    <p class="text-center"><span v-text="$ml.get('taxi_searching')"></span>{{dots}}</p>
                </div>
                <div class="searching" v-show="!searching">
                    <p class="text-center" v-text="$ml.get('taxi_nocars')">К сожалению, все<br>автомобили заняты.<br>Попробуйте позднее.</p>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2" v-show="page==3">
                <div class="app_logo"></div>
                <p class="text-center">Машина найдена!</p>
            </div>
        </transition>

    </div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'App_taxi',
    components: {
        
    },
    data() {
        return {
            page: 1,
            searching: false,
            dots: '',
            dotsCount: 1,
            dotsActive: 10,
            count: 0,
        }
    },
    mounted() {
    window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "TaxiFound") {
                this.carFinded();
            }
            else if(event.data.type == "TaxiNotFound") {
                this.carUnfinded();
            }
        },
        false
        );
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.page = 1;
            this.$parent.whiteColor = true;
           
        },
        changepage(page) {
            this.page = page;
        },
        searchCar() {
            
            this.count = 0;
            this.searching = true;
            this.changepage(2);
            this.dotsChange();
            axios.post('https://eclipse_phone/TaxiRequest', {
                PlayerName: this.$parent.playerData.name,
                PlayerPhone: this.$parent.playerPhone
            }).then(() => { return; }).catch(function () { console.log() });  
        },
        dotsChange() {
            this.count++;
            if (this.count < this.dotsActive) {
                if (this.dotsCount == 4) {
                    this.dotsCount = 0;
                    this.dots = '';
                } else {
                    this.dots = this.dots + '.';
                }
                this.dotsCount +=1;
                setTimeout(this.dotsChange, 1000);
            } else {
                this.carUnfinded();
            }
        },
        carFinded() {
            this.searching = false;
        },
        carUnfinded() {
            this.searching = false;
        }
    },
}

</script>

<style scoped>

</style>