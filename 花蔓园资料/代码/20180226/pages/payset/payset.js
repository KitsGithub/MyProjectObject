
Page({
  data: {
    isUpdate: true,//是否设置过密码
  },
  onLoad: function () {
  //  获取是否设置过密码
    let self = this;
    wx.getStorage({key:"userInfo",success(res){
      let isUpdate = res.data.pwd?true:false;
      self.setData({
        isUpdate: isUpdate
      });
    }});
    
  }
})
