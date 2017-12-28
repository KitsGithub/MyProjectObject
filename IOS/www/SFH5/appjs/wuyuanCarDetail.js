// SFAppData = {
//       	UserId : 'fe563e28-3b0d-43af-9876-2125e2ad4384',
//       	CarId : '20710779-7a32-4dcf-9823-a6f5f450f6fe',
//       	BatchId:"",  //有就传值，没有就传空字符串
//       	isCloseHistory:false,//true关闭  false 不关闭
//       };



function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		booked_by:[],	//承运人列表 	array
					cars_info:[],
					isNumber:null,
					isLook:true,
					UserId:SFAppData.UserId,
					CarId:SFAppData.CarId,
					appUrl:appResourceURL,
					isCloseHistory:true,
					isError:false,
					isWiFi:false,
					BatchId:SFAppData.BatchId,
	    	}
	    },
	    created:function(){
	    	//navigation.setTitle("车源详情");
	    	if(SFAppData.isCloseHistory){
	    		this.isCloseHistory=false;
	    	};
		    this.ajaxgoods();
		},
	    methods: {
        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL =appURL+"/CarsBooking/GetCarsOrderDetails"
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	if(data.Code==0){
			        		that.datas 			= data.Data.cars_details;
				        	that.booked_by 	= data.Data.booked_by;
				        	that.cars_info = data.Data.cars_info;
						    	if(data.Data.booked_by.length===0){
						    		that.isLook=false;
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
						if(this.isNumber==index){
		    			this.isNumber=null;	
		    		}else{
		    			this.isNumber=index;
		    		}
		    },
	    	searchDay:function(){
					var that=this;
					var elementArr, newArr = [];
					for(var i= 0; i<that.arrs.length;i++){
						if(that.arrs[i].time==that.chooseDay){
							elementArr = that.arrs[i];	
						}else{
							newArr.push(that.arrs[i]);
						}
					};
			
					if(elementArr){
						newArr.unshift(elementArr);
					}
					that.arrs = newArr				
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

// showData();


