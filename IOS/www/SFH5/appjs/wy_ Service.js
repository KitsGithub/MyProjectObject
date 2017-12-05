
      SFAppData = {
      	GoodsId : 'b9fa498d-5c0e-4c42-a448-decda928c6f6',
      	UserId 	: '1c66694d-e2a5-41e5-abd8-409afcd92a60'
      };

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
				islook:true
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
			        	var head_src = 'http://172.16.100.147/devlis' + data.Data.carrier_by[0].head_src;			        	
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
		    }
	});
