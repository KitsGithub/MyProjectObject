

if(typeof PublishRole == "undefined"){
    var PublishRole = {
    	cars : 0,
    	goods : 1
	};
}

/** 角色  0车主发布车源  1货主发布货源 **/
var g_publish_role ;

if(window.location == "fabu.html"){
	g_publish_role = PublishRole.cars;
}else{
	g_publish_role = PublishRole.goods;
}

/* 设置是否根据用户角色切换页面 */
var autochangeLocation = true;

/* 页面加载完成之后调用 */
var currentUser;
app.addLoadListener(function () {
    var title = g_publish_role  == PublishRole.cars ?  "发布车源" : "发布货源"
    navigation.setTitle(title)
	SF_ReqestManage.getCurrentUser(function (result) {
		currentUser  = result;
        var pp = window.location.href - window.location.pathname;
        var isG = window.location.href.split("/")
        var location = isG[isG.length-1];
		if(result.role_type == "Goods"){
			g_publish_role  = PublishRole.goods;
            navigation.setTitle("发布货源")
			if(location ==  "release_car.html" && autochangeLocation){
				window.location.href = "release_car.html"
			}
		}else{
			g_publish_role = PublishRole.cars;
            navigation.setTitle("发布车源")
            if(location ==  "release_good.html" && autochangeLocation){
                window.location.href = "release_good.html"
            }
		}
    })
})


//立即发布js
//城市请求
	var resource = {hwtype: ['木材', '食品', '蔬菜', '矿产', '电子电器', '农副产品', '生鲜', '纺织品', '药品', '日用品', '建材', '化工', '设备', '其他', '家畜'],
	cartype: ['保温车', '平板车', '飞翼车', '半封闭车', '危险品车', '集装车', '敞篷车', '金杯车', '自卸货车', '高低板车', '高栏车', '冷藏车', '厢式车'],
	hwweight:['吨','立方'],
	hwvolume: ['20c', '30c', '40c', '50c', '60c', '70c', '20c', '30c', '40c', '50c', '60c', '70c'],
	hwlength: ['4.2米', '4.8米', '5.2米', '5.8米', '6.2米', '6.8米', '7.2米', '8.6米', '9.6米', '12.0米', '12.5米', '13.5米', '16.0米', '17.5米'],
	hwcm:['111','222','30','40','50','60','111','222','30','40','50','60']};

/*
 * 打开原生地址选择器

 @params
 class 	  	: 传递的class名
 type    	  	: 标题
 data 	: 数据
 fn		  	: 执行的函数
*/

function citys(cla,type,data){
	var data=[{
		class:cla,
		title:type,
		data:data 
	}];
	var parent = $(cla).parent();
	$(parent).click(function () {
		console.log(111)
        openAdressPickerMethod(data)
        $(cla).next("span").addClass("active")
    })
};

function singleChoose(cla,type,data){
	var data=[{
		class:cla,
		title:type,
		data:data 
	}];
    var parent = $(cla).parent().parent();
    $(parent).click(function () {
        openOtherPickerMethod(data)
        $(cla).next("span").addClass("active")
    })
};

function moreChoose(cla,type,data){
    var data=[{
              class:cla,
              title:type,
              data:data
              }];
    var parent = $(cla).parent().parent();
    $(parent).click(function () {
        openMoreSelectedPickerMehtod(data)
        $(cla).find("span").addClass("active")
    })
};


function day(cla,type,data){
	$(cla).click(function(){
		var	departDate=$(".sf_year").val()+$(".sf_Mont").val()+$(".sf_Day").val();
		var data=[{
			class:cla,
			title:type,
			data:departDate
		}];
		openDatePickerMethod(data,successDayFunction,null);
		$(cla).next("span").addClass("active")
	})
};

function showCarnumberPick(cla,type) {

    var parent = $(cla).parent().parent();
    $(parent).click(function () {
        getCarNoList(carType,carLong,function (result) {
        	if (result && result.length){
                var list = result.map(function (item) { return item.car_no })
                var data=[{
                    class:cla,
                    title:type,
                    data:list
                }];
                openMoreSelectedPickerMehtod(data)
                // $(cla).next("span").addClass("active")
			}else{
                confirm("没有找到相关车辆，请重新选择车型，车长后重试")
			}
        },function (err) {
            confirm(err.message)
        })
    })
}

citys(".sf_fromAdd",'选择出发省、市、县',resource.cartype);
citys(".sf_toAdd",'选择出发省、市、县',resource.cartype);
singleChoose(".sf_carType",'选择车辆类型',resource.cartype);
singleChoose(".sf_carLength",'选择车长度',resource.hwlength);
singleChoose(".sf_goodType","选择货物类型",resource.hwtype);
// moreChoose(".sfcarnumber",'选择车数量',resource.hwcm);
showCarnumberPick(".sfcarnumber",'选择承运车辆');





day(".sf_timeMx","发车时间")




$("#input_weight").keyup(function () {
	if (event.keyCode == 13){
		this.blur();
	}
})



/*
 * Cordova 成功回调  

 @params
 message 		: 回调参数 

data的json格式 {
	class <str> 	: 调用Cordova时所传递的class
	message  <str> 	: 根据不同接口，返回不同的字段
}

*/
var selCars = [];
var fromAddress = "";
var	toAddress = "";
var	carType = "";
var	carLong = "";
var	carRemark = "";
var goodsType = "";
function successFunction(data){

	//data手机端回调给前端的数据
    var clas = data.class;
    if (data.numbers){ //  多选情况
        var numbers =  JSON.parse(data.numbers);
        var htmls = numbers.join("  ");  // data.message;
        selCars = numbers;
        $(clas).val(htmls)
    }else{
        var htmls = data.message;
        $(clas).val(htmls)

		switch (clas){
			case ".sf_fromAdd":
				fromAddress = data.message;
				break;
			case ".sf_toAdd":
				toAddress  = data.message;
				break;
			case ".sf_carType":
				carType  = data.message;
				break;
			case ".sf_carLength":
				carLong = data.message;
				break;
			case ".sf_Bz":
				carRemark  = data.message;
				break;
			case ".sf_goodType":
				goodsType  = data.message;
				break;
			default:
				break;
		}
    }
	$(clas).next("span").removeClass("active")
	// confirm(data.address);
}


/*
 * Cordova 失败回调

 @params
 data 		: 回调参数 

data的json格式 [{
	class : h5传递控件id
	
}]
*/
function failFunction(error){
	var clas=error.class;
	$(clas).next("span").removeClass("active")
    // confirm("失败了");
}


/*
 * Cordova 成功回调  

 @params
 year 		: 回调参数 

data的json格式 {
	class <str> 	: 调用Cordova时所传递的class
	year  <str> 	: 根据不同接口，返回不同的字段
	month  <str> 	: 根据不同接口，返回不同的字段
	day  <str> 	: 根据不同接口，返回不同的字段
}

*/
var departDate;
function successDayFunction(data){
	//data手机端回调给前端的数据
	var clas=data.class;
	var years=data.year;
	var month=data.month;
	var day=data.day;

	years = years.replace("年","")
	month = month.replace("月","")
	day   = day.replace("日","")


	departDate = years + "-" + month + "-" + month
	$(clas).find("input.sf_year").val(years+ "年");
	$(clas).find("input.sf_Mont").val(month + "月");
	$(clas).find("input.sf_Day").val(day);
	// confirm(data.address);
}

//发布车源本地日期显示
$(document).ready(function(){
	var mydate = new Date();
   	var year = mydate.getFullYear() + "年";
   	var month = (mydate.getMonth()+1) + "月";
   	var day = mydate.getDate();
	$(".sf_year").val(year);
	$(".sf_Mont").val(month);
	$(".sf_Day").val(day);
})

var orderId;

//发布车源点击底部立即发布按钮触发的事件
$(".sf_save").click(function(){
	releaseWithStatus("B")
});
/*暂存方法*/
function saveOrder() {
	releaseWithStatus("B")
}


$(".sf_Fb").click(function(){
	releaseWithStatus("A")
});


function releaseWithStatus(status) {

	var fromDetail  = $("#input_from_detail").val();
	var toDetail    = $("#input_to_detail").val();

	var connectBy = $("#input_name").val()
	var mobil   = $("#input_mobil").val()
	var price   = $("#input_price").val()

    var	carSize = $("#input_volume").val();
    var	deadWeight = $("#input_weight").val();


	var carNumber  = $("#input_car_number").val();
	var goodName   = $("#input_goodsname").val();
	var goodWeight = $("#input_goodsweight").val();
	var goodSize   = $("#input_goodsvolume").val();
	var remark     = $("#input_remark").val();

	if(!fromAddress || fromAddress == ""){
		showErrorMessage(["请选择出发城市"])
		console.log('请选择出发城市')
		return ;
	}
	if (!toAddress || toAddress == "") {
		showErrorMessage(["请选择到达城市"])
		return ;
	};
	if(!carType || carType ==""){
		showErrorMessage(["请选择车辆类型"])
		return ;
	}
	if(!carLong || carLong==""){
		showErrorMessage(["请选择车的长度"])
		return ;
	}
	if(!departDate || departDate == ""){
		showErrorMessage(["请选择发货时间"])
		return;
	}


	if(g_publish_role == PublishRole.cars){
        if(!selCars || !selCars.length){
            showErrorMessage(["请选择承运车辆"])
            return;
        }
	}else{

		if(!goodsType || goodsType == ""){
			showErrorMessage(["请选择货物类型"])
			return;
		}

		if(goodSize == "" && goodWeight == ""){
			showErrorMessage(["请填写货物的总重量或者总体积"])
			return;
		}

		if(!carNumber || carNumber == ""){
			showErrorMessage(["请填写需求的车数量"])
			return;
		}

	}



	function toCityObj(str){
		var result = {};
		var strArr = str.split("-");
		if (strArr.length == 3 ){
			result.province = strArr[0];
			result.city     = strArr[1];
			result.district = strArr[2];
		} else if (strArr.length == 2){
			result.province = strArr[0];
			result.city     = strArr[0];
			result.district = strArr[1];
		}
		return result;
	}

	var fromObj = toCityObj(fromAddress);
	var toObj   = toCityObj(toAddress);


    var params = {};

    if (g_publish_role == PublishRole.cars) {
        params.fromProvince 	= fromObj.province
        params.fromCity 		= fromObj.city
        params.fromDistrict 	= fromObj.district
        params.fromAddress 		= fromDetail ? fromDetail : ""
        params.toProvince  		= toObj.province
        params.toCity    		= toObj.city;
        params.toDistrict  		= toObj.district
        params.toAddress   		= toDetail ? toDetail : ""
        params.carType   		= carType
        params.carLong 			= carLong
		params.weightUnit 		= "吨"
        params.carSize 			= carSize;
        params.deadWeight 		= deadWeight;
        params.departDate 		= departDate;
        params.selCars    		= selCars.join(",");
        params.ConnectBy  		= connectBy;
        params.ConnectMobile 	= mobil;
        params.price  			= price;
        params.carRemark  		= remark || "";
        params.order_status 	= status;
	}else{
    	params.from_province 	= fromObj.province;
    	params.from_city  		= fromObj.city;
    	params.from_district  	= fromObj.district;
    	params.from_address  	= fromDetail ? fromDetail : ""
		params.to_province   	= toObj.province
		params.to_city   		= toObj.city;
    	params.to_district 		= toObj.district;
        params.to_address 		= toDetail ? toDetail : ""
		params.car_type  		= carType;
    	params.car_long  		= carLong;
    	params.weight_unit 		= "吨"
        params.goods_type 		= goodsType;
        params.goods_name 		= goodName;
        params.goods_size 		= goodSize;
        params.goods_weight 	= goodWeight;
        params.car_count  		= carNumber;
        params.shipment_date 	= departDate;
        params.price  			= price;
        params.delivery_by 		= connectBy;
        params.delivery_mobile 	= mobil;
        params.remark			= remark || "";
        params.order_status 	= status;
	}

	fetchUserInfoIfNeed(function (user) {
		if(user){
            params.issue_by  = currentUser.user_id;
            if(g_publish_role == PublishRole.cars){
                publishCars(params,publishSuccess,publishError);
			}else{
                publishGoods(params,publishSuccess,publishError);
			}
		}else{
            confirm("获取用户信息失败，请重试");
		}
    })
}



function fetchUserInfoIfNeed(completion) {
    if (currentUser && currentUser.guid){
        completion(currentUser);
    }else{
        SF_ReqestManage.getCurrentUser(function (result) {
            if(!result){
                completion(undefined);
                return;
            }
            currentUser  = result;
            completion(result);
        })
    }
}

function  publishSuccess(res) {
	SF_ReqestManage.showSuccess("发布成功");
	bridge.execNativaFunc("publishCompletion",true);
	navigation.dismiss();
}

function publishError(err) {
	SF_ReqestManage.showFault(err.message);
}



function  publishGoods(data,success,error) {
    post("Goods/PublishGoodsSrc",data,success,error);
}

function publishCars(data,success,error){
    post("Cars/IssueCarOrder",data,success,error);
}


function  getCarNoList(carType,carLong,success,error) {
	var params = {};
	params.carType  = carType;
	params.carLong  = carLong;
	SF_ReqestManage.post("Cars/GetCarNoList",params,success,error)

}



function requestOrderDetail (){
	
	var fromDetail  = "";
	var fromAddressdetail = '';
	var toDetail    = "";
	var toAddressdetail = "";

	var carType = "";
	var mobil   = "";
	var price   = "";

    var	carLong = "";
    var	deadWeight = "";


	var carNumber  = "";
	var goodName   = "";
	var goodWeight = "";
	var goodSize   = "";
	var remark     = "";

	//请求我发的车详情
	var requestURL = appURL + "/CarsBooking/GetCarsOrderDetails";
	// var CarId = "a30e7b8c-b9fd-4766-a214-55688afca4b9";
	// var UserId ="88383c70-f27b-43cc-98a5-d073a67de55" ;
	// var SFAppData={
	// 	CarId:CarId,
	// 	UserId:UserId
	// }
			// $(".sfRelease").css("opacity",'0');
	  //   	$("#appLoading").css("opacity",'1');
	    	//$("#appLoading").remove();
	$.ajax({
	    url: requestURL,
	    type: "POST",
	    dataType: "json",
	    data :SFAppData,
	    success: function (data) {
	    	var data = data.Data.cars_details;
	    	console.log(data);
	    	
	    	//获取数据	    	
	    	 fromDetail  = data.from_province+"-"+data.from_city+"-"+data.from_district;    //出发省市县
	    	 fromAddressdetail = data.from_address;											//出发详细地址
	    	 toDetail = data.to_province+"-"+data.to_city+"-"+data.to_district;				//到达省市县
	    	 toAddressdetail = data.to_address;												//到达详细地址
	    	 carType = data.car_type;
			 mobil   = data.connect_mobile;
			 price   = 	data.price;	
		     carLong = data.car_long;
		     deadWeight =data.dead_weight; 
		     carNumber  ="";
			 goodName   =""; 
			 goodWeight = "";
			 goodSize   = 
			 remark     = 	    	 
	    	 //赋值
	    	 $("#input_fromaddress").val(fromDetail);
	    	 $("#input_toddress").val(toDetail);
	    	 $("#input_from_detail").val(fromAddressdetail);
	    	 $("#input_to_detail").val(toAddressdetail);
			 $(".sf_carType").val(carType);
			 $(".sf_carLength").val(carLong);
			 $(".sfcarnumber").val(carNumber);
			 //重量体积
			 $("#input_weight").val(deadWeight);
			 $("#input_volume").val();
			 //联系人电话
			 $("#input_name").val(goodName);
			 $("#input_mobil").val(mobil);
			 //意向价格
			 $("#input_price").val(price);
			 //发车时间
			 $(".sf_Day").val()

	    	 lodingFn();
	    },
	    error: function (error) {
	    	confirm("请检查网络")
	    }
	});
}

function lodingFn(){
			$(".sfRelease").css("opacity",'1');
	    	$("#appLoading").css("opacity",'0');
	    	$("#appLoading").remove();
};

