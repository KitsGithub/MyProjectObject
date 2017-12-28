var SFAppDatas={
	 GoodsId:$.query.get("GoodsId"),
	 UserId:$.query.get("UserId"),
	 BatchId:$.query.get("BatchId")
}
console.log(SFAppDatas);
var app = new Vue({
    el: '#orderDetail',
    data:function(){
    	return{
    		datas:{},		//订单数据	json
    		arrs:[],	//接单人列表 	array
    		header_src:"",
			isNumber:null,
			totalPrice:0,
			HmyAppurl:appResourceURL,
			issue_by:'',
			isError:false,
			isWiFi:false,
			Cars:true,
			isHideDelPanel:true,
			isHideDelPanel2:true,
    	}
    },
    created:function(){	 
    	//navigation.setTitle("接单人详情");
	    this.ajaxgoods();
		},
    filters:{
        // 格式化金钱
        moneyFormat:function(money){
            return '¥' + money.toFixed(2);
        }
    },
    methods: {
        ajaxgoods: function (event) {
        	var that = this;
        	var requestURL = appURL+ "/GoodsOrder/GetGoodsOrderBookedDetails";
//	        	var urls = 'http://192.168.112.157:8888/API/api/GoodsOrder/GetGoodsOrderBookedDetails'
          $.ajax({
		        url: requestURL,
		        type: "POST",
		        dataType: "json",
		        data :SFAppDatas,
		        success: function (data) {

					// navigation.setTitle("接单人详情")
		        	console.log(data)
		        	if(data.Code==0){
		        		SF_ReqestManage.getCurrentUser(that.userType, null);
		        		if(data.Data.demand_info.length!==0){
				        	that.datas 			= data.Data.user_info;
				        	that.arrs 	= data.Data.demand_info;
				        	that.issue_by = data.Data.issue_by[0].issue_by;
				        	that.header_src = that.HmyAppurl +data.Data.user_info.head_src;
				        	
				    	}else{
				    		showErrorMessage("没有可选择车辆");
				    		goback();
				    	}
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
        isCheck:function(item,index){   //点击显示隐藏
					if(typeof item.isCheck === 'undefined'){
            			this.$set(item, 'isCheck', true);
		            }else {
		                item.isCheck = !item.isCheck;
		            };
		            	this.alltotalprice();
	    },
    	alltotalprice:function(){//总价格计算
    		var totalPrice = 0;
    		this.arrs.forEach(function(val,index){
    			if(val.isCheck&&val.status!=="A"){
    				totalPrice+=parseFloat(val.order_fee);
    			}
    		});
    		this.totalPrice = totalPrice;
    	},
    	refuseSeclect:function(){//回绝
    		this.isHideDelPanel = true;
    		var data={};
    		var that = this;
    		var arr = [];
    		var arrReFuse=[];
    		that.arrs.forEach(function(val,index){
    			if(val.isCheck===undefined||val.status==="A"){
    				arr.push(that.arrs[index]);
    			}
    			if(val.isCheck&&val.status!=="A"){
    				arrReFuse.push(that.arrs[index].guid);
    			}
    		});
    		that.arrs = arr;
    		this.alltotalprice();
    		data.OrderId=saveUid().GoodsId;
			data.OrderUser=saveUid().UserId;
			data.Acceptor=that.issue_by;
			data.DemandIdList=JSON.stringify(arrReFuse);
			this.sendRefuseData(data)
    	},
    	ReceiveSeclect:function(){//接受
    		this.isHideDelPanel2 = true;
    		var data={};
    		var that =this;
    		var arr=[]; 
    		that.arrs.forEach(function(val,index){
    			if(val.isCheck){
    				val.status = "A";
    				arr.push(that.arrs[index].guid);
    			};

    		});
			data.OrderId=saveUid().GoodsId;
			data.OrderUser=saveUid().UserId;
			data.Acceptor=that.issue_by;
			data.DemandIdList=JSON.stringify(arr);
			
    		
    		this.alltotalprice();
    		this.sendReceiveData(data);
    	},
	    sendReceiveData:function(data){//接受后发送给后台数据
	    	console.log(data)
	    	if(this.arrs.length!==0){
		    	$.ajax({
			        url: appURL+"/GoodsOrder/ComfirmTakingOrder",
			        type: "POST",
			        dataType: "json",
			        data :data,
			        success: function (data) {
			        	console.log(data);
			        	if(data.Code===0){
			        		window.location.reload();
			        	}
			        	
			        },
			        error: function (error) {
			        	showErrorMessage("请求出错");
			        }
			    });
	    	}else{
	    		goback();
	    	}
	    },
	    sendRefuseData:function(data){//拒绝后发送给后台数据
	    	console.log(data)
	    	$.ajax({
		        url: appURL+"/GoodsOrder/ComfirmTakingOrder",
		        type: "POST",
		        dataType: "json",
		        data :data,
		        success: function (data) {
		        	console.log(data);
		        	if(data.Code===0){
		        		window.location.reload();
		        	}
		        },
		        error: function (error) {
		        	showErrorMessage("请求出错")
		        }
		    });
	    },
	    loadingagain:function(){
	   		window.location.reload();
		},
		userType:function(result){
			//alert(result.role_type);
			if(result.role_type==='Car'){
				this.Cars = false;
			}
		},
	}
});


   
      
