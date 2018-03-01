const url = require('../../utils/url.js');
// 商品列表
Page({
  data:{
    selTab: 1,//排序类型：1综合排序 2低价优先 3高价优先 4销量大优先 5销量小优先
    pageNum: 1,//第几页
    cardOrlist:"card",//卡片式还是列表式
    list: [],//列表数据
    hasData:true,//是否还有数据
  },
  onLoad(res){
    wx.showLoading({
      title: "加载中...",
    });//显示加载
    this.loadGoods();
  },
  toGoodDetail(e) {//查看商品详情
    let id = e.currentTarget.dataset.id;
    wx.navigateTo({
      url: '../goodDetail/goodDetail?id=' + id
    })
  },
  loadGoods(){//加载商品
    let self = this;
    if (!self.data.hasData){
      return;
    }
    wx.getStorage({
      key: "userInfo", success(res) {
        wx.request({
          url: url.returnUrl("getList"),
          method: "POST",
          data: {
            "userid": res.data.userid,
            "pages": self.data.pageNum,
            "type": self.data.selTab
          },
          header: {
            'content-type': "application/x-www-form-urlencoded;charset=utf-8"
          },
          success: ({ data }) => {
            wx.hideLoading();//隐藏加载
            let hasData = true, pageNum = self.data.pageNum;
            if(data.data.goods.length < 20){//没有数据未加载
              hasData = false;
            }else{
              hasData = true;
              pageNum++;
            }
            self.setData({
              list: data.data.goods,
              hasData: hasData,
              pageNum: pageNum
            });
          }
        })
      }
    });
  },
  refesh(){//刷新
    console.log("刷新...");
  },
  loadMore(){//加载更多
    console.log("加载好多...");
    this.loadGoods();
  },
  sel(e){//选择筛选条件
    this.setData({
      selTab: e.currentTarget.dataset.index
    });
    this.loadGoods();
  },
  change(e){//商品展示卡片  列表切换
    let type = e.currentTarget.dataset.type;
    if (type == "card"){//切换到列表式
      type = "list";
    } else {//切换到卡片式
      type = "card";
    }
    this.setData({
      cardOrlist: type
    });
  },
  imageLoadList(e) {//列表式图片加载
    let list = this.data.list;
    let data = this.imageLoad(e, 240, list);
    this.setData({
      list: data
    })
  },
  imageLoadCard(e) {//卡片式图片加载
    let list = this.data.list;
    let data = this.imageLoad(e, 340, list);
    this.setData({
      list: data
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
});