const url = require('../../utils/url.js');
Page({
  data: {
    isUpdate:false,//是否修改密码
    userInfo:"",
  },
  onLoad: function (res) {
    let self = this;
    this.setData({
      isUpdate: res.isUpdate
    });
    if (res.isUpdate=="true"){//修改密码
      wx.setNavigationBarTitle({
        title: "修改密码"//页面标题为路由参数
      })
    }
    wx.getStorage({//拉取用户信息
      key: "userInfo", success(res) {
        let userInfo = res.data;
        self.setData({
          userInfo: userInfo
        });
      }
    });
  },
  formSubmit(e){//提交密码
    let self = this;
    if (!e.detail.value.oldpwd && self.data.isUpdate == "true") {//未输入
      wx.showModal({
        title: '提示',
        content: '请输入原支付密码！',
        showCancel: false
      })
      return;
    }
    if (!e.detail.value.pwd){//未输入
      wx.showModal({
        title: '提示',
        content: '请输入支付密码！',
        showCancel: false
      })
      return;
    }
    if (!e.detail.value.pwd1) {//未输入
      wx.showModal({
        title: '提示',
        content: '请输入确认支付密码！',
        showCancel: false
      })
      return;
    }
    if (e.detail.value.pwd1.length < 6 || e.detail.value.pwd.length < 6 || e.detail.value.oldpwd.length < 6) {//输入密码未达到6位
      wx.showModal({
        title: '提示',
        content: '支付密码必须是6位数字！',
        showCancel: false
      })
      return;
    }
    if (e.detail.value.pwd != e.detail.value.pwd1){//输入两次密码不一致
      wx.showModal({
        title: '提示',
        content: '两次输入密码不一致！', 
        showCancel: false
      })
      return;
    }
    let reqdata = {}, requrl = "setpaypwd";
    if (self.data.isUpdate == "false"){//新设置密码
      reqdata = {
        "userid": self.data.userInfo.userid,
        "pwd": e.detail.value.pwd
      }
    }else{//修改密码
      requrl = "updatePayPwd";
      reqdata = {
        "userid": self.data.userInfo.userid,
        "pwd": e.detail.value.oldpwd, 
        "newpwd": e.detail.value.pwd,
      }
    }
    wx.request({
      url: url.returnUrl(requrl),
      method: "POST",
      data: reqdata,
      header: {
        'content-type': "application/x-www-form-urlencoded;charset=utf-8"
      },
      success: function (res) {
        if(res.data.success){
          let userInfo = self.data.userInfo;
          userInfo.pwd = e.detail.value.pwd;
          wx.setStorage({
            key: "userInfo",
            data: userInfo
          })
          wx.showModal({//跳回个人中心
            title: '提示',
            content: '密码' + self.data.isUpdate == "false" ? '设置' : '修改' + '成功！',
            showCancel: false,
            success() {
              wx.switchTab({
                url: '../userinfo/userinfo'
              })
            },
          })
        }else{
          wx.showModal({//跳回个人中心
            title: '提示',
            content: res.data.error,
            showCancel: false
          })
        }
      }
    }) 
  },
})
