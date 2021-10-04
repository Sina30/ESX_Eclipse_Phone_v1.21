import Vue from 'vue'
import App from './App.vue'
import './ml'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import styles from './assets/css/style.css';
import fonts from './assets/css/fonts.css';
import weathericons from './assets/css/weather-icons.css';

import VueDraggable from 'vue-draggable'
import VueYoutube from 'vue-youtube'

Vue.use(BootstrapVue)
Vue.use(IconsPlugin)
Vue.use(styles)
Vue.use(fonts)
Vue.use(weathericons)
Vue.use(VueDraggable)
Vue.use(VueYoutube)

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
