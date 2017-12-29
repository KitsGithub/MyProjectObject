
//    SFAppData = {
//       	OrderId : '23510e1a-e536-11e7-8e38-005056b66c79',
//       	UserId 	: 'fe563e28-3b0d-43af-9876-2125e2ad4384'
//    };


function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[],	//承运人列表 	array
	    		order_dates:{},
	    		allocation_info:[],
	    		isNumber:null,
				appUrl:appResourceURL,
				isError:false,
				isWiFi:false,
				isShownews:false,
				ismore:false,
	    	}
	    },
	    created:function(){	
	    	//navigation.setTitle("货源详情");
		    this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL = appURL+"/Order/GetGoodsOrderDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	console.log(data)
			        	if(data.Code==0){
			         		that.datas 			= data.Data.goods_details;
				        	that.carrierList 	= data.Data.carrier_by;
				        	that.order_dates 	= data.Data.order_dates;
				        	that.allocation_info = data.Data.allocation_info;
				        	var num=0;
				        	for (var i = 0; i < data.Data.allocation_info.length; i++) {
				        		num+=data.Data.allocation_info[i].driver_info.length;
				        	};
				        	if(num>=3){
				        		that.ismore = true;
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
	        carrierMessage : function (carrier_id) {
	        	//跳转到承运人详情
	        	console.log(11)
	        	navigation.pushToVC("SFCarrierMessageController",null,null);
	        },
	        isShow:function(item,index){   //点击显示隐藏，手风琴效果
						if(this.isNumber==index){
		    			this.isNumber=null;	
		    		}else{
		    			this.isNumber=index;
		    		}
		    },
		    loadingagain:function(){
	   			window.location.reload();
			},
	    }
	    
	});
};


function orderDetail_success(){
    showSuccessMessage(['成功'])
    location.reload();
};



function orderDetail_error(errorData){
	showErrorMessage([errorData.message])
};
//
//    showData();

