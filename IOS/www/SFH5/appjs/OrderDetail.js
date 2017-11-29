// SFAppData = {
//    	GoodsId : '58bd4210-10e0-40c6-b8e7-87235be89e8a',
//    	UserId 	: '968c6b04-406c-42e7-a194-66c8a3c18a45'
// };

function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[],	//承运人列表 	array
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
			        	console.log(data)
			        	if (data.Data.goods_details.head_src != ""||data.Data.goods_details.head_src !="undefined") {
			        		var head_src = appResourceURL + "/"+ data.Data.head_src
			        		data.Data.goods_details.head_src = head_src
			        	}
			        	that.datas 			= data.Data.goods_details;
			        	that.carrierList 	= data.Data.carrier_by;
			        	$("#orderDetail").css("opacity",'1');
			        	$("#appLoading").css("opacity",'0');
			        	$("#appLoading").remove();
			        },
			        error: function (error) {
			        	confirm("请检查网络")
			        }
			    });
	        },
	        carrierMessage : function (carrier_id) {
	        	//跳转到承运人详情
	        	console.log(11)
	        	navigation.pushToVC("SFCarrierMessageController",null,null);
	        }
	    },
	    mounted:function(){
	    	this.isShow=false;	
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