
      SFAppData = {
      	UserId : '07922f33-49b7-4958-b7e1-20162303ddfd',
      	CarId : '3559637c-2733-4f29-b8ea-ea87658e4c88'
      };

function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[],	//承运人列表 	array
					isNumber:null,
					appUrl:"http://172.16.100.147/devlis",
	    	}
	    },
	    created:function(){	            
		    this.ajaxgoods();
		},
	    methods: {
        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL = appURL + "/CarsBooking/GetCarsOrderDetails";
	          $.ajax({
			        url: "http://192.168.112.44/lisapi/api/CarsBooking/GetCarsOrderDetails",
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	console.log(data)
			        	that.datas 			= data.Data.cars_details;
			        	that.carrierList 	= data.Data.booked_by;
			        	console.log(that.carrierList);
			        	
			        	$("#orderDetail").css("opacity",'1');
					    	$("#appLoading").css("opacity",'0');
					    	$("#appLoading").remove();
			        },
			        error: function (error) {
			        	console.log("请求出错")
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

      showData();