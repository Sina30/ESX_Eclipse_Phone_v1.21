<template>
    <div class="app_fullscreen content_page app_weazel" :class="{editor: isJournalist}">

        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==10">
                <div class="wrapper">
                    <span class="circle circle-1"></span>
                    <span class="circle circle-2"></span>
                    <span class="circle circle-3"></span>
                    <span class="circle circle-4"></span>
                    <span class="circle circle-5"></span>
                    <span class="circle circle-6"></span>
                    <span class="circle circle-7"></span>
                    <span class="circle circle-8"></span>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <div class="contact_heading">
                    <button class="btn btn_weazel" @click="closeApp" v-text="$ml.get('button_exit')"></button>
                    <h4 class="app_name">Weazel News App</h4>
                </div>
                <div class="content">
                    <div class="material" v-for="(item, index) in newsData" :key="item.id">
                        <h2>{{item.title}}</h2>
                        <div class="material_image" v-if="item.image">
                            <div class="image" :style="{'background-image': 'url(' + item.image + ')'}">
                            </div>
                        </div>
                        <h3 class="subtitle">{{item.subtitle}}</h3>
                        <div class="meta">
                            <span class="date">{{getDate(item.date)}}</span>
                            <button class="btn btn_weazel" @click="readFull(index)" v-text="$ml.get('weazel_more')"></button>
                        </div>
                    </div>
                </div>
                <div class="addnews">
                    <button class="btn btn-block btn_weazel text-center" v-show="isJournalist" @click="addNews" v-text="$ml.get('weazel_addnews')"></button>
                    <h5 v-show="!isJournalist" class="adress">Little Seoul, Los Santos</h5>
                </div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <div class="contact_heading">
                    <button class="btn btn_weazel before" @click="changepage(1), activeData = {}" v-text="$ml.get('button_back')"></button>
                    <button class="btn btn_weazel" @click="deleteNews(activeIndex)" v-show="isJournalist" v-text="$ml.get('button_delete')"></button>
                </div>
                <div class="content">
                    <div class="material">
                        <h2>{{activeData.title}}</h2>
                        <div class="material_image" v-if="activeData.image">
                            <div class="image" :style="{'background-image': 'url(' + activeData.image +')'}">
                            </div>
                        </div>
                        <h3 class="subtitle">{{activeData.subtitle}}</h3>
                        <p class="">{{activeData.material}}</p>
                        <div class="new_meta">
                            <span class="author">{{activeData.author}}</span>
                            <span class="date">{{getDate(activeData.date)}}</span>
                        </div>
                    </div>
                </div>
                <div class="content_fogging"></div>
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==3">
                <div class="contact_heading">
                    <button class="btn btn_weazel before" @click="changepage(1)" v-text="$ml.get('button_back')"></button>
                    <h4 class="app_name" v-text="$ml.get('weazel_addnews')"></h4>
                </div>
                <div class="add_content">
                    <div class="form-group">
                        <label v-text="$ml.get('weazel_title')"></label>
                        <input class="" type="text" v-model=newData.title>
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('weazel_subtitle')"></label>
                        <input class="" type="text" v-model=newData.subtitle>
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('weazel_text')"></label>
                        <textarea class="" type="text" v-model=newData.material></textarea>
                    </div>
                    <div class="form-group">
                        <label v-text="$ml.get('weazel_picture_link')"></label>
                        <input class="" type="text" v-model=newData.image>
                    </div>
                </div>
                <div class="text-right">
                    <button class="btn btn_weazel" @click="releaseNews()" v-text="$ml.get('weazel_publish')"></button>
                </div>
            </div>
        </transition>

    </div>
</template>

<script>

import axios from 'axios';

export default {
    name: 'App_weazel',
    components: {
        
    },
    props: {
        roles: undefined,
    },
    data() {
        return {
            isJournalist: false,
            page: 1,
            callKey: 123,
            newsData: [],
            activeData: {},
            activeIndex: null,
            newData: {},
            noNews: false,
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
        },
        changepage(page) {
            this.page = page;
        },
        readFull(index) {
            this.activeData = this.newsData[index];
            this.activeIndex = index;
            this.page = 2;
        },
        addNews() {
            this.page = 3;
            this.newData = {};
        },
        releaseNews() {
            this.newData.date = new Date();
            this.newData.author = this.$parent.playerData.name;
            this.newsData.push(this.newData);
            this.sortByDate();
            this.page = 1;
            console.log(this.newData)
            axios.post('https://eclipse_phone/AddNews', {
                title: this.newData.title,
                subtitle: this.newData.subtitle,
                material: this.newData.material,
                image: this.newData.image,
                date: this.newData.date,
                author: this.$parent.playerData.name,
            }).then(() => { return; }).catch(function () { console.log() }); 
        },
        deleteNews(index) {

            axios.post('https://eclipse_phone/DeleteNews', {
                id: this.newsData[index].id,
            }).then(() => { return; }).catch(function () { console.log() }); 

            this.newsData.splice(index, 1);
            this.page = 1;
        },
        getDate(date) {
            var item = new Date(date)
            var day = ('0'+item.getDate()).slice(-2);
            var month = ('0'+(item.getMonth() + 1)).slice(-2);
            var year = item.getFullYear()
            return day + '.'+ month + '.'+ year
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
        sortByDate() {
            this.newsData.sort(function(a, b){
                var dateA =new Date(a.date), dateB=new Date(b.date)
                return dateB-dateA
            });
        },
    },
    mounted() {
        if (this.$parent.playerData.roles == "reporter") {
            this.isJournalist = true;
        }
        this.sortByDate();
        window.addEventListener(
        "message",
        (event) => {
            if (event.data.type == "SendNews") {
                this.newsData = JSON.parse(event.data.news);
                this.noNews = false;
                if (!this.newsData) {
                    this.noNews = true;
                }
                this.page = 1;
            }
            else if(event.data.type == "SetPlayerName") {
                this.$parent.playerData.name = event.data.name;
                this.$parent.playerData.roles = event.data.job;
                this.$parent.playerPhone = event.data.phoneNumber;
                this.$parent.playerData.phone = event.data.phoneNumber;
                if(this.$parent.playerData.roles == "reporter") {
                    this.isJournalist = true;
                }
            }
        }, false)
    }
}

</script>

<style scoped>
.wrapper{
  position:absolute;
  top:50%;
  left:50%;
  transform:translate(-50%, -50%); 
  width: fit-content;
}
.circle{
  display: inline-block;
  width: 15px;
  height: 15px;
  margin: 2px;
  background-color: #fff;
  border-radius: 50%;
  animation: loading 1.5s cubic-bezier(.8, .5, .2, 1.4) infinite;
  transform-origin: bottom center;
  position: relative;
}
@keyframes loading{
  0%{
    transform: translateY(0px);
    background-color: #fff;
  }
  50%{
    transform: translateY(50px);
    background-color: transparent;
  }
  100%{
    transform: translateY(0px);
    background-color: #fff;
  }
}
.circle-1{
  animation-delay: 0.1s;
}
.circle-2{
  animation-delay: 0.2s;
}
.circle-3{
  animation-delay: 0.3s;
}
.circle-4{
  animation-delay: 0.4s;
}
.circle-5{
  animation-delay: 0.5s;
}
.circle-6{
  animation-delay: 0.6s;
}
.circle-7{
  animation-delay: 0.7s;
}
.circle-8{
  animation-delay: 0.8s;
}
</style>