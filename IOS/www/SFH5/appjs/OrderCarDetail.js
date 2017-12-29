// SFAppData = {
//    	OrderId : '72180d86-da75-11e7-8e38-005056b66c79',
//    	UserId 	: 'fe563e28-3b0d-43af-9876-2125e2ad4384'
// };


function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		booked_by:[],	//承运人列表 	array
				cars_info:[],
				order_dates:{},
				allocation_info:[],
				UserId:SFAppData.UserId,
				CarId:SFAppData.CarId,
				appUrl:appResourceURL,
				order_no:"",
	    		isNumber:null,
	    		isError:false,
				isWiFi:false,
				isShownews:false,
				ismore:false,
	    	}
	    },
	    created:function(){	 
	    	//navigation.setTitle("车源详情");
		    this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL = appURL+"/CarsBooking/GetOrderDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	console.log(data)
						if(data.Code==0){
							that.datas= data.Data.cars_details;
				        	that.cars_info= data.Data.cars_info;
				        	that.booked_by 	= data.Data.booked_by;
				        	that.order_dates 	= data.Data.order_dates[0];
				        	that.allocation_info = data.Data.allocation_info;
				        	that.order_no=data.Data.order_no;
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
    showSuccessMessage('成功')
    location.reload();
};



function orderDetail_error(errorData){
	showErrorMessage(errorData.message)
};

// showData();

