const url = require('./utils/url.js');
//app.js
App({
  onLaunch: function () {
    let self = this;
    // 获取用户信息
    wx.getSetting({
      success: res => {
        if (res.authSetting["scope.userInfo"]==false){
          wx.openSetting({
            success: (res) => {
              self.getUserInfo();
            }
          })
        }else{
          self.getUserInfo();
        }
        
      }
    })
  },
  getUserInfo(){//微信获取用户信息
    let self = this;
    wx.getUserInfo({//不需要encryptedData, iv 等敏感信息
      success: res => {

        // 可以将 res 发送给后台解码出 unionId
        this.globalData.userInfo = res.userInfo
        // 登录
        wx.login({
          success: res => {
            let self = this;
            // 发送 res.code 到后台换取 openId, sessionKey, unionId
            wx.request({
              url: url.returnUrl("login"),
              method: "POST",
              data: {
                "js_code": res.code
              },
              header: {
                'content-type': "application/x-www-form-urlencoded;charset=utf-8"
              },
              success: function (res) {
                self.loadUserInfo(res.data.openid);
              }
            })
          }
        })
        // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
        // 所以此处加入 callback 以防止这种情况
        if (this.userInfoReadyCallback) {
          this.userInfoReadyCallback(res)
        }
      },fail(res){
        wx.navigateBack({
          delta: 1
        }) 
      }
    })
  },
  loadUserInfo(wechatid){//获取用户信息，未注册给予注册
    let self = this;
    wx.request({
      url: url.returnUrl("getUser"),
      method: "POST",
      data: {
        "wechatid": wechatid
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: function (res) {
        if(!res.data.data){//data 为 null 未注册
          self.registerUser(wechatid);
        }else{
          wx.setStorage({ key:"userInfo",data:res.data.data.user});
          // wx.setStorage({ key: "orderstatus", data: res.data.orderstatus});
        }
      }
    }) 
  },
  registerUser(wechatid){
    let self = this;
    wx.request({
      url: url.returnUrl("register"),
      method: "POST",
      data: {
        "wechatid": wechatid,
        "wechatname": self.globalData.userInfo.nickName,
        "head": self.globalData.userInfo.avatarUrl
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: function (res) {
        self.loadUserInfo(wechatid);//重新拿用户信息
      }
    }) 
  },
  globalData: {
    userInfo: null
  }
})