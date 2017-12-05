
// SFAppData={Guid:"0d5c0302-582a-48b7-be16-af7f1241be77"};
var orderId;
   
   //原生调用暂存的方法
function rendCardetail(orderId){
	if(orderId){
		requestCardetail()	    
	}
}

//请求原生地址插件
function saveaddress(cls,ids){
	var fromID=[{fromId:ids}];
	cls.click(function(){
		$(this).next(".sf_develop").addClass("active");
		openAdressPickerMethod(fromID,successFn,null)
	});
}
saveaddress($("#sf_fromAdd"),"sf_fromAdd");
saveaddress($("#toAddress"),"toAddress");

//请求原生选择车辆的各种条件插件
function saveOtherPicker(cls,ids,title,data){
	var fromID=[{fromId:ids,title:title,data:data}];
	cls.click(function(){
		$(this).next(".sf_develop").addClass("active");
		openOtherPickerMethod(fromID,successFn,null);
	});	
}
saveOtherPicker($("#goodsType"),"goodsType","请选择货物类型",resource.hwtype);
saveOtherPicker($("#carType"),"carType","请选择车辆类型",resource.cartype);
saveOtherPicker($("#carlongType"),"carlongType","请选择车长度",resource.carlength);
//请求原生的周期插件

//请求原生的时间插件
function ReleaseTimeMehtod(cls,ids){
	var fromID=[{fromId:ids}];
	cls.click(function(){
		$(this).next(".sf_develop").addClass("active");
		openSelectedReleaseTimeMehtod(fromID,successFn,null);
	});	
}
ReleaseTimeMehtod($("#carCycleType"),"carCycleType");
//saveOtherPicker($("#cartimeType"),"cartimeType","请选择货物类型",resource.hwtype);
//	if(ids=="cartimeType"){
//		cls.click(function(){
//			if($("#carCycleType").val()==undefined){
//				showErrorMessage("请填写出发地详细地址");
//				return false;
//			}
//			$(this).next(".sf_develop").addClass("active");
//			openOtherPickerMethod(fromID,successFn,failFn);
//		});
//	}else{
//		cls.click(function(){
//			$(this).next(".sf_develop").addClass("active");
//			openOtherPickerMethod(fromID,successFn,failFn);
//		});
//	}


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
	
	if(goodsType.val()==undefined){
		showErrorMessage("请选择货物类型")
		return false;
	};
	if(carCycleType.val()==undefined){
		showErrorMessage("请选择发布周期")
		return false;
	};
	if(Consignee.val()==undefined){
		showErrorMessage("请填写收货人姓名")
		return false;
	};
	if(phoneNumber.val()==undefined){
		showErrorMessage("请添加收货人手机号码")
		return false;
	}else{
		if(goodsprice.val()==""){
			goodsprice.val("面议")
		}
		
		goodsmodel = GoodsModel();
		releaseGoodsnews(goodsmodel);
	}
	
	
};



//点立即发布，发送数据给后台
function releaseGoodsnews(datas){
	$.ajax({
	        url: appURL+"/Goods/PublishGoodsSrc",
	        type: "post",
	        dataType:"json",
	        data: datas,
	        success: function (data) {
	            console.log(data);
	            showSuccessMessage("发布成功");
	            navigation.dismiss(null,null);
	            
	        },
	        error: function (error) {
	            showErrorMessage("发布失败")
	        }
		});
}

// var SFAppData={
// 	UserId:"88383c70-f27b-43cc-98a5-d073a67de554",
// 	CarId: "fffd33d9-b7fc-4e54-981e-aef789223167"
// }
//原生调用，暂存订单
function requestCardetail(){
	$.ajax({
	        url: appURL+"/CarsBooking/GetTakingGoodsOrderList",
	        type: "post",
	        dataType:"json",
	        data: SFAppData,
	        success: function (data) {
	        	console.log(data);
	            showSuccessMessage("发布成功");
	            navigation.dismiss(null,null);
	            temporaryDetail(data)
	        },
	        error: function (error) {
	            showErrorMessage("发布失败")
	        }
		});
}

// requestCardetail()

//暂存数据渲染
function temporaryDetail(data){
	var sf_fromAdd=$("#sf_fromAdd").val(data.from_province+"-"+data.from_city+"-"+data.from_district);
	var input_from_detail =  $("#input_from_detail").val(data.from_address);
	
	var toAddress=$("#toAddress").val(data.to_province+"-"+data.from_city+"-"+data.to_district);;
	var input_to_detail = $("#input_to_detail").val(data.to_address);
	var input_remark = $("#input_remark").val(data.car_remark);
	
	var goodsTypename = $("#goodsTypename").val();
	var goodsType = $("#goodsType").val();
	var goodsweight = $("#goodsweight").val();
	var goodsvolume = $("#goodsvolume").val();
	var carType= $("#carType").val();
	var carlongType=$("#carlongType").val();
	var carCycleType=$("#carCycleType").val();
	var cartimeType=$("#cartimeType").val();
	var goodsprice=$("#goodsprice").val();
	var Consignee=$("#Consignee").val();
	var phoneNumber=$("#phoneNumber").val();
	var Consignee=$("#Consignee").val();
	var carNumber = $("#carNumber").val();
	
}
