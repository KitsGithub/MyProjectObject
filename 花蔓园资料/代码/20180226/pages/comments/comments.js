const url = require('../../utils/url.js');
// 全部评论
Page({
  data: {
    imgUrls: [
      {url:'http://img02.tooopen.com/images/20150928/tooopen_sy_143912755726.jpg'},
      {url:'http://img06.tooopen.com/images/20160818/tooopen_sy_175866434296.jpg'},
      {url:'http://img06.tooopen.com/images/20160818/tooopen_sy_175833047715.jpg'}
    ],
    comments:[],//评论
  },
  onLoad: function (res) {
    console.log("id", res.id);
  //  let com = [];
  //  for(let i=0;i<5;i++){
  //    com.push({
  //      userName:"小梅花",
  //      userHead:"http://img3.imgtn.bdimg.com/it/u=1611505379,380489200&fm=27&gp=0.jpg",
  //      userCom:"太美了太美了太美了，跟图片一样。",
  //      spec:"1扎",//扎 或者 支
  //    });
  //  }
  //  this.setData({
  //    comments: com
  //  })
   this.loadComment(res.id);//加载商品评论
  },
  loadComment(id) {//加载商品评论
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
        let comment = data.data.comment, commentPhoto = [];
        // 转换数组图片格式
        comment.forEach(function(item,index){
          item.commentPhoto.forEach(function(url){
            commentPhoto.push({url:url})
          });
          comment[index].commentPhoto = commentPhoto;
        });
        self.setData({
          comments: data.data.comment
        });
      }
    })
  },
  imageLoadImg(e){
    let data = this.imageLoad(e, 220, this.data.imgUrls);
    this.setData({
      imgUrls: data
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
})
