var SFAppDatas={
	 UserId:$.query.get("UserId"),
	 BatchId:$.query.get("BatchId"),
	 OrderId:$.query.get("OrderId")
};
console.log(SFAppDatas);
var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		arrs:[],
	    		booker_Info:{},
	    		header_src:"",
	    		HmyAppurl:appResourceURL,
	    		UserId:SFAppDatas.UserId,
				OrderId:SFAppDatas.OrderId,
				islook:true,
				isError:false,
				isWiFi:false,
		    	}
	    },
	    created:function(){	
	    	//navigation.setTitle("预订人详情");
		    this.ajaxgoods();
			},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL =appURL+"/CarsBooking/GetOrderBookedDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppDatas,
			        success: function (data) {
			        	console.log(data);
			        	if(data.Code==0){
			        		that.datas= data.Data.user_info;
			        		that.arrs = data.Data.demand_Info;
			        		that.booker_Info = data.Data.booker_Info[0];
			        		that.header_src = that.HmyAppurl +data.Data.user_info.head_src;
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
	        loadingagain:function(){
	   			window.location.reload();
			},
	    }
	});
