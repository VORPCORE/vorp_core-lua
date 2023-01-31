const { createApp } = Vue;

createApp({
  data() {
    return {
      visible: true,
      initiated: false,
      iconrows: {
        token: {
          value: 0,
          show: false,
          image: './assets/icons/token.png'
        },
        money: {
          value: 0,
          decimal: '00',
          show: false,
          image: './assets/icons/money.png'
        },
        gold: {
          value: 0,
          decimal: '00',
          show: false,
          image: './assets/icons/gold.png'
        },
        id: {
          value: 0,
          show: false,
          image: './assets/icons/id.png'
        },
        lv: {
          xp: 0,
          value: 0,
          raw: 0,
          anim: 0,
          show: false,
          type: 'progress',
          image: './assets/icons/lv.png'
        },
      },
      uiposition: 'TopRight'
    };
  },
  mounted() {
    // Window Event Listeners
    window.addEventListener("message", this.onMessage);
  },
  destroyed() {
    // Remove listeners when UI is destroyed to save on memory
    window.removeEventListener("message");
  },
  computed: {
    contentstyle() {
      switch (this.uiposition) {
        case 'BottomRight':
          return 'content-bottom-right'
        case 'MiddleRight':
          return 'content-middle-right'
        case 'TopRight':
          return 'content-top-right'
        default:
          return 'content-bottom-right'
      }
    }
  },
  methods: {
    onMessage(event) {
      let item = event.data;
      if (item !== undefined && item.type === "ui") {
        switch (event.data.action) {
          case "initiate":
            this.initiated = true
            this.iconrows.money.show = !item.hidemoney
            this.iconrows.gold.show = !item.hidegold
            this.iconrows.lv.show = !item.hidelevel
            this.iconrows.id.show = !item.hideid
            this.iconrows.token.show = !item.hidetokens
            break;
          case "update":
            this.iconrows.money.value = Math.trunc(item.moneyquanty + 0.0);
            this.iconrows.money.decimal = item.moneyquanty.toFixed(2).toString().substr(-2);

            this.iconrows.gold.value = Math.trunc(item.goldquanty);
            this.iconrows.gold.decimal = item.goldquanty.toFixed(2).toString().substr(-2);

            this.iconrows.token.value =  Math.trunc(item.rolquanty);

            this.iconrows.id.value = item.serverId;

            let lv = item.xp / 1000
            this.iconrows.lv.xp = item.xp
            this.iconrows.lv.value = Math.trunc(lv)
            this.iconrows.lv.raw = lv
            this.iconrows.lv.anim = Math.floor((lv % 1)*100)
            break;
          case "setmoney":
            this.iconrows.money.value = Math.trunc(item.moneyquanty + 0.0);
            this.iconrows.money.decimal = item.moneyquanty.toFixed(2).toString().substr(-2);
            break;
          case "setgold":
            this.iconrows.gold.value = Math.trunc(item.goldquanty);
            this.iconrows.gold.decimal = item.goldquanty.toFixed(2).toString().substr(-2);
            break;
          case "setrol":
            this.iconrows.token.value =  Math.trunc(item.rolquanty);
            break;
          case "setxp":
            let lvl = item.xp / 1000
            this.iconrows.lv.xp = item.xp
            this.iconrows.lv.value = Math.trunc(lvl)
            this.iconrows.lv.raw = lvl
            this.iconrows.lv.anim = Math.floor((lv % 1)*100)
            break;
          case "hide":
            this.visible = false;
            break;
          case "show":
            this.visible = true;
            break;
          default:
            break;
        }
      }
    }
  },
}).mount("#app");
