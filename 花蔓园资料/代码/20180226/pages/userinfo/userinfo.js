const url = require('../../utils/url.js');
// 个人中心
Page({
  data: {
      userInfo:{//用户信息
      },
      orderstatus:{},//用户订单各个状态统计
  },
  onLoad: function () {
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        res.data.userLevel = self.userLevel(res.data.vipLevel);
        self.setData({
          userInfo: res.data
        });
      }
    });
    wx.getStorage({
      key: "orderstatus", success(res) {
        self.setData({
          orderstatus: res.data
        });
      }
    });
  },
  userLevel(level){
    switch (level.toString()){
      case "1":
        return "银卡VIP1";
      case "2":
        return "金卡VIP2";
      default:
        return "普通用户";
    }
  },
})
