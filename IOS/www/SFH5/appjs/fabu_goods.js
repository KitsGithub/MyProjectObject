
function showData(){
	var app = new Vue({
	    el: '#sf_fb_goods',
	    data:function(){
	    	return{
	    		datas:{	    			
					issue_by:"1c66694d-e2a5-41e5-abd8-409afcd92a60",
					orderStatus:"B",
					fromProvince:"",
					fromCity:"",
					fromDistrict:"",
					fromAddress:"",
					toProvince:"",
					toCity:"",
					toDistrict:"",
					toAddress:"",
					goods_name:"",
					goods_size:"",
					goods_type:"",
					goods_weight:"",
					weight_unit:"",
					carType:"",
					carLong:"",
					car_count:"",
					carRemark:"",
					delivery_by:"",
					shipment_date:"",
					delivery_mobile:"",
					Price:""

	    		},
	    		FromProvince:"",
	    		ToProvince:"",
	    		year:new Date().getFullYear() + "年",
	    		month:(new Date().getMonth()+1) + "月",
	    		day:new Date().getDate()	
	    	}	    	
	    },
	    methods: {
	        ajaxgoods: function () {
	        	var fromArr = this.FromProvince.split("-");
	        	var toArr = this.ToProvince.split("-");
	        	var Daytime =this.year+"-"+this.month+"-"+this.day
	        	var that =this;
	        	that.datas.fromProvince=fromArr[0];
	        	that.datas.fromCity=fromArr[1];
	        	that.datas.fromDistrict=fromArr[2];
				that.datas.toProvince=toArr[0];
	        	that.datas.toCity=toArr[1];
	        	that.datas.toDistrict=toArr[2];
	        	that.datas.shipment_date=Daytime;

				if(!this.FromProvince || this.FromProvince == ""){
					alert(["请选择出发城市"])
					console.log('请选择出发城市')
					return ;
				}
				if (!this.ToProvince || this.ToProvince == "") {
					alert(["请选择到达城市"])
					return ;
				};
				if(!that.datas.carType || that.datas.carType ==""){
					alert(["请选择车辆类型"])
					return ;
				}
				if(!that.datas.shipment_date || that.datas.shipment_date == ""){
					alert(["请选择发货时间"])
					return;
				}
				if(!that.datas.goods_type || that.datas.goods_type == ""){
					showErrorMessage(["请选择货物类型"])
					return;
				}
		
				if(that.datas.weightUnit == "" && that.datas.goods_weight == ""){
					showErrorMessage(["请填写货物的总重量或者总体积"])
					return;
				}
		console.log(that.datas)
			var requestURL =  appURL + '/api/Goods/PublishGoodsSrc"'
			$.ajax({
			    url: requestURL,
			    type: "post",
			    dataType: "json",
			    data : that.datas,
			    success: function (data) {  
			        console.log(data.Data);
			    },
			    error: function (error) {
			        console.log("请求出错。");
			    }
			});
			},

	        openCityPicker : function (){
	        	alert('123')
	        	// openAdressPickerMethod()
	        }
	        

	    }
	});	
};
showData();






function sf_success(){
    // confirm(SFAppData.from_city)
    confirm(SFAppData)
};



function sf_error(){
    confirm(2)
};
