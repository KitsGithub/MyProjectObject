const url = require('../../utils/url.js');
// 商品进入 购物车
Page({
  data: {
    isHandle: false,//是否在操作
    list: [],//购物车数据
    selGoodsIndex:[],//选中商品index
    totalMoney:"0.00",//合计金额
    allSel: false,//是否全选
    userInfo: {},//用户信息
  },
  onLoad: function () {
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        self.setData({
          userInfo: res.data
        });
        self.loadCar();
      }
    });
  },
  account(){//结算
    console.log("结算");
  },
  updateCar(index) {//修改购物车商品数量
    let self = this;
    wx.request({
      url: url.returnUrl("updatagood"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid,
        goodsid: self.data.list[index].goodsid,
        count: self.data.list[index].count
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
      }
    })
  },
  delAll(){//删除选中商品
    console.log("删除");
    debugger
    let self = this, selGoodsIndex = this.data.selGoodsIndex.sort().reverse();
    if (selGoodsIndex.length == 0) {
      return;
    }
    selGoodsIndex.forEach(function (i) {
      self.delCar(self.data.list[i].goodsid, i);
    });
  },
  delCar(goodsid, index) {//删除购物车商品数量
    let self = this;
    wx.request({
      url: url.returnUrl("delgood"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid,
        goodsid: goodsid
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        let list = this.data.list;//拿取购物车列表
        list.splice(index, 1);//移除数据
        self.setData({
          list: list
        });
      }
    })
  },
  loadCar() {//加载购物车商品
    let self = this;
    wx.request({
      url: url.returnUrl("shopcarlist"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        self.setData({
          list: data.data.cart
        });
      }
    })
  },
  measurTotal(){//计算合计金额
    let totalMoney = 0,
      list = this.data.list;
    for (let i in list) {
      if (list[i].selected) {//是选中则计算金额
        totalMoney += parseFloat(list[i].price) * list[i].count;
      }
    }
    this.setData({
      totalMoney: totalMoney.toFixed(2)
    })
  },
  selAll(){//全选
    let list = this.data.list, selGoodsIndex = [];
    for (let i in list){
      list[i].selected = !this.data.allSel;
      if (!this.data.allSel) {//为true则为全选
        selGoodsIndex.push(i);
      }
    }
    this.measurTotal();//计算合计金额
    this.setData({
      allSel: !this.data.allSel,
      list:list,
      selGoodsIndex: selGoodsIndex
    })
  },
  select(e){//选择
    let index = e.currentTarget.dataset.index,
      list = this.data.list, selGoodsIndex = this.data.selGoodsIndex, allSel = false;
    list[index].selected = list[index].selected ? !list[index].selected : true;
    if (list[index].selected){//加入选中数组
      selGoodsIndex.push(index);
    }else{
      let i = selGoodsIndex.indexOf(index);
      selGoodsIndex.splice(i,1);//从选中数组中移除
    }
    if (selGoodsIndex.length == list.length){//选中数组长度等于购物车商品长度
      allSel = true;
    }
    this.measurTotal();//计算合计金额
    this.setData({
      list: list,
      selGoodsIndex: selGoodsIndex,
      allSel: allSel
    })
  },
  bindMinus(e){//减
    let index = e.currentTarget.dataset.index;
    let list = this.data.list;
    list[index].count > 1 ? list[index].count-- : 1;//大于1给减少
    this.measurTotal();//计算合计金额
    this.updateCar(index);//修改数量
    this.setData({
      list: list
    })
  },
  bindPlus(e){//加
    let index = e.currentTarget.dataset.index;
    let list = this.data.list;
    list[index].count++;
    this.measurTotal();//计算合计金额
    this.updateCar(index);//修改数量
    this.setData({
      list: list
    })
  },
  delGood(e){//删除
    this.delCar(e.currentTarget.dataset.id, e.currentTarget.dataset.index);
  },
  change(){//切换编辑状态
    this.setData({
      isHandle: !this.data.isHandle
    })
  },
  imageLoad(e) {//图片加载
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = 180,           //设置图片显示宽度，  
      viewHeight = 180 / ratio;    //计算的高度值      
    let list = self.data.list;
    list[e.currentTarget.dataset.index].width = viewWidth + "rpx";
    list[e.currentTarget.dataset.index].height = viewHeight + "rpx";
    self.setData({
      list: list
    })
  },
})
