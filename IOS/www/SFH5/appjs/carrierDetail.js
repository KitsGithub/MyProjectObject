var SFAppDatas={
	 UserId:$.query.get("UserId"),
	 OrderId:$.query.get("OrderId")
};
console.log(SFAppDatas);
var app = new Vue({
    el: '#orderDetail',
    data:function(){
    	return{
    		datas:{},		//订单数据	json
			arrs:[],
			header_src:"",
			isError:false,
			isWiFi:false,
    	}
    },
    created:function(){	
    	// navigation.setTitle("接单人信息");
	    this.ajaxgoods();
	},
    methods: {
        ajaxgoods: function (event) {
        	var that = this;
        	var requestURL = appURL + "/Order/GetUserAssess";
          $.ajax({
		        url: requestURL,
		        type: "POST",
		        dataType: "json",
		        data :SFAppDatas,
		        success: function (data) {
		        	console.log(data)
		        	if(data.Code==0){
		        		that.datas 			= data.Data.user_info;
	        			that.arrs 	= data.Data.assess_Info;
	        			that.header_src = that.HmyAppurl +data.Data.user_info.head_src;	
		        	}else{
		        		that.isError=true;	
		        	}
		        	
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



function carrierDetail_success(){
    location.reload();
};



function carrierDetail_error(errorData){
	showErrorMessage([errorData.message])
};


//showData();