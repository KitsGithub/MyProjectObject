SFAppData = {
   	CarrierId : '88383c70-f27b-43cc-98a5-d073a67de554'
};

function showData(){
	var app = new Vue({
	    el: '#carrierDetail',
	    data:function(){
	    	return{
	    		carrierMessage:{},		//承运人基本信息	json
	    		assess_list:[]	//承运人评价列表  [object,...]
	    	}
	    },
	    created:function(){	            
		    this.ajaxgoods();
		},
	    methods: {
	        ajaxgoods: function (event) {
	        	var that = this;
	        	var requestURL = appURL + "/Cars/GetCarrierInfo";
	          $.ajax({
			        url: requestURL,
			        type: "POST",
			        dataType: "json",
			        data :SFAppData,
			        success: function (data) {
			        	// var head_src = appResourceURL + "/"+ data.Data.head_src
			        	// data.Data.goods_details.head_src = head_src
			        	// alert(data.Data.name)
			        	that.carrierMessage = data.Data;
			        	that.assess_list 	= data.Data.assess_list;
			        },
			        error: function (error) {
			        	confirm("请检查网络")
			        }
			    });
	        }
	    }
	});
};


function carrierDetail_success(){
    location.reload();
};



function carrierDetail_error(errorData){
	showErrorMessage([errorData.message])
};


showData();