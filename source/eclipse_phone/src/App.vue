<template>
  <div id="app">
    <Phone :playerData=playerData v-show="showPage == 'Phone'"/>
  </div>
</template>

<script>
import Phone from "./components/phone/Phone";

export default {
  name: "App",
  components: {
    Phone
  },
  data() {
    return {
      showPage: "",
      characterList: [],
      playerData: {id: -1, phone: "000-0000", image: "https://via.placeholder.com/100x100", bgImage: undefined, name: "Vasya Testerovka", age: "0", roles: null, "bleetname":"Destroyer", "bleetimage": "https://via.placeholder.com/200", "verifyed":1},
    };
  },
  methods: {},
  computed: {},
  mounted() {
    this.$ml.change("en")
    window.addEventListener(
      "message",
      (event) => {
        if (event.data.type == "OpenLoginMenu") {
          this.showPage = "LoginPage";
        }
        else if (event.data.type == "OpenPhone") {
          this.showPage = "Phone";
        }
        else if (event.data.type == "ClosePhone") {
          this.showPage = "";
        }
        else if (event.data.type == "SetLanguage") {
          this.$ml.change(event.data.language)
        }
        else if(event.data.type == "ChangeBgImage") {
          this.playerData.bgImage = event.data.image;
        }
      },

      false
    );
  },
};
</script>

<style>
#app {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
@font-face {
  font-family: "weathericons";
  src: url("assets/font/weathericons-regular-webfont.eot");
  src: url("assets/font/weathericons-regular-webfont.eot?#iefix")
      format("embedded-opentype"),
    url("assets/font/weathericons-regular-webfont.woff2") format("woff2"),
    url("assets/font/weathericons-regular-webfont.woff") format("woff"),
    url("assets/font/weathericons-regular-webfont.ttf") format("truetype"),
    url("assets/font/weathericons-regular-webfont.svg#weather_iconsregular")
      format("svg");
  font-weight: normal;
  font-style: normal;
}
</style>
