<template>
    <div class="app_fullscreen content_page app_youtube">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <button class="app_close black" @click="closeApp"></button>
                <div class="rotate">
                    <div class="description">
                        <input v-model="link" type="text" :placeholder="$ml.get('youtube_title')">
                        <button class="btn" @click="playVideo" v-text="$ml.get('youtube_run')">Запустить</button>
                    </div>
                    
                </div>
                
            </div>
        </transition>

        <transition name="transition_03">
            <div class="content_page_l2 page_2" v-show="page==2">
                <button class="app_close" @click="stopVideo"></button>
                <div class="rotate">
                    <youtube
                        :video-id="parsedLink"
                        ref="youtube"
                        width="100%"
                        height="100%"   
                    ></youtube>
                </div>
                
            </div>
        </transition>


    </div>
</template>

<script>

export default {
    name: 'App_youtube',
    components: {
        
    },
    props: {
    },
    data() {
        return {
            page: 1,
            link: '',
            parsedLink: '',
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.$parent.whiteColor = true;
            this.$parent.rotatePhone = false;
        },
        changepage(page) {
            this.page = page;
        },
        playVideo() {
            if (this.link) {
                this.page = 2;
                this.parsedLink = this.$youtube.getIdFromUrl(this.link);
                this.player.playVideo()
            }

        },
        stopVideo() {
            this.page = 1;
            this.link = '';
            this.player.stopVideo()
        },
    },
    computed: {
        player() {
            return this.$refs.youtube.player
        },
        
    }
}
</script>