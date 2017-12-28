
var SFAppDataN={
	 GoodsId:$.query.get("GoodsId"),
	 UserId:$.query.get("UserId"),
	 OrderId:$.query.get("OrderId"),
	 BatchId:$.query.get("BatchId")
}
console.log(SFAppDataN)

var HmyAppurl = appResourceURL;
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},
	    		arrs:[],	//承运人列表 	array
	    		header_src:'',
				isNumber:null,
				totalPrice:0,
				issue_by:'',
				isError:false,
				isWiFi:false,
				Goods:true,
				isHideDelPanel:true,
				isHideDelPanel2:true,
	    	}
	    },
	    created:function(){	 
	    	//navigation.setTitle("预订人详情");
	    	
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
	        	var requestURL =appURL+"/CarsBooking/GetCarsOrderBookedDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppDataN,
			        success: function (data) {
			        	console.log(data)
			        	if(data.Code==0){
			        		SF_ReqestManage.getCurrentUser(that.userType, null);
			        		if(data.Data.demand_Info.length!==0){
				        		that.datas = data.Data.user_info;
					        	that.header_src = that.HmyAppurl+data.Data.user_info.header_src;
					        	that.arrs 	= data.Data.demand_Info;
				        	}else{
				        		showErrorMessage("没有可选择车辆");
				        		// goback();
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
	        isCheck:function(item,index){   //点击显示隐藏
						if(typeof item.isCheck === 'undefined'){
                	this.$set(item, 'isCheck', true);
		            }else {
		                item.isCheck = !item.isCheck;
		            };
		            this.alltotalprice();
    		},
	    	alltotalprice:function(){
	    		//总价格计算
	    		var totalPrice = 0;
	    		this.arrs.forEach(function(val,index){
	    			if(val.isCheck&&val.status!=="A"){
	    				totalPrice+=parseFloat(val.order_fee);
	    			}
	    		});
	    		this.totalPrice = totalPrice;
	    	},//回绝
	    	refuseSeclect:function(){
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
	    		that.alltotalprice();
    			data.UserId=saveUid().UserId;
    			data.Guid=arrReFuse.toString();
    			that.sendRefuseData(data)
	    	},
	    	//接收
	    	ReceiveSeclect:function(){
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
	    		
    			data.UserId=saveUid().UserId;
    			data.Guid=arr.toString();
    			
	    		
	    		this.alltotalprice();
	    		this.sendReceiveData(data);
	    	},
		    sendReceiveData:function(data){//接受后发送给后台数据
		    	console.log(data)
		    	if(this.arrs.length!==0){
			    	$.ajax({
				        url: appURL+"/CarsBooking/TakingCarOrder",
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
		    	}else{
		    		goback();
		    	}
		    },
		    sendRefuseData:function(data){//拒绝后发送给后台数据
		    	console.log(data)
		    	$.ajax({
			        url: appURL+"/CarsBooking/RejectCarOrder",
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
				if(result.role_type==='Goods'){
					this.Goods = false;
				}
			}
	    }
	});