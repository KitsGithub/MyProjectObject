
Page({
  data: {
    result:true,// true 支付成功 false 支付失败
    data:"账户余额不足",
  },
  onLoad: function (res) {
    this.setData({
      result: res.result,
      data: res.data
    });
  },
})
