const url = require('../../utils/url.js');
//提交订单
Page({
  data: {
    goods:[],//订单商品
    totalMoney:0,
    total:0,
    isVip:false,//用户是否是vip用户
    showShade:false,//是否展示配送方式
    delivery: [{ id: 1, name: "配送费￥10" }, { id: 1, name: "自取" }],//配送方式 1邮寄 2 自取
    userSelIndex:0,//用户选择配送方式
    orderinfo: {//订单信息
      "distributionMode": false,
      itemList:[]
    },
    userInfo:{},
    pwd: "",//6位密码
    conType: "",//订单处理类型
  },
  onLoad: function () {
    let self = this;
    wx.getStorage({
      key: "goods", success(res) {
        self.measurTotal(res.data);
        self.setData({
          goods: res.data
        });
      }
    });
    wx.getStorage({
      key: "userInfo", success(res) {
        self.setData({
          userInfo: res.data
        });
      }
    });
  },
  submitOrder(){//提交订单
    let self = this, orderinfo = this.data.orderinfo;
    // 测试用start
    orderinfo.consignee = "歪歪";
    orderinfo.consigneeAddress = "深圳市福田区";
    orderinfo.consigneePhone = "15013312345";
    // 测试用end
    if (!self.data.orderinfo.consigneeAddress){
      wx.showModal({
        title: '提示',
        content: '请选择收货地址！',
        showCancel: false
      })
      return;
    }
    wx.request({
      url: url.returnUrl("addorder"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid,
        orderinfo: JSON.stringify(orderinfo)
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        if (self.data.userInfo.amount > self.data.totalMoney){//用户余额大于支付金额
          // 调用支付密码进行支付
          this.setData({
            conType: "pay",
            orderid: data.data
          });
        }else{//余额不足跳转充值页面
          wx.showModal({
            title: '提示',
            content: '账户余额不足，请充值！',
            showCancel: true,
            success(){
              wx.navigateTo({
                url: '../recharge/recharge'
              })
            },
          })
        }
      }
    })
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
        let info = this.data.totalMoney;
        if (!data.success) {//支付失败
          switch(data.data.toString()){
            case "1": info = "余额不足，请充值后重试！";break;
            case "2": info = "密码错误，请重试！"; break;
            case "3": info = "扣款失败，请重试！"; break;
            case "4": info = "订单状态更新失败，请重试！";break;
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
      if (pwd.length == 6){//输入6位自动请求
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
  selAddress(){//选择收货地址
    let self = this;
    wx.chooseAddress({
      success(res){
        let orderinfo = this.data.orderinfo;
        orderinfo.consignee = res.userName;
        orderinfo.consigneeAddress = res.provinceName + res.cityName + res.countyName + res.detailInfo  ;
        orderinfo.consigneePhone = res.telNumber;
        self.setData({
          orderinfo: orderinfo
        })
      }, fail(res){
        console.log(res);
      }
    })
  },
  changeType(e){//选择配送方式
    this.setData({
      userSelIndex: e.currentTarget.dataset.index,
      "orderinfo.distributionMode": e.currentTarget.dataset.index == 0 ? false : true
    })
  },
  selType(){//显示配送方式
    this.setData({
      showShade: !this.data.showShade
    })
  },
  measurTotal(goods) {//计算合计金额和商品总数
    let totalMoney = 0, total = 0, orderinfo = this.data.orderinfo;
    for (let i in goods) {
      total += goods[i].count;
      totalMoney += parseFloat(goods[i].salesValue) * goods[i].count;
      orderinfo.itemList.push({//封装商品信息
        "count": goods[i].count,
        "goodsValue": goods[i].goodsValue,
        "goodsid": goods[i].goodsid,
        "salesValue": goods[i].salesValue
      });
    }
    this.setData({
      totalMoney: totalMoney.toFixed(2),
      total: total
    })
  },
  imageLoadImg(e){
    let data = this.imageLoad(e, 180, this.data.goods);
    this.setData({
      goods: data
    })
  },
  imageLoad(e, width, data) {
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = width,           //设置图片显示宽度，  
      viewHeight = width / ratio;    //计算的高度值    
    data[e.currentTarget.dataset.index].width = viewWidth + "rpx";
    data[e.currentTarget.dataset.index].height = viewHeight + "rpx";
    return data;
  },
})
