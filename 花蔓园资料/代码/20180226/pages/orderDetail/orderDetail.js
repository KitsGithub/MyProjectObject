const url = require('../../utils/url.js');
// 订单详情
Page({
  data: {
    orderlist: [],//订单
    pwd: "",//6位密码
    conType: "",//订单处理类型
    orderid: "",//订单id
    userInfo:{},
  },
  onLoad: function (res) {
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        self.setData({
          userInfo: res.data
        });
      }
    });
    self.setData({
      orderid: res.orderid
    });
    wx.request({
      url: url.returnUrl("getorder"),
      method: "POST",
      data: {
        orderid: res.orderid
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {

        self.setData({
          orderlist: data.data.orderInfo
        });
      }
    })
  },
  userConfirm(e) {//处理订单
    let conType = e.currentTarget.dataset.type
    if (conType == "cancel") {//取消订单
      this.setData({
        text: "是否取消订单？",
        conType: conType
      });
    } else if (conType == "delete") {//删除订单
      this.setData({
        text: "是否删除订单？",
        conType: conType
      });
    } else if (conType == "pay") {
      this.setData({
        conType: conType
      });
    }
  },
  payOrder(pwd) {//订单付款操作
    let self = this;
    wx.showLoading();//显示加载
    wx.request({
      url: url.returnUrl("pay"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid,
        pwd: pwd,
        orderid: self.data.orderid,
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        wx.hideLoading();//隐藏加载
        let info = this.data.orderlist.orderAmount;
        if (!data.success) {//支付失败
          switch (data.data.toString()) {
            case "1": info = "余额不足，请充值后重试！"; break;
            case "2": info = "密码错误，请重试！"; break;
            case "3": info = "扣款失败，请重试！"; break;
            case "4": info = "订单状态更新失败，请重试！"; break;
          }
        }
        self.setData({
          pwd: "",
          conType: ""
        });
        wx: wx.redirectTo({
          url: '../paymentResult/paymentResult?result=' + data.success + "&data=" + info
        })
      }
    })
  },
  inputPwd(e) {//输入密码
    let num = e.currentTarget.dataset.num, pwd = this.data.pwd;
    if (pwd.length < 6) {
      pwd = pwd + num;
      this.setData({
        pwd: pwd
      });
      if (pwd.length == 6) {//输入6位自动请求
        this.payOrder(pwd);
      }
    }
  },
  delPwd() {//移除密码
    let pwd = this.data.pwd;
    if (pwd.length > 0) {
      pwd = pwd.substr(0, pwd.length - 1);
    }
    this.setData({
      pwd: pwd
    });
  },
  cancel() {//取消
    this.setData({
      conType: ""
    });
  },
  confirm() {//确认
    let conType = this.data.conType;//用户操作订单类型
    if (conType == "cancel") {//取消订单
      console.log("取消")
    } else if (conType == "delete") {//删除订单
      console.log("删除")
    }
    this.setData({
      confirm: false,
    });
  },
  imageLoadImg(e) {//图片处理
    let data = this.imageLoad(e, 180, this.data.orderlist);
    this.setData({
      orderlist: data
    })
  },
  imageLoad(e, width, data) {
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = width,           //设置图片显示宽度，  
      viewHeight = width / ratio;    //计算的高度值 
    data.goods[e.currentTarget.dataset.gindex].width = viewWidth + "rpx";
    data.goods[e.currentTarget.dataset.gindex].height = viewHeight + "rpx";
    return data;
  },
})
