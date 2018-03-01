const url = require('../../utils/url.js');

Page({
  data: {
    classify: ["精美花礼", "百合", "玫瑰", "康乃馨", "洋桔梗", "绣球", "其他主花", "配花", "配叶"],
    sel:0,//默认选中分类
    goods:[],//图片
  },
  onLoad: function () {
    this.loadClassify();//加载花分类
  },
  loadClassify(){// 加载花分类
    let self = this;
    wx.request({
      url: url.returnUrl("getClass"), //仅为示例，并非真实的接口地址
      success: ({ data }) => {
        self.setData({
          classify: data.data.category
        });
      }
    })
  },
  lookMore(e) {//查看更多
    let cnum = e.currentTarget.dataset.cnum
    wx.navigateTo({
      url: '../flowerList/flower?cnum=' + cnum
    })
  },
  selClassify(e){//选择分类
    this.setData({
      sel: e.currentTarget.dataset.index
    });
  },
  imageLoad(e){//图片加载
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = 182,           //设置图片显示宽度，  
      viewHeight = 182 / ratio;    //计算的高度值      
    let classify = self.data.classify;
    classify[self.data.sel].categoryLevelTwos[e.currentTarget.dataset.index].width = viewWidth + "rpx";
    classify[self.data.sel].categoryLevelTwos[e.currentTarget.dataset.index].height = viewHeight + "rpx";

    self.setData({
      classify: classify
    })
  },
})
