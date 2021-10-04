<template>
    <div class="app_fullscreen content_page app_calculator">
        <transition name="transition_03">
            <div class="content_page_l2 page_1" v-show="page==1">
                <button class="app_close" @click="closeApp"></button>
                <div id="calculator">
                    <div class="calculator-logs">
                        <span v-for="log in logs" v-bind:key="log">{{ log }}</span>
                    </div>

                    <input type="string" class="calculator-input" v-model="value" @keyup.enter="getResult()">

                    <div class="calculator-row">
                        <div class="calculator-col">
                        <button class="calculator-btn gray action" @click="clear()">C</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn gray action" @click="del()">del</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn gray action" @click="addExpresion('%')">%</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn accent action" @click="addExpresion('/')">/</button>
                        </div>
                    </div>
                    <div class="calculator-row">
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(7)">7</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(8)">8</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(9)">9</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn accent action" @click="addExpresion('*')">X</button>
                        </div>
                    </div>
                    <div class="calculator-row">
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(4)">4</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(5)">5</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(6)">6</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn accent action" @click="addExpresion('-')">-</button>
                        </div>
                    </div>
                    <div class="calculator-row">
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(1)">1</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(2)">2</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn" @click="addExpresion(3)">3</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn accent action" @click="addExpresion('+')">+</button>
                        </div>
                    </div>
                    <div class="calculator-row">
                        <div class="calculator-col wide">
                        <button class="calculator-btn" @click="addExpresion(0)">0</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn action" @click="addExpresion('.')">.</button>
                        </div>
                        <div class="calculator-col">
                        <button class="calculator-btn accent action" @click="getResult()">=</button>
                        </div>
                    </div>
                </div>
                <h5 class="error_text" v-show="errortext">Строка должна начинаться с цифры</h5>
            </div>
        </transition>

    </div>
</template>

<script>
export default {
    name: 'App_game_snake',
    components: {
        
    },
    data() {
        return {
            value: 0,
            logs:  [],
            page: 1,
            errortext: false,
        }
    },
    methods: {
        closeApp() {
            this.$parent.page = 2;
            this.value = 0;
            this.logs = [];
        },
        changepage(page) {
            this.page = page;
        },
        addExpresion(e) {
            this.errortext = false;
            if (Number.isInteger(this.value))
                this.value = ''; 
            this.value += e;
        },
        getResult() {
            let log = this.value;
            var test = log.substring(0,1);
            if (/^[0-9]$/.test(test)) {
              this.value = eval(this.value);
              this.logs.push( log + `=${this.value}` );
              this.errortext = false;
            } else {
              this.errortext = true;
            }
            
        },
        clear() {
            this.value = 0;
        },
        del() {
            this.value = this.value.slice(0, -1);
        }
    },
}
</script>

<style scoped>

#calculator {
  width: 100%;
  margin: 0 auto;
  display: flex;
  padding: 0;
  flex-direction: column;
}
#calculator .calculator-logs {
  height: 80px;
  display: flex;
  position: relative;
  overflow: hidden;
  align-items: flex-end;
  flex-direction: column;
  justify-content: flex-end;
}
#calculator .calculator-logs span {
  color: #d4d4d2;
  opacity: 0.75;
  display: block;
  font-size: 0.8rem;
  text-align: right;
  margin-top: 0.4rem;
  line-height: 1;
  font-weight: lighter;
}
#calculator .calculator-input {
  color: #d4d4d2;
  width: 100%;
  border: none;
  padding: 0.8rem;
  display: block;
  font-size: 2.4rem;
  background: none;
  text-align: right;
  font-weight: lighter;
}
#calculator .calculator-input:focus, #calculator .calculator-input:active {
  outline: none;
}
#calculator .calculator-row {
  display: flex;
  padding: 0;
  justify-content: space-around;
}
#calculator .calculator-row .calculator-col {
  flex: 1;
  padding: 4px;
}
#calculator .calculator-row .calculator-col.wide {
  flex: 2;
}
#calculator .calculator-row .calculator-col.wide .calculator-btn {
    width: 100%;
    border-radius: 30px;
}
#calculator .calculator-btn {
  width: 54px;
  height: 54px;
  color: #d4d4d2;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  padding: 0.6rem;
  outline: none;
  font-size: 1.6rem;
  transition: all 0.3s ease-in-out;
  font-weight: 200;
  justify-content: center;
  background-color: #333333;
}
#calculator .calculator-btn.accent {
  background-color: #fe9505;
  color: #fff;
}
#calculator .calculator-btn.gray {
  background-color: #a5a5a5;
}
#calculator .calculator-btn:active {
  background-color: #7c7c7c;
}
</style>