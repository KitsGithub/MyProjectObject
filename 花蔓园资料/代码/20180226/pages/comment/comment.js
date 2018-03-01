const url = require('../../utils/url.js');
// 评论
Page({
  data: {
    orderid: "",//
    goodsids: [],//订单内商品id s
    commentlist: {
      "comment": "",
      "commentPhoto": [],
      "goodsid": "",
      "head": "",
      "wechatName": ""
    },
  },
  onLoad: function (res) {
    let self = this;
    this.setData({
      goodsids: res.goodsid.split(",")
    });
    wx.getStorage({
      key: "userInfo", success(res) {
        let commentlist = {
          head: res.data.head,
          wechatName: res.data.wechatname,
          commentPhoto: []
        }
        self.setData({
          commentlist: commentlist
        });
      }
    })
  },
  formSubmit(e) {//提交
    let self = this, commentlist = this.data.commentlist;
    if (!e.detail.value.textarea) {//评论内容为空
      wx.showModal({
        title: '提示',
        content: '请输入评论内容！',
        showCancel: false
      })
      return;
    }
    commentlist.comment = e.detail.value.textarea;//评论内容
    let goodsids = self.data.goodsids;
    goodsids.forEach(function (goodsid) {//评论是商品级别，不是订单级别，所以根据不同的商品进行提交评论
      commentlist.goodsid = goodsid;
      console.log(commentlist);
      // wx.request({
      //   url: url.returnUrl("addcomment"),
      //   method: "POST",
      //   data: commentlist,
      //   header: {
      //     'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      //   },
      //   success: function (res) {
      //     wx.showToast({
      //       title: '成功',
      //       icon: 'success',
      //       duration: 2000,
      //       success(){
      //         wx.switchTab({//跳转个人中心
      //           url: '../userinfo/userinfo'
      //         })
      //       }
      //     })

      //   }
      // }) 
    });

  },
  uploadImg() {//上传图片
    let self = this;
    wx.chooseImage({
      count: 3,
      success: function (res) {
        var tempFilePaths = res.tempFilePaths
        tempFilePaths.forEach(function (file) {
          debugger
          wx.uploadFile({
            url: url.returnUrl("uploadImg"), //仅为示例，非真实的接口地址
            filePath: file,
            name: 'image',
            header: {
              'content-type': "multipart/form-data"
            },
            success: function (res) {
              let data = res.data, commentlist = self.data.commentlist
              commentlist.commentPhoto.push(JSON.parse(data).data.filepath);
              console.log("图片地址", JSON.parse(data).data.filepath);
              self.setData({
                commentlist: commentlist
              });
            }
          })
        });

      }
    })
  },
})
