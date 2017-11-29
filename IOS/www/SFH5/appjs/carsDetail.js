
//  SFAppData = {
//      Guid : 'e1e8a7b9-1bff-417b-a74c-f83ca7b8bc97'
//  };
var showType;
function showData(){
	var app = new Vue({
	    el: '#sfCardetail',
	    data:function(){
	    	return{
	    		datas:{},
	    		price : '',
	    		showType:showType
	    	}	    	
	    },
	    created:function(){	            
		        this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that =this;
	          $.ajax({
			        url: "http://192.168.112.160/api/Cars/GetCarDetails",
			        type: "post",
			        dataType: "json",
			        data : SFAppData,
			        success: function (data) {
			        	var head_src = 'http://172.16.100.147/devlis' + data.Data.head_src
			        	data.Data.head_src = head_src
			        	that.datas=data.Data  
			            console.log(data.Data)
			        },
			        error: function (error) {
			            console.log("请求出错。");
			        }
			    });
	        },
	        add_order:function(){
	        	var header = '/CarsBooking/BookingCarOrder';
	        	var remark = this.datas.attention_remark;
	        	var price = this.price;
	        	datas = {
	        		OrderId : SFAppData.Guid,
	        		OrderFee : price,
	        		OrderRemark : remark
	        	}
	        	SF_ReqestManage.post(header,datas,carDetail_success,carDetail_error);
	        },
	        priceAdd:function(){
	        	var t = this.price.charAt(0); 
				    this.price = this.price.replace(/[^\d\.]/g, '');
				    this.price = this.price.replace(/^\./g, ''); 
				    this.price = this.price.replace(/\.{2,}/g, '.');
				    this.price = this.price.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
				    if (t == '-') {
				        t ='0';
				    };
	        }
	    }
	});
	

};

// showData();

function carDetail_success(){
    showSuccessMessage(['接单成功'])
    navigation.pushToVC('SFProvenanceViewController',null,null)
};



function carDetail_error(errorData){
    showErrorMessage([errorData.message])

};


