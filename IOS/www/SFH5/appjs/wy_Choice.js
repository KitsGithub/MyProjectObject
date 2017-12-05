	var SFAppData = saveUid();
	var HmyAppurl = 'http://172.16.100.147/devlis';
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[],	//承运人列表 	array
	    		header_src:null,
	    		arrs:[{
					time:"2017-11-11",
					news:[{
						aaa:1111,
						bbbb:2222,
					},{
						aaa:1212121,
						bbbb:2323232,
					}],
					price:100
					},{
					time:"2017-12-11",
					news:[{
						aaa:333,
						bbbb:444,
					}],
					price:300
					},{
					time:"2017-12-22",
					news:[{
						aaa:333,
						bbbb:'4gfhfgh44',						
					},{
						aaa:5555,
						bbbb:'dsfsdfs',
					},{
						aaa:6666,
						bbbb:'44dfsfs4',
					}],
					price:200
				}],
					isNumber:null,
					totalPrice:0,
					islook:true,
					HmyAppurl:HmyAppurl,
	    	}
	    },
	    created:function(){	            
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
	        	var requestURL = appURL + "/GoodsOrder/GetGoodsOrderDetails";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	console.log(data)
			        	var head_src = that.HmyAppurl + data.Data.carrier_by[0].head_src;			        	
			        	that.datas 			= data.Data.goods_details;
			        	that.carrierList 	= data.Data.carrier_by;
			        	that.header_src = head_src;
				        $("#orderDetail").css("opacity",'1');
					    	$("#appLoading").css("opacity",'0');
					    	$("#appLoading").remove();
			        },
			        error: function (error) {
			        	$("#orderDetail").css("opacity",'1');
					    	$("#appLoading").css("opacity",'0');
					    	$("#appLoading").remove();
			        	console.log("请求出错")
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
		    			if(val.isCheck){
		    				totalPrice+=val.price
		    			}
		    		});
		    		this.totalPrice = totalPrice;
		    	},
		    	//回绝
		    	refuseSeclect:function(){
		    		var that = this;
		    		var arr = [];
		    		that.arrs.forEach(function(val,index){
		    			if(val.isCheck===undefined){
		    				arr.push(that.arrs[index])
		    			}
		    		});
		    		that.arrs = arr;
		    	},
		    	//接收
		    	ReceiveSeclect:function(){
		    		var that =this
		    		this.arrs.forEach(function(val,index){
		    			that.$set(val, 'islook', true);
		    			if(!val.isCheck){
		    				val.islook = false;
		    			}
		    		});
		    	},
		    
		    }
	});


   
      
