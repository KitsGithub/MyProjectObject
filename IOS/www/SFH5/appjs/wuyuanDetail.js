//
//SFAppData = {
//	UserId : 'f4fc4103-eb1b-481d-9c95-6834ebbf194d',
//	GoodsId : '5e3d3c94-66a5-4b42-9950-4d1c3b6b738e',
//	BatchId:"f1175250-c0d8-4e01-83ae-4e41dd2c40c6",  ////有就传值，没有就传空字符串
//	isCloseHistory:false,    //true关闭  false 不关闭
//};


console.log(SFAppData)
function showData (){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrier_by:[],	//承运人列表 	array
				isNumber:null,
				isLook:true,
				appUrl:appResourceURL,
				GoodsId:SFAppData.GoodsId,
				UserId:SFAppData.UserId,
				isCloseHistory:true,
				isError:false,
				isWiFi:false,
				BatchId:SFAppData.BatchId,
	    	}
	    },
	    created:function(){
	    	if(SFAppData.isCloseHistory){
	    		this.isCloseHistory=false;
	    	};
		    this.ajaxgoods();
			},
	    methods: {
	        ajaxgoods: function (event) {
		        	var that = this;
		        	var requestURL =appURL+ "/GoodsOrder/GetGoodsOrderDetails";
		          $.ajax({
				        url: requestURL,
				        type: "POST",
				        dataType: "json",
				        data :SFAppData,
				        success: function (data) {
				        	console.log(data)
				        	if(data.Code==0){
				        		that.datas 			= data.Data.goods_details;
					        	that.carrier_by 	= data.Data.carrier_by;
							    if(data.Data.carrier_by.length===0){
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
		   }
    	},
	    mounted:function(){
	    	
	    }
	});
}
	


function orderDetail_success(){
    showSuccessMessage('成功')
    location.reload();
};



function orderDetail_error(errorData){
	showErrorMessage(errorData.message)
};


//showData ()


