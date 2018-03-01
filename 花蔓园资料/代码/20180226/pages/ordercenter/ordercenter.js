const url = require('../../utils/url.js');
// 订单中心
Page({
  data: {
    orderlist0:[],//订单
    orderlist1: [],//待支付
    orderlist2: [],//待收货
    orderlist3: [],//待评价
    tabIndex: 0,//订单中心tab  0 全部 1 待付款 2 待收货 3 待评价
    /** 
    * 页面配置 
        */  
    winWidth: 0,  
    winHeight: 0,
    text:"",//操作订单给予提示文案
    conType:"",//订单处理类型
    index:"",//处理订单下标
    pwd: "",//6位密码
    pageNum0: 1,//第几页
    pageNum1: 1,//第几页
    pageNum2: 1,//第几页
    pageNum3: 1,//第几页
    hasData0: true,//是否还有数据
    hasData1: true,//是否还有数据
    hasData2: true,//是否还有数据
    hasData3: true,//是否还有数据
    userInfo:{},
    isShow:false,//是否显示无订单
  },
  onLoad: function (res) {
    let self = this, tab = res.tab;
    wx.getStorage({
      key: "userInfo", success(res) {
        self.setData({
          userInfo:res.data
        });
        self.loadData(tab);
      }
    })
    /** 
     * 获取系统信息 
     */
    wx.getSystemInfo({
      success: function (res) {
        self.setData({
          winWidth: res.windowWidth,
          winHeight: res.windowHeight,
          tabIndex: tab
        });
      }
    });
  },
  toComment(e) {//去评论
    let self = this;
    let index = e.currentTarget.dataset.index, order = self.data["orderlist" + self.data.tabIndex][index];
    let ordersid = order.orderid;//拿orderid
    let goodsid = [];//拿订单的goodsid
    order.goodsList.forEach(function (item) {
      goodsid.push(item.goodsid);
    });
    wx.navigateTo({
      url: '../comment/comment?orderid=' + ordersid + '&goodsid=' + goodsid.toString()
    })
  },
  loadData(tabIndex){//加载数据
    let self = this, tab = tabIndex || 0;
    if (!self.data["hasData" + tabIndex]) {
      return;
    }
    wx.showLoading();//显示加载
    wx.request({
      url: url.returnUrl("getUserOrderList"),
      method: "POST",
      data: {
        userid: self.data.userInfo.userid,
        pages: self.data["pageNum" + tabIndex],
        type: tab
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        wx.hideLoading();//隐藏加载
        let hasData = true, pageNum = self.data["pageNum" + tabIndex], orderlist = pageNum == 1 ? [] : self.data["orderlist" + tabIndex];
        if (data.data.orderlist){//保证请求数据不为空
          data.data.orderlist.forEach(function (goods) {//计算每个订单商品总数
            let count = 0;
            goods.goodsList.forEach(function (good) {
              count += good.salesCount;
            });
            goods.count = count;
            orderlist.push(goods);
          });
        }
        if (data.data.orderlist.length < 20) {//没有数据未加载
          hasData = false;
        } else {
          hasData = true;
          pageNum++;
        }
        if (orderlist.length == 0){//没有数据
          orderlist ="nodata"
        }
        switch (tabIndex.toString()){
          case "0": 
            self.setData({
              orderlist0: orderlist,
              hasData0: hasData,
              pageNum0: pageNum
            });
            break;
          case "1":
            self.setData({
              orderlist1: orderlist,
              hasData1: hasData,
              pageNum1: pageNum
            });
            break;
          case "2":
            self.setData({
              orderlist2: orderlist,
              hasData2: hasData,
              pageNum2: pageNum
            });
            break;
          case "3":
            self.setData({
              orderlist3: orderlist,
              hasData3: hasData,
              pageNum3: pageNum
            });
            break;
        }
      }
    })
  },
  changeOrder(index){//切换订单状态
    let self = this, status = 3;
    switch (self.data.conType){//判断处理订单状态
      case "delete":
        status = "10";break;
      case "cancel":
        status = "11";break;
      default :
        status = "3"; break;
    }
    wx.request({
      url: url.returnUrl("updateorder"),
      method: "POST",
      data: {
        orderid: self.data["orderlist" + self.data.tabIndex][self.data.index].orderid,
        status: status
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {      
        let orderlist = self.data["orderlist" + self.data.tabIndex];  
        switch (status) {//跟换订单状态
          case "3"://确认收货
            orderlist[self.data.index].orderStatus = 3;
            switch (self.data.tabIndex.toString()){
              case "0":
                self.setData({
                  orderlist0: orderlist
                });
                break;
              case "1":
                let goods = orderlist.splice(self.data.index, 1);//在代付款列表移除该订单添加到待收货订单列表第一个
                let orderlist2 = [goods,...self.data.orderlist2];
                self.setData({
                  orderlist1: orderlist,
                  orderlist2: orderlist2
                });
                break;
            }
            break;
          case "10"://取消订单
          case "11"://删除订单
            orderlist.splice(self.data.index, 1);//移除该订单
            switch (self.data.tabIndex.toString()) {
              case "0":
                self.setData({
                  orderlist0: orderlist
                });
                break;
              case "1":
                self.setData({
                  orderlist1: orderlist
                });
                break;
              case "3":
                self.setData({
                  orderlist3: orderlist
                });
                break;
            }
            break;
        }
        self.cancel();//关闭弹框
      }
    })
  },
  refesh() {//刷新
    console.log("刷新...");
    switch (this.data.tabIndex.toString()) {
      case "0":
        this.setData({
          pageNum0: 1,
          hasData0: true
        });
        break;
      case "1":
        this.setData({
          pageNum1: 1,
          hasData1: true
        });
        break;
      case "2":
        this.setData({
          pageNum2: 1,
          hasData2: true
        });
        break;
      case "3":
        this.setData({
          pageNum3: 1,
          hasData4: true
        });
        break;
    }
    this.loadData(this.data.tabIndex);
  },
  loadMore() {//加载更多
    console.log("加载好多...");
    this.loadData(this.data.tabIndex);
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
        orderid: self.data["orderlist" + self.data.tabIndex][self.data.index].orderid,
      },
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: ({ data }) => {
        wx.hideLoading();//隐藏加载
        let info = self.data["orderlist" + self.data.tabIndex][self.data.index].orderAmount;
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
  inputPwd(e){//输入密码
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
  delPwd(){//移除密码
    let pwd = this.data.pwd;
    if (pwd.length > 0){
      pwd = pwd.substr(0, pwd.length-1);
    }
    this.setData({
      pwd: pwd
    });
  },
  userConfirm(e){//处理订单
    let conType = e.currentTarget.dataset.type, index = e.currentTarget.dataset.index;
    if (conType == "cancel"){//取消订单
      this.setData({
        text: "是否取消订单？",
        conType: conType,
        index: index
      });
    } else if (conType == "delete"){//删除订单
      this.setData({
        text: "是否删除订单？",
        conType: conType,
        index: index
      });
    } else if (conType == "pay"){
      this.setData({
        conType: conType,
        index: index
      });
    }
  },
  cancel(){//取消
    this.setData({
      conType: ""
    });
  },
  confirm(){//确认
    let conType = this.data.conType;//用户操作订单类型
    if (conType == "cancel") {//取消订单
      console.log("取消");
      this.changeOrder();
    } else if (conType == "delete") {//删除订单
      console.log("删除");
      this.changeOrder();
    }
    this.setData({
      confirm: false,
    });
  },
  imageLoadImg(e) {//图片处理
    let data = this.imageLoad(e, 180, this.data["orderlist" + this.data.tabIndex]);
    switch (this.data.tabIndex.toString()) {
      case "0":
        this.setData({
          orderlist0: data
        });
        break;
      case "1":
        this.setData({
          orderlist1: data
        });
        break;
      case "2":
        this.setData({
          orderlist2: data
        });
        break;
      case "3":
        this.setData({
          orderlist3: data
        });
        break;
    }
  },
  imageLoad(e, width, data) {
    let self = this;
    let $width = e.detail.width,    //获取图片真实宽度  
      $height = e.detail.height,
      ratio = $width / $height;   //图片的真实宽高比例  
    let viewWidth = width,           //设置图片显示宽度，  
      viewHeight = width / ratio;    //计算的高度值 
    data[e.currentTarget.dataset.index].goodsList[e.currentTarget.dataset.gindex].width = viewWidth + "rpx";
    data[e.currentTarget.dataset.index].goodsList[e.currentTarget.dataset.gindex].height = viewHeight + "rpx";
    return data;
  },
  /** 
     * 滑动切换tab 
     */
  bindChange: function (e) {
    var self = this;
    self.setData({ tabIndex: e.detail.current });
    self.loadData(e.detail.current);
  },
  /** 
   * 点击tab切换 
   */
  swichNav: function (e) {
    var self = this;
    if (this.data.tabIndex === e.target.dataset.current) {
      return false;
    } else {
      self.setData({
        tabIndex: e.target.dataset.current
      })
    }
  } 
})
