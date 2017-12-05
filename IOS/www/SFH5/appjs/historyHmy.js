
      SFAppData = {
      	GoodsId : 'b9fa498d-5c0e-4c42-a448-decda928c6f6',
      	UserId 	: '1c66694d-e2a5-41e5-abd8-409afcd92a60'
      };

function showData(){
	var app = new Vue({
	    el: '#orderDetail',
	    data:function(){
	    	return{
	    		datas:{},		//订单数据	json
	    		carrierList:[],	//承运人列表 	array
	    		arrs:[{
	    			id:"",
					time:"2017-11-11",
					news:[{
						aaa:1111,
						bbbb:2222
					},{
						aaa:1212121,
						bbbb:2323232
					}],
					//isCheck:false
					},{
					id:"",
					time:"2017-12-11",
					news:[{
						aaa:333,
						bbbb:444
					}],
					//isCheck:false
					},{
					id:"",
					time:"2017-12-22",
					news:[{
						aaa:333,
						bbbb:'4gfhfgh44'
					},{
						aaa:5555,
						bbbb:'dsfsdfs'
					},{
						aaa:6666,
						bbbb:'44dfsfs4'
					}],
					//isCheck:false
				}],
				isNumber:null
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
			        	that.datas 			= data.Data.goods_details;
			        	that.carrierList 	= data.Data.carrier_by;
			        	$("#orderDetail").css("opacity",'1');
				    	$("#appLoading").css("opacity",'0');
				    	$("#appLoading").remove();
			        },
			        error: function (error) {
			        	alert("请求出错")
			        }
			    });
	        },
	        isShow:function(item,index){   //点击显示隐藏，手风琴效果
	        	
	        	if(typeof item.isCheck === 'undefined'){
                this.$set(item, 'isCheck', true);
            }else {
                item.isCheck = !item.isCheck;
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
			    	}
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