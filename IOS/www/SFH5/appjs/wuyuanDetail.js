
      SFAppData = {
      	UserId : '4e728b00-ab4b-4e79-af23-3fb05d21f07f',
      	CarId : 'ee6b2a6b-3ac6-436a-853e-267388f5f369'
      };

function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		booked_by:[],	//承运人列表 	array
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
	        	var requestURL ="http://192.168.112.44/lisapi/api/CarsBooking/GetCarsOrderDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	console.log(data)
			        	that.datas 			= data.Data.cars_details;
			        	that.booked_by 	= data.Data.booked_by;
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