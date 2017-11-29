
//    SFAppData = {
//    	GoodsId : 'b9fa498d-5c0e-4c42-a448-decda928c6f6',
//    	UserId 	: '1c66694d-e2a5-41e5-abd8-409afcd92a60'
//    };

function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[]	//承运人列表 	array
	    	}
	    },
	    created:function(){	            
		    this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL = appURL + "/GoodsOrder/GetGoodsOrderDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	that.datas 			= data.Data.goods_details;
			        	that.carrierList 	= data.Data.carrier_by;
			        	$("#orderDetail").css("opacity",'1');
				    	$("#appLoading").css("opacity",'0');
				    	$("#appLoading").remove();
			        },
			        error: function (error) {
			        	alert("请求出错")
			        }
			    });
	        },
	        /*点击订车操作按钮*/
	        orderCarOptionMethod:function(options,carrier){
	        	console.log(carrier.order_user)
	        	var carrierId = carrier.user_id;
	        	var order = SFAppData.GoodsId
	        	var userId = SFAppData.UserId
	        	if (options == 'B') { //货主接受 该预定车辆
	        		var header = 'GoodsOrder/ComfirmTakingOrder';	//请求域名
	        		requestData = {
						OrderId 	: order,
			        	OrderUser 	: carrierId,
			        	Acceptor 	: userId
	        		}
	        		SF_ReqestManage.post(header,requestData,orderDetail_success,orderDetail_error);
	        	} else if (options == 'D') { //货主回绝车主
	        		console.log('货主回绝车主')

	        		var header = 'GoodsOrder/RejectTakingOrder';	//请求域名
	        		requestData = {
						OrderId 	: order,
			        	OrderUser 	: carrierId,
			        	Acceptor 	: userId
	        		}
	        		SF_ReqestManage.post(header,requestData,orderDetail_success,orderDetail_error);
	        	}
	        }
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

//    showData();