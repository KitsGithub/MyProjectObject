//原生调用暂存的方法
function rendCardetail(){
		justCar("B");		    
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
function justCar(toAB){
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
		goodsmodel = GoodsModel(fromObj,toObj,toAB);
		if (toAB == "B") {
			releaseGoodsnews(goodsmodel,"暂存成功","暂存失败");
		} else {
			releaseGoodsnews(goodsmodel,"发布成功","发布失败");
		};
	}
	
	
};

//appURL+"/Goods/PublishGoodsSrc"
//点立即发布，发送数据给后台
function releaseGoodsnews(datas,message,errorMessage){
	$(".contents").css("display","none");
	$("#appLoading").css("display","block");
	$.ajax({
	        url:appURL+"/Goods/PublishGoodsSrc",
	        type: "post",
	        dataType:"json",
	        data: datas,
	        success: function (data) {
	            console.log(data);
	            if (data.Code != 1) {
	            	showSuccessMessage(message);
		            if (!orderId.length) {
		            	navigation.dismiss(null,null);
		            } else {
		            	navigation.pop(null,null);
		            };
	            } else {
	            	showErrorMessage(errorMessage);
	            };
	             $(".contents").css("display","block");
				$("#appLoading").css("display","none");
	            
	        },
	        error: function (error) {
	            showErrorMessage(errorMessage);
	             $(".contents").css("display","block");
				$("#appLoading").css("display","none");
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
	var carType= $("#carType").val(data.car_type);
	var goodsTypename = $("#goodsTypename").val(data.goods_name);
	var goodsType = $("#goodsType").val(data.goods_type);
	var goodsweight = $("#goodsweight").val(data.goods_weight);
	var goodsvolume = $("#goodsvolume").val(data.goods_size);
	var carlongType=$("#carlongType").val(data.car_long);
	//var carCycleType=$("#carCycleType").val(data.cycle);
	//var cartimeType=$("#cartimeType").val(data.shipment_date);
	var goodsprice=$("#goodsprice").val(data.price);
	var Consignee=$("#Consignee").val(data.delivery_by);
	var phoneNumber=$("#phoneNumber").val(data.delivery_mobile);
	var carNumber = $("#carNumber").val(data.car_count);
	switch (data.cycle){
		case 0:
			var carCycleType=$("#carCycleType").val("只发布一次");
			break;
		case 1:
			var carCycleType=$("#carCycleType").val("发布一个月");
			break;
		case 2:
			var carCycleType=$("#carCycleType").val("发布半年");
			break;
		case 3:
			var carCycleType=$("#carCycleType").val("发布一年");
			break;
		case 4:
			var carCycleType=$("#carCycleType").val("长期有效");
			break;
		default:
			break;
	};
	if(data.cycle!=0){
		var cartimeType=$("#cartimeType").val(data.shipment_time);
	}else{
		var cartimeType=$("#cartimeType").val(data.shipment_date);
	};
	
	

};

// requestCardetail()