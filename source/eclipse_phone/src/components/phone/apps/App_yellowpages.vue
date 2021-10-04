<template>
    <div class="app_fullscreen content_page app_yellow">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button @click="closeApp" class="blue_button_back white" v-text="$ml.get('button_exit')">Выйти</button>
                    <h4 class="app_name">Dynasty 8 exchane</h4>
                </div>
                <div class="content">
                    <div class="item_category" v-for="(item, index) in categoryList" :key="'button_' + item.id" @click="changePage(10 + index)">
                        {{item.name}}
                    </div>
                </div>
                <div class="controls">
                    <button class="btn btn-block" @click="changePage(2)" v-text="$ml.get('yellowpages_button')">Разместить объявление</button>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page == 2">
                 <div class="contact_heading">
                    <button @click="changePage(1)" class="blue_button_back white" v-text="$ml.get('button_back')">Назад</button>
                    <h4 class="app_name" v-text="$ml.get('button_add')">Добавить</h4>
                </div>
                <div class="content">
                    <div class="form-group">
                        <label v-text="$ml.get('yellowpages_text')">Текст сообщения:</label>
                        <textarea class="form-control" v-model="newAds.text"></textarea>
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('yellowpages_image')">Изображение:</label>
                        <input class="form-control" v-model="newAds.image">
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('yellowpages_category')">Категория:</label>
                        <div class="dropdown">
                            <a class="btn btn-dropdown btn-block dropdown-toggle" @click="showDropdown = !showDropdown">{{getCategoryName(newAds.category)}}</a>
                            <div class="dropdown-menu" v-show="showDropdown">
                                <a :class="'dropdown-item status_' + index" v-for="(item, index) in categoryList" :key="'drop_cat' + index" @click="changeCategory(item.id)">
                                    {{item.name}}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="controls">
                    <button class="btn btn-block" @click="addAds()" v-text="$ml.get('button_add')">Добавить</button>
                </div>
            </div>
        </transition>

        <div v-for="(item, index) in categoryList" :key="'category_' + item.id">
            <transition name="transition_03">
                <div class="content_page_l2 page_10" v-show="page==10 + index">
                    <div class="contact_heading">
                        <button @click="changePage(1)" class="blue_button_back white">Назад</button>
                        <h4 class="app_name">{{item.name}}</h4>
                    </div>
                    <div class="content">
                        <div class="item_adv" v-for="(adv, index2) in getAdvFromListById(item.id)" :key="'adv'+ index2">
                            <p>{{adv.text}}</p>
                            <div class="item_adv_image" v-if="adv.image" >
                                <img :src=adv.image class="img-fluid" @click="zoomImage(index2)">
                            
                                <transition name="list">
                                    <div class="item_adv_image_big" @click="zoomImage(index2)" v-show="selected == index2">
                                        <img :src=adv.image class="img-fluid" >
                                    </div>
                                </transition>
                            </div>
                            <h5 class="author">{{adv.author}}</h5>
                            <h6 class="date">{{getFullDate(adv.date)}}</h6>
                        </div>
                    </div>
                </div>
            </transition>
        </div>

    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_yellow',
    components: {
        
    },
    props: {
        playerData: Object,
    },
    data() {
        return {
            page: 1,
            selected: undefined,
            newAds: {"category": 0},
            showDropdown: false,

            categoryList: [
                {"name": "Businesses", "id": 0},
                {"name": "Auto", "id": 1},
                {"name": "Real Estate", "id": 2},
                {"name": "Services", "id": 3},
                {"name": "Search for Services", "id": 4},
                {"name": "Miscellaneous", "id": 5},
            ],
            advList: []
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
        getAdvFromListById(id) {
            return this.advList.filter(i => i.category === id);
        },
        zoomImage(id) {

            if (this.selected == id) {
                this.selected = undefined;
            } else {
                this.selected = id;
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
            return hours + '.' + minutes + ' ' + day + '.'+ month + '.'+ year
        },
        addAds() {
            this.newAds.author = this.playerData.name;
            this.newAds.date = new Date();
            console.log(this.newAds)
            if (this.newAds.text.length > 4) {
                axios.post('https://eclipse_phone/AddAds', {
                    category: this.newAds.category,
                    date: this.newAds.date,
                    text: this.newAds.text,
                    author: this.newAds.author,
                    image: this.newAds.image,
                    playerPhone: this.$parent.playerPhone
                }).then(() => { return; }).catch(function () { console.log() });  
                console.log(this.newAds.author)
                this.advList.unshift(this.newAds);
                this.newAds = {"category": 0};
                this.page = 1;
            }
            
        },
        changeCategory(id) {
            this.newAds.category = id;
            this.showDropdown = false;
        },
        getCategoryName(id) {
            return this.categoryList.find(item => item.id == id).name;
        },
    },
    mounted() {
        this.sortByDate(this.advList);
         window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "SendAddsToNui") {
                this.advList = JSON.parse(event.data.data);
                this.sortByDate(this.advList);
            }
        },
        false
        );
    },
    computed: {
        
    },
    
}
</script>