var SFAppDatas={
	 GoodsId:$.query.get("GoodsId"),
	 UserId:$.query.get("UserId"),
};
console.log(SFAppDatas);
var app = new Vue({
    el: '#orderDetail',
    data:function(){
    	return{
    		arrs:[],
    		appUrl:appResourceURL,
    		showLoading: false,
  			PageIndex:1, //第几页
  			PageSize:20, //每页显示几条
    		dayTime:'',
			isArrs:false,
			isError:false,
			isWiFi:false,
			isiconClose:false,
    	}
    },
    created:function(){		
	    this.ajaxgoods();
	    window.addEventListener('scroll', this.handleScroll);
	},
    methods: {
    	handleScroll: function () {
	　　　　//判断滚动到底部
	      if ($(window).scrollTop() >=$(document).height() - $(window).height()) {
	        this.showLoading = true;
	        this.PageIndex++;
	        this.ajaxgoods(this.PageIndex);
	      }
	    },
        ajaxgoods: function () {
        	var that = this;
        	var requestURL = appURL + "/GoodsOrder/GetGoodsOrderHistoryUser";
        	SFAppDatas.PageIndex = this.PageIndex;
        	SFAppDatas.PageSize = 	this.PageSize;
        	SFAppDatas.OrderDate =this.dayTime;
        	console.log(SFAppDatas)
          $.ajax({
		        url: requestURL,
		        type: "POST",
		        dataType: "json",
		        data :SFAppDatas,
		        success: function (data) {
		        	console.log(data)
		        	if(data.Code==0){
			        	that.showLoading = false;
			        	that.datas 			= data.Data.goods_details;
			        	data.Data.carrier_by.forEach(function(val,index){
			        		that.arrs.push(val);			    
			        	});	
			        	if(that.arrs.length===0){
			    			that.isArrs=true;
			    		}else{
			    		    that.isArrs=false;
			    		};
		        	}else{
		        		that.isError=true;
		        	};
		        	
	        		$("#orderDetail").css("opacity",'1');
		    		$("#appLoading").css("opacity",'0');
		    		$("#appLoading").remove();
		    		
		        },
		        error: function (error) {
		        	$("#orderDetail").css("opacity",'1');
		    		$("#appLoading").css("opacity",'0');
		    		$("#appLoading").remove();
		        	that.isWiFi=true;
		        }
		    });
        },
        isShow:function(item,index){   //点击显示隐藏，手风琴效果
        	
        	if(typeof item.isCheck === 'undefined'){
	                this.$set(item, 'isCheck', true);
            }else {
                item.isCheck = !item.isCheck;
            }
    	},
    	supplyDay:function(){
    		var datas = [{"time":this.dayTime,"fromId":'',"cycle":""}];
    		openDatePickerMethod(datas,this.supplyDaysuccess,null);
    	},
    	supplyDaysuccess:function(obj){
    		this.dayTime=obj.message;
    		this.isiconClose = true;
    		this.choiceDay();
    	},
    	choiceDay:function(time){ //选择日期后搜索
    		this.arrs=[];
    		this.ajaxgoods();
    	},
    	deleteDay:function(){
    		this.dayTime="";
    		this.isiconClose = false;
    		this.arrs=[];
    		this.ajaxgoods();
    	},
    	loadingagain:function(){
		   	window.location.reload();
		},
	}
});

function orderDetail_success(){
    showSuccessMessage(['成功'])
    location.reload();
};



function orderDetail_error(errorData){
	showErrorMessage([errorData.message])
};
