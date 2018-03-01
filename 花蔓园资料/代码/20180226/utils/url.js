// 所有url映射
module.exports = {
  baseUrl: "https://www.lfhuamanyuan.net/hmy",//http://www.newsilk-road.com/
  urls :  {
    "getUser": "/user/get.do",//微信ID查询会员是否存在
    "login": "/user/login.do",//获取用户openid
    "register": "/user/register.do",//会员注册接口
    "getClass": "/category/get.do",//分类获取
    "gethot": "/category/getHot.do",//热销商品
    "getList": "/goods/getList.do",//商品列表获取接口
    "getRecommendList": "/goods/getRecommendList.do",//推荐商品列表
    "getInfo": "/commodity/getInfo.do",//商品详情categoryLevelTwoscategoryLevelTwoscategoryLevelTwoscategoryLevelTwosca

    // 购物车
    "addgood": "/cart/add.do",//商品到购物车
    "shopcarlist": "/cart/getList.do",//获取购物车列表
    "updatagood": "/cart/change.do",//修改购物车商品数量
    "delgood": "/cart/delete.do",//删除购物车的指定商品

    // 订单接口
    "addorder": "/order/add.do",//订单新增
    "getorder": "/order/getOrder.do",//根据订单号查询订单信息
    "updateorder": "/order/change.do",//订单状态修改接口
    "getUserOrderList": "/order/getUserOrderList.do",//订单列表

    "setpaypwd": "/pay/setPayPwd.do",//设置支付密码
    "updatePayPwd": "/pay/updatePayPwd.do",//修改支付密码
    "wechatPay": "/pay/wxpay.do",//微信支付生成订单
    "pay": "/pay/pay.do",//支付验证

    // 评论
    "addcomment": "/comment/add.do",//新增评论
    "commentlist": "/comment/getList.do",//评论列表

    // banner
    "banner": "/banner/getList.do",//banner 列表
    // 上传
    "uploadImg": "/upload/photo.do",
  },
  returnUrl(url){
    return this.baseUrl + this.urls[url];
  }
}