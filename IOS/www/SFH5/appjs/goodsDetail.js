
 //SFAppData={Guid:"0d5c0302-582a-48b7-be16-af7f1241be77"};

function showData(){
	var app = new Vue({
	    el: '#sfGoodsdetail',
	    data:function(){
	    	return{
	    		datas:{},
	    		price : ''
	    	}	    	
	    },
	    created:function(){	            
		        this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that =this;
	        	var requestURL = appURL + '/Goods/GetGoodsDetails';
	          $.ajax({
			        url 		: requestURL,
			        type 		: "post",
			        dataType 	: "json",
			        data 		: SFAppData,
			        success: function (data) {
			        	var head_src = 'http://172.16.100.147/devlis' + data.Data.head_src
			        	data.Data.head_src = head_src
			        	that.datas=data.Data
			            console.log(data.Data.car_long)
			        },
			        error: function (error) {
			            console.log("请求出错。");
			        }
			    });
	        },
	        add_order:function(){
	        	console.log(11)
	        	var header = '/GoodsOrder/AddGoodsOrder';
	        	var remark = this.datas.attention_remark ? this.datas.attention_remark : "暂无备注";
	        	var price = this.price;
	        	datas = {
	        		OrderId : SFAppData.Guid,
	        		OrderFee : price,
	        		OrderRemark : remark
	        	}
	        	SF_ReqestManage.post(header,datas,goodsDetail_success,goodsDetail_error);
	        }
	    }
	});
};

//showData();

function goodsDetail_success(){
    showSuccessMessage(['接单成功'])
    navigation.pushToVC('SFProvenanceViewController',null,null)
};



function goodsDetail_error(errorData){
	showErrorMessage([errorData.message])
};


