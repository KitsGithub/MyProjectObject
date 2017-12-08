//原生调用暂存的方法
function rendCardetail(orderId){
		justCar();		    
}

//请求原生地址插件
function saveaddress(cls,ids){
	var fromID=[{fromId:ids}];
	cls.parent("p").click(function(){
		$(this).children(".sf_develop").addClass("active");
		openAdressPickerMethod(fromID,successFn,failFn)
	});
}
saveaddress($("#sf_fromAdd"),"sf_fromAdd");
saveaddress($("#toAddress"),"toAddress");

//请求原生选择货源的各种条件插件
function saveOtherPicker(cls,ids,title,data){
	var fromID=[{fromId:ids,title:title,data:data}];
	cls.parent("p").click(function(){
		$(this).children(".sf_develop").addClass("active");
		openOtherPickerMethod(fromID,successFn,failFn);
	});	
}
saveOtherPicker($("#goodsType"),"goodsType","请选择货物类型",resource.hwtype);
saveOtherPicker($("#carType"),"carType","请选择车辆类型",resource.cartype);
saveOtherPicker($("#carlongType"),"carlongType","请选择车长度",resource.carlength);


//请求原生的周期插件
function ReleaseTimeMehtod(cls,ids){
	var fromID=[{fromId:ids}];
	cls.parent("p").click(function(){
		// var time=$("#cartimeType").val("");
		// $(this).children(".sf_develop").addClass("active");
		openSelectedReleaseTimeMehtod(fromID,successFn,null);
	});	
}
ReleaseTimeMehtod($("#carCycleType"),"carCycleType");



//请求原生的日期插件
function ReleaseDayeMehtod(cls,ids){
	cls.parent("p").click(function(){
		var cycle=$("#carCycleType").val();
		var time=$("#cartimeType").val();
		var fromID=[{fromId:ids,time:time,cycle:cycle}];
		if(cycle==""||cycle==undefined){
			showErrorMessage("请先选择周期");
			return false;
		}
		$(this).children(".sf_develop").addClass("active");
		openSheetTypeDatePickerMethod(fromID,successFn,failFn);
	});	
}
ReleaseDayeMehtod($("#cartimeType"),"cartimeType");


////点击立即发布
function justCar(){
	//出发城市
	var sf_fromAdd=$("#sf_fromAdd");
	var input_from_detail = $("#input_from_detail");
	//到达城市
	var toAddress=$("#toAddress");
	var input_to_detail = $("#input_to_detail");
	//货物及车辆信息
	var goodsTypename = $("#goodsTypename");
	var goodsType = $("#goodsType");
	var goodsweight = $("#goodsweight");
	var goodsvolume = $("#goodsvolume");
	var carType= $("#carType");
	var carlongType=$("#carlongType");
	var carCycleType=$("#carCycleType");
	var cartimeType=$("#cartimeType");
	var goodsprice=$("#goodsprice");
	var Consignee=$("#Consignee");
	var phoneNumber=$("#phoneNumber");
	var Consignee=$("#Consignee");
	var input_remark=$("#input_remark");
	var carNumber = $("#carNumber");
	var goodsmodel;
	 
	
	if(sf_fromAdd.val()==""){
		showErrorMessage("请选择出发地省市县");
		return false;	
	};
	if(input_from_detail.val()==""){
		showErrorMessage("请填写出发地详细地址");
		return false;
	};
	if(toAddress.val()==""){
		showErrorMessage("请选择到达地省市县")
		return false;
	};
	if(input_to_detail.val()==""){
		showErrorMessage("请填写到达地详细地址")
		return false;
	};
	
	if(goodsType.val()==""){
		showErrorMessage("请选择货物类型")
		return false;
	};
	if(carCycleType.val()==""){
		showErrorMessage("请选择发布周期")
		return false;
	};
	if(Consignee.val()==""){
		showErrorMessage("请填写收货人姓名")
		return false;
	};
	if(phoneNumber.val()==""||phoneNumber.val().length<11){
		showErrorMessage("请填写正确收货人手机号码")
		return false;
	}else{
		if(goodsprice.val()==""){
			goodsprice.val("面议")
		};
		
		var fromObj = toCityObj($("#sf_fromAdd").val()); 
		var toObj   = toCityObj($("#toAddress").val());	
		goodsmodel = GoodsModel(fromObj,toObj);
		releaseGoodsnews(goodsmodel);
	}
	
	
};

//appURL+"/Goods/PublishGoodsSrc"
//点立即发布，发送数据给后台
function releaseGoodsnews(datas){
	$.ajax({
	        url:"http://192.168.112.157:8888/API/api/Goods/PublishGoodsSrc",
	        type: "post",
	        dataType:"json",
	        data: datas,
	        success: function (data) {
	            console.log(data);
	            if (data.Code != 1) {
	            	showSuccessMessage("发布成功");
		            if (!orderId.length) {
		            	navigation.dismiss(null,null);
		            } else {
		            	navigation.pop(null,null);
		            };
	            } else {
	            	showErrorMessage("发布失败");
	            };
	            
	            
	        },
	        error: function (error) {
	            showErrorMessage("发布失败")
	        }
		});
}

// SFAppData = {
//       	GoodsId : 'cc710a6f-90ee-40a3-a37b-2ef4c1078ebf',
//    };

//原生调用，暂存订单数据
function requestGoodsDetail(){
	$.ajax({
	        url: appURL+"/GoodsOrder/GetGoodsOrderDetails",
	        type: "post",
	        dataType:"json",
	        data: SFAppData,
	        success: function (data) {
	        	console.log(data);
	        	var datas = data.Data.goods_details;
	        	temporaryDetail(datas)
	            
	        },
	        error: function (error) {
	            showErrorMessage("请检查网络")
	        }
		});
}



//暂存数据渲染
function temporaryDetail(data){
	var sf_fromAdd=$("#sf_fromAdd").val(data.from_province+"-"+data.from_city+"-"+data.from_district);
	var input_from_detail =  $("#input_from_detail").val(data.from_address);
	
	var toAddress=$("#toAddress").val(data.to_province+"-"+data.from_city+"-"+data.to_district);;
	var input_to_detail = $("#input_to_detail").val(data.to_address);
	var input_remark = $("#input_remark").val(data.attention_remark);
	
	var goodsTypename = $("#goodsTypename").val(data.goods_name);
	var goodsType = $("#goodsType").val(data.goods_type);
	var goodsweight = $("#goodsweight").val(data.goods_weight);
	var goodsvolume = $("#goodsvolume").val(data.weight_unit);
	var carType= $("#carType").val(data.car_type);
	var carlongType=$("#carlongType").val(data.car_long);
	var carCycleType=$("#carCycleType").val(data.cycle);
	var cartimeType=$("#cartimeType").val(data.shipment_date);
	var goodsprice=$("#goodsprice").val(data.price);
	var Consignee=$("#Consignee").val(data.delivery_by);
	var phoneNumber=$("#phoneNumber").val(data.delivery_mobile);
	var carNumber = $("#carNumber").val(data.car_count);
	
	
	//去掉默认属性值
	var sf_fromAddPlac=$("#sf_fromAdd").attr("placeholder","");
	var input_from_detailPlac =  $("#input_from_detail").attr("placeholder","");
	
	var toAddressPlac=$("#toAddress").attr("placeholder","");
	var input_to_detailPlac = $("#input_to_detail").attr("placeholder","");
	var input_remarkPlac = $("#input_remark").attr("placeholder","");
	
	var goodsTypenamePlac = $("#goodsTypename").attr("placeholder","");
	var goodsTypePlac = $("#goodsType").attr("placeholder","");
	var goodsweightPlac = $("#goodsweight").attr("placeholder","");
	var goodsvolumePlac = $("#goodsvolume").attr("placeholder","");
	var carTypePlac= $("#carType").attr("placeholder","");
	var carlongTypePlac=$("#carlongType").attr("placeholder","");
	var carCycleTypePlac=$("#carCycleType").attr("placeholder","");
	var cartimeTypePlac=$("#cartimeType").attr("placeholder","");
	var goodspricePlac=$("#goodsprice").attr("placeholder","");
	var ConsigneePlac=$("#Consignee").attr("placeholder","");
	var phoneNumberPlac=$("#phoneNumber").attr("placeholder","");
	var carNumberPlac = $("#carNumber").attr("placeholder","");
}

// requestCardetail()