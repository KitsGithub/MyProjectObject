const url = require('../../utils/url.js');
//index.js
//获取应用实例
const app = getApp()

Page({
  data: {
    bannerList:[],//banner 列表
    classify: ["精美花礼", "百合", "玫瑰","其他花材"],
    hot: [],//热销商品
    recommend: [],//推荐商品
  },
  loadBanner(){//加载banner
    let self = this;
    wx.request({
      url: url.returnUrl("banner"), //仅为示例，并非真实的接口地址
      success: ({data})=> {
        self.setData({
          bannerList: data.data.banner
        });
      }
    })
  },
  loadHotGoods(){//加载热销商品
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        console.log("热销商品", res); 
        wx.request({
          url: url.returnUrl("gethot"),
          method: "POST",
          data: {
            userid: res.data.userid,
            parentnum: "010000"
          },
          header: {
            'content-type': "application/x-www-form-urlencoded;charset=utf-8"
          },
          success: ({ data }) => {
            self.setData({
              hot:data.data.goods
            });
          }
        })
      }, fail(res){
        setTimeout(function(){
          self.loadHotGoods();
        },500);
      }
    });
  },
  loadRecommend() {//加载推荐商品
    let self = this;
    wx.getStorage({
      key: "userInfo", success(res) {
        console.log("推荐商品", res);
        wx.request({
          url: url.returnUrl("getRecommendList"),
          method: "POST",
          data: {
            userid: res.data.userid
          },
          header: {
            'content-type': "application/x-www-form-urlencoded;charset=utf-8"
          },
          success: ({ data }) => {
            self.setData({
              recommend: data.data.goods
            });
          }
        })
      }, fail(res) {
        setTimeout(function () {
          self.loadRecommend();
        }, 500);
      }
    });
  },
  toGoodDetail(e){//查看商品详情
    let id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: '../goodDetail/goodDetail?id=' + id
    }) 
  },
  lookMore(e){//查看更多
    let self = this;
    wx.navigateTo({
      url: '../flowerList/flower'
    }) 
  },
  imageLoadHot(e) {//热销图片加载
    let data = this.imageLoad(e, 200, this.data.hot);
    this.setData({
      hot: data
    })
  },
  imageLoadRecoF(e) {//热销第一个图片加载
    let recommend = this.data.recommend;
    let data = this.imageLoad(e, 690, recommend);
    this.setData({
      recommend: data
    })
  },
  imageLoadReco(e) {//热销图片加载
    let recommend = this.data.recommend;
    let data = this.imageLoad(e, 340, recommend);
    this.setData({
      recommend: data
    })
  },
  imageLoad(e,width,data){
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
  changeIndicatorDots: function (e) {
    this.setData({
      indicatorDots: !this.data.indicatorDots
    })
  },
  changeAutoplay: function (e) {
    this.setData({
      autoplay: !this.data.autoplay
    })
  },
  intervalChange: function (e) {
    this.setData({
      interval: e.detail.value
    })
  },
  durationChange: function (e) {
    this.setData({
      duration: e.detail.value
    })
  },


  //事件处理函数
  bindViewTap: function () {
    wx.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad: function () {
    let self = this;
    wx.showLoading();//显示加载
    self.loadBanner();//加载banner
    self.loadRecommend();//加载推荐商品
    self.loadHotGoods();//加载热销商品
    setTimeout(function(){
      wx.hideLoading();//隐藏加载
    },1000);
  },
  onPullDownRefresh(){//下拉刷新
    setTimeout(function(){
      console.log("sss");
      wx.stopPullDownRefresh();//结束刷新
    },1500);
  },
})
