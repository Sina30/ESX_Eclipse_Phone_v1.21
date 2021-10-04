<template>
    <div class="app_fullscreen content_page app_weather">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back" v-text="$ml.get('button_exit')"></button>
                </div>
                <div class="weather_today">
                    <h3>{{zone}}</h3>
                    <h4>{{weatherTypes[currentWeather]}} <span v-html="weatherIcons[currentWeather]"></span></h4>
                    <h2>{{temperature}}</h2>
                    
                </div>
            </div>
        </transition>


    </div>
</template>

<script>

export default {
    name: 'App_weather',
    components: {
        
    },
    props: {
    },
    data() {
        return {
            page: 1,
            currentWeather: 0,
            zone: 'Not loaded',
            temperature: 0,
            weather: {location: 'North San Andreas', weather: "sunny", temperature: 24},
            weatherTypes: [ 'Clear', 'Clouds', 'Smog', 'ExtraSunny', 'Foggy', 'Overcast', 'Clearing', 'Blizzard', 'Christmas', 'Halloween', 'Neutral', 'Raining', 'Snowing', 'Snowlight', 'ThunderStorm'],
            weatherIcons: ['<i class="wi wi-day-sunny"></i>', '<i class="wi wi-cloud"></i>', '<i class="wi wi-smog"></i>', '<i class="wi wi-hot"></i>', '<i class="wi wi-fog"></i>', '<i class="wi wi-cloudy"></i>', '<i class="wi wi-day-sunny"></i>', '<i class="wi wi-storm-showers"></i>', '<i class="wi wi-snow-wind"></i>', '<i class="wi wi-lunar-eclipse"></i>', '<i class="wi wi-day-cloudy"></i>', '<i class="wi wi-rain"></i>', '<i class="wi wi-snow"></i>', '<i class="wi wi-snowflake-cold"></i>', '<i class="wi wi-thunderstorm"></i>',
            ],
        }
    },
    mounted() {
        this.contactList = this.contacts;
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "GetWeather") {
                this.currentWeather = this.getWeatherNameById(event.data.weather);
                this.zone = event.data.zone;
                this.temperature = event.data.temperature;
            }
        },
        false
        );
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
        getWeatherNameById(weather) {
            switch (weather)
            {
                case 916995460:
                    return 0;
                case 821931868:
                    return 1;
                case 282916021:
                    return 2;
                case -1750463879:
                    return 3
                case -1368164796:
                   return 4;
                case -1148613331:
                    return 5;
                case 1840358669:
                    return 6;
                case 669657108:
                    return 7
                case -1429616491:
                    return 8
                case -921030142:
                    return 9
                case -1530260698:
                    return 10
                case 1420204096:
                    return 11
                case -273223690:
                    return 12
                case 603685163:
                    return 13
                case -1233681761:
                    return 14
            }
        }
    },
}
</script>