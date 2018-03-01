const url = require('../../utils/url.js');
// 商品详情
Page({
  data: {
    imgUrls: [],
    bannerIndex:0,//当前banner index
    goodDetail:{},//商品详情
    sales:0,//产品销量
    comments:[],//评论
    shopcar:true,//购物车有商品
    selSpecIndex:0,//选择规格index
    isBuyOrAdd:"",//是购买还是加入购物车 BUY 购买  ADD 加入购物车
    userInfo:{},//用户信息
    count:1,//购买数量
  },
  onLoad: function (res) {
    let self = this;
    self.loadDetail(res.id);//加载详情
    self.loadComment(res.id);//加载商品评论
    wx.getStorage({
      key: "userInfo", success(res) {
        self.setData({
          userInfo: res.data
        });
      }
    });
  },
  loadComment(id){//加载商品评论
    let self = this;
    wx.request({
      url: url.returnUrl("commentlist"),
      method: "POST",
      data: {
        categoryid: id
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        self.setData({
          comments: data.data.comment
        });
      }
    })
  },
  loadDetail(id){//加载详情
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        wx.request({
          url: url.returnUrl("getInfo"),
          method: "POST",
          data: {
            userid: res.data.userid,
            categoryid: id
          },
          header: {
            'content-type': "application/x-www-form-urlencoded;charset=utf-8"
          },
          success: ({ data }) => {
            let commodityPhoto = data.data.commodityInfo.commodityPhoto||[];//商品图
            let imgUrls = [];
            commodityPhoto.forEach(function(item){
              imgUrls.push({
                url:item
              });
            })
            data.data.commodityInfo.commodityInfo.forEach(function (url,index){
              data.data.commodityInfo.commodityInfo[index]={url:url}
            });
            let sales = 0;
            data.data.commodityInfo.goods.forEach(function(item){
              sales += item.salesCount;
            });
            self.setData({
              goodDetail: data.data.commodityInfo,
              imgUrls: imgUrls,
              sales: sales
            });
          }
        })
      }
    });
  },
  confirmData(){//提交数据
    let self = this;
    if (this.data.isBuyOrAdd =="BUY"){//立即购买
      let goods = [self.data.goodDetail.goods[self.data.selSpecIndex]];
      goods[0].count = self.data.count;
      goods[0].commodityName = self.data.goodDetail.commodityName;
      wx.setStorage({//加入缓存，提交订单页面好拿去数据
        key: "goods",
        data: goods
      })
      wx: wx.navigateTo({
        url: '../firmorder/firmorder'
      })
    }else{//加入购物车
      wx.request({
        url: url.returnUrl("addgood"),
        method: "POST",
        data: {
          userid: self.data.userInfo.userid,
          goodsid: self.data.goodDetail.goods[self.data.selSpecIndex].goodsid,
          count: self.data.count
        },
        header: {
          'content-type': "application/x-www-form-urlencoded;charset=utf-8"
        },
        success: ({ data }) => {
          if (data.success){
            wx.showToast({
              title: '成功',
              icon: 'success',
              duration: 2000
            })
            self.close();
          }
        }
      })
    }
  },
  handle(e){//操作 购买还是加入购物车
    this.setData({
      isBuyOrAdd: e.currentTarget.dataset.type
    })
  },
  bindMinus(e) {//减
    let count = this.data.count;
    count > 1 ? count-- : 1;//大于1给减少
    this.setData({
      count: count
    })
  },
  bindPlus(e) {//加
    let count = this.data.count;
    count++;
    this.setData({
      count: count
    })
  },
  close(){//关闭弹出购买层
    this.setData({
      isBuyOrAdd: ""
    })
  },
  changeSpec(e){//选择购买规格
    this.setData({
      selSpecIndex: e.currentTarget.dataset.index
    })
  },
  change(e){//banner切换调用
    this.setData({
      bannerIndex: e.detail.current
    })
  },
  imageLoadGood(e){//购买是产品图，根据选择规格变化图
    let data = this.imageLoad(e, 300, this.data.spec);
    this.setData({
      spec: data
    })
  },
  imageLoadTop(e){//顶部产品图
    let data = this.imageLoadPX(e, wx.getSystemInfoSync().windowWidth, this.data.imgUrls);
    this.setData({
      imgUrls: data
    })
  },
  imageLoadDetail(e) {//底部详情产品图
    let data = this.imageLoadPX(e, wx.getSystemInfoSync().windowWidth, this.data.goodDetail.commodityInfo);
    this.setData({
      "goodDetail.commodityInfo": data
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
  imageLoadPX(e, width, data) {
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = width,           //设置图片显示宽度，  
      viewHeight = width / ratio;    //计算的高度值    
    data[e.currentTarget.dataset.index].width = viewWidth + "px";
    data[e.currentTarget.dataset.index].height = viewHeight + "px";
    return data;
  },
})
