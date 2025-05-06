const { createApp } = Vue;

createApp({
	data() {
		return {
			visible: true,
			initiated: false,
			iconrows: {
				token: {
					value: 0,
					hide: true,
					image: './assets/icons/token.png'
				},
				gold: {
					value: 0,
					decimal: '00',
					hide: true,
					image: './assets/icons/gold.png'
				},
				money: {
					value: 0,
					decimal: '00',
					hide: true,
					image: './assets/icons/money.png'
				},
				pvp: {
					value: false,
					hide: true,
					toggle: false,
					image: './assets/icons/pvpoff.png',
					offimage: './assets/icons/pvpon.png'
				},
				id: {
					value: 0,
					hide: true,
					image: './assets/icons/id.png'
				},
				lv: {
					xp: 0,
					value: 0,
					raw: 0,
					anim: 0,
					hide: true,
					type: 'progress',
					image: './assets/icons/lv.png'
				}
			},
			uiposition: 'TopRight',
			uilayout: 'Column',
			uiicons: 'right',
			closeondelay: false,
			closeondelayms: 0
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
		layoutstyle() {
			switch (this.uilayout) {
				case 'Column':
					this.uiicons = 'right'
					return 'layout-column'
				case 'Row':
					this.uiicons = 'left'
					return 'layout-row'
				default:
					return 'layout-column'
			}
		},
		contentstyle() {
			switch (this.uiposition) {
				case 'BottomLeft':
					return 'content-bottom-left'
				case 'BottomRight':
					return 'content-bottom-right'
				case 'MiddleRight':
					return 'content-middle-right'
				case 'TopRight':
					return 'content-top-right'
				case 'TopMiddle':
					return 'content-top-middle'
				case 'BottomMiddle':
					return 'content-bottom-middle'
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
						this.iconrows.money.hide = item.hidemoney
						this.iconrows.gold.hide = item.hidegold
						this.iconrows.lv.hide = item.hidelevel
						this.iconrows.id.hide = item.hideid
						this.iconrows.token.hide = item.hidetokens
						this.uiposition = item.uiposition
						this.uilayout = item.uilayout
						this.closeondelay = item.closeondelay
						this.closeondelayms = item.closeondelayms
						this.iconrows.pvp.hide = item.hidepvp
						this.iconrows.pvp.toggle = item.pvp
						this.iconrows.pvp.value = item.pvp ? 'On' : 'Off'

						break;
					case "update":
						if (item && typeof item.moneyquanty === "number") {
							this.iconrows.money.value = Math.trunc(item.moneyquanty + 0.0);
							this.iconrows.money.decimal = item.moneyquanty.toFixed(2).toString().substr(-2);
						}

						if (item && typeof item.goldquanty === "number") {
							this.iconrows.gold.value = Math.trunc(item.goldquanty);
							this.iconrows.gold.decimal = item.goldquanty.toFixed(2).toString().substr(-2);
						}

						if (item && typeof item.rolquanty === "number") {
							this.iconrows.token.value = Math.trunc(item.rolquanty);
						}

						if (item && typeof item.serverId === "number") {
							this.iconrows.id.value = item.serverId;
						}

						if (item && typeof item.xp === "number") {
							let lv = item.xp / 1000
							this.iconrows.lv.xp = item.xp
							this.iconrows.lv.value = Math.trunc(lv)
							this.iconrows.lv.raw = lv
							this.iconrows.lv.anim = Math.floor((lv % 1) * 100)
						}

						break;
					case "setmoney":
						if (item && typeof item.moneyquanty === "number") {
							this.iconrows.money.value = Math.trunc(item.moneyquanty + 0.0);
							this.iconrows.money.decimal = item.moneyquanty.toFixed(2).toString().substr(-2);
						}

						break;
					case "setgold":
						if (item && typeof item.goldquanty === "number") {
							this.iconrows.gold.value = Math.trunc(item.goldquanty);
							this.iconrows.gold.decimal = item.goldquanty.toFixed(2).toString().substr(-2);
						}

						break;
					case "setrol":
						if (item && typeof item.rolquanty === "number") {
							this.iconrows.token.value = Math.trunc(item.rolquanty);
						}

						break;
					case "setpvp":
						if (item && item.pvp !== null) {
							this.iconrows.pvp.toggle = item.pvp
							this.iconrows.pvp.value = item.pvp ? 'ON' : 'OFF'
						}

						break;
					case "setxp":
						if (item && typeof item.xp === "number") {
							let lvl = item.xp / 1000
							this.iconrows.lv.xp = item.xp
							this.iconrows.lv.value = Math.trunc(lvl)
							this.iconrows.lv.raw = lvl
							this.iconrows.lv.anim = Math.floor((lv % 1) * 100)
						}

						break;
					case "hide":
						this.visible = false;
						break;
					case "show":
						this.visible = true;

						if (this.closeondelay) {
							setTimeout(() => {
								this.visible = false
								fetch(`https://${GetParentResourceName()}/close`, {
									method: 'POST'
								})
							}, this.closeondelayms);
						}
						break;
					default:
						break;
				}
			}
		}
	},
}).mount("#app");
