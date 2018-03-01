// pages/recharge/recharge.js
const url = require('../../utils/url.js');

Page({

  /**
   * 页面的初始数据
   */
  data: {
    selected:300,//充值金额
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
  
  },
  select(e){//充值金额选择
    this.setData({
      selected: e.currentTarget.dataset.index
    });
  },  
  recharge(){//充值
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        debugger
        let prams = {
          userid: res.data.userid,
          body: self.data.selected==300?"充300元":"充500元",
          total_fee: self.data.selected ==300?1:2,//self.data.selected * 100
        }
        wx.request({//生成微信支付订单
          url: url.returnUrl("wechatPay"), //仅为示例，并非真实的接口地址
          data: prams,
          success: ({ data }) => {
            console.log(data);
            self.wxPayment(data.data);
          }
        })
      }
    })
    
  },
  wxPayment(prams){//微信支付
    let self = this;
    wx.requestPayment({
      'timeStamp': prams.timeStamp,
      'nonceStr': prams.nonceStr,
      'package': prams.package,
      'signType': 'MD5',
      'paySign': prams.paySign,
      'success': function (res) {
        wx.showToast({
          title: '成功',
          icon: 'success',
          duration: 2000
        })
        setTimeout(function(){
          wx.switchTab({//跳转到个人中心
            url: '../userinfo/userinfo'
          })
        },2000);
        
      },
      'fail': function (res) {

      },
      'complete': function (res) {//6.5.2 及之前版本中不回调fail
        console.log(res);
        if (res.errMsg == "requestPayment:cancel"){

        }
      }
    })
  },
  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
  
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
  
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
  
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
  
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  }
})