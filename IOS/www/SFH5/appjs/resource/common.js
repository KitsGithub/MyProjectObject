//调用公共方法；
// 此段代码请勿动
(function (doc, win) {
    var docEl = doc.documentElement,
        resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
        recalc = function () {
            var clientWidth = docEl.clientWidth;
            if(clientWidth>768){
            	clientWidth=768;
            }
            if (!clientWidth) return;
            docEl.style.fontSize = 10 * (clientWidth / 375) + 'px';    //设计稿的尺寸
        };
		
    if (!doc.addEventListener) return;
    win.addEventListener(resizeEvt, recalc, false);
    doc.addEventListener('DOMContentLoaded', recalc, false);
})(document, window);
//此段代码请勿动

var SFAppData;

//城市请求
	var resource = {hwtype: ['木材', '食品', '蔬菜', '矿产', '电子电器', '农副产品', '生鲜', '纺织品', '药品', '日用品', '建材', '化工', '设备', '其他', '家畜'],
	cartype: ['保温车', '平板车', '飞翼车', '半封闭车', '危险品车', '集装车', '敞篷车', '金杯车', '自卸货车', '高低板车', '高栏车', '冷藏车', '厢式车'],
	carlength: ['4.2米', '4.8米', '5.2米', '5.8米', '6.2米', '6.8米', '7.2米', '8.6米', '9.6米', '12.0米', '12.5米', '13.5米', '16.0米', '17.5米']
	};
//{"name":"市辖区","sub":[{"name":"请选择"},{"name":"东城区"},{"name":"西城区"},{"name":"崇文区"},{"name":"宣武区"},{"name":"朝阳区"},{"name":"海淀区"},{"name":"丰台区"},{"name":"石景山区"},{"name":"房山区"},{"name":"通州区"},{"name":"顺义区"},{"name":"昌平区"},{"name":"大兴区"},{"name":"怀柔区"},{"name":"平谷区"},{"name":"门头沟区"},{"name":"密云县"},{"name":"延庆县"},{"name":"其他"},"type":1]}

/*
 * 
 */
//拆分地址栏
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
};



//发布车源获取页面数据
function CarsModel(fromObj,toObj){
		//传递给后台的值
		//备注
		var input_remark = $("#input_remark").val();
		var input_from_detail = $("#input_from_detail").val();
		var input_to_detail = $("#input_to_detail").val();
	
		var arrs = $("#carWraps").find("li");
		var cars = [];
		var price = [];

	   for(i=0;i<arrs.length;i++){
	   		var idd = $(arrs[i]).children().eq(0).text();
			var val = $(arrs[i]).children().eq(2).children().val();
			cars.push(idd);
			price.push(val?val:"面议");
	   }	
		var IssueCarOrderObj={};
		IssueCarOrderObj.car_id=SFAppData.car_id == undefined ? "" : SFAppData.car_id;
		IssueCarOrderObj.issue_by=SFAppData.UserId;
		IssueCarOrderObj.order_status="A";
		IssueCarOrderObj.fromProvince=fromObj.province;
		IssueCarOrderObj.fromCity=fromObj.city;
		IssueCarOrderObj.fromDistrict=fromObj.district;
		IssueCarOrderObj.fromAddress=input_from_detail;
		IssueCarOrderObj.toProvince=toObj.province;
		IssueCarOrderObj.toCity=toObj.city;
		IssueCarOrderObj.toDistrict=toObj.district;
		IssueCarOrderObj.toAddress=input_to_detail;
		IssueCarOrderObj.selCars=cars.toString();
		IssueCarOrderObj.selFee=price.toString();
		IssueCarOrderObj.carRemark=input_remark;
		return IssueCarOrderObj;
};

//发布货源获取页面数据
function GoodsModel(fromObj,toObj){
		//传递给后台的值
		//备注
		var input_remark = $("#input_remark").val();
		var input_from_detail = $("#input_from_detail").val();
		var input_to_detail = $("#input_to_detail").val();
		var carCycleType=$("#carCycleType").val();
		var cycle;
		
		if(carCycleType=="只发布一次"){
			cycle=0;
		}else if(carCycleType=="发布一个月"){
			cycle=1;
		}else if(carCycleType=="发布半年"){
			cycle=2;
		}else if(carCycleType=="发布一年"){
			cycle=3;
		}else if(carCycleType=="长期有效"){
			cycle=4;
		};
		//货物及车辆信息
		var goodsTypename = $("#goodsTypename").val();
		var goodsType = $("#goodsType").val();
		var goodsweight = $("#goodsweight").val();
		var goodsvolume = $("#goodsvolume").val();
		var carType= $("#carType").val();
		var carlongType=$("#carlongType").val();
		
		var cartimeType=$("#cartimeType").val();
		var goodsprice=$("#goodsprice").val();
		var Consignee=$("#Consignee").val();
		var phoneNumber=$("#phoneNumber").val();
		var Consignee=$("#Consignee").val();
		var input_remark=$("#input_remark").val();
		var carNumber = $("#carNumber").val();
		
		var IssueCarOrderObj={};
//		IssueCarOrderObj.car_id=SFAppData.car_id == undefined ? "" : SFAppData.car_id;
		IssueCarOrderObj.issue_by=SFAppData.UserId;
		IssueCarOrderObj.order_status="A";
		IssueCarOrderObj.from_province=fromObj.province;
		IssueCarOrderObj.from_city=fromObj.city;
		IssueCarOrderObj.from_district=fromObj.district;
		IssueCarOrderObj.from_address=input_from_detail;
		IssueCarOrderObj.to_province=toObj.province;
		IssueCarOrderObj.to_city=toObj.city;
		IssueCarOrderObj.to_district=toObj.district;
		IssueCarOrderObj.to_address=input_to_detail;
		IssueCarOrderObj.goods_name=goodsTypename;
		IssueCarOrderObj.goods_size=parseFloat(goodsvolume);
		IssueCarOrderObj.goods_type=goodsType;		
		IssueCarOrderObj.goods_weight=parseFloat(goodsweight);
		IssueCarOrderObj.weightUnit="";
		IssueCarOrderObj.car_type=carType;
		IssueCarOrderObj.car_long=carlongType;
		IssueCarOrderObj.car_count=parseInt(carNumber);
		IssueCarOrderObj.car_remark=input_remark;
		IssueCarOrderObj.cycle=cycle;
		IssueCarOrderObj.zctime=cartimeType;
		IssueCarOrderObj.delivery_by=Consignee;
		IssueCarOrderObj.delivery_date=0; //收货日期
		IssueCarOrderObj.delivery_mobile=phoneNumber;
		IssueCarOrderObj.price=goodsprice;
		return IssueCarOrderObj;
};


//请求原生地址成功回调方法
function successFn(obj){
    if(obj.fromId=="sf_fromAdd"){
    	$("#sf_fromAdd").val(obj.message);
    }else if(obj.fromId=="toAddress"){
    	$("#toAddress").val(obj.message);
    }else if(obj.fromId=="carNumber"){
    	appendCarNumber(obj)
    }else if(obj.fromId=="goodsType"){
    	$("#goodsType").val(obj.message);
    }else if(obj.fromId=="carType"){
    	$("#carType").val(obj.message);
    }else if(obj.fromId=="carlongType"){
    	$("#carlongType").val(obj.message);
    }else if(obj.fromId=="carCycleType"){
    	if($("#carCycleType").val()!=obj.message){
    		$("#cartimeType").val("");
    	}
    	$("#carCycleType").val(obj.message);
    }else if(obj.fromId=="cartimeType"){
    	$("#cartimeType").val(obj.message);
    }
    $(".sf_develop").removeClass("active");
    
};


//请求原生地址回调失败方法
function failFn(errorData){
	showErrorMessage("未进行任何选择");
	 $(".sf_develop").removeClass("active");
};

//只允许输入数字和小数
function onlyNumber(obj) {
    var t = obj.value.charAt(0);
    console.log(t)
    obj.value = obj.value.replace(/[^\d\.]/g, '');
    obj.value = obj.value.replace(/^\./g, '');
    obj.value = obj.value.replace(/\.{2,}/g, '.');
    obj.value = obj.value.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
    if (t == '-') {
        obj.value ='';
    };  
    if (t == '0') {
        obj.value ='';
    };  
};

//获取路由中档额参数
function saveUid(){
	var url = location.search.slice(2);
    var arrUrl = url.split(",");
    var GoodsId=arrUrl[0].split("=")[1];
    var orderId=arrUrl[1].split("=")[1];
    var HmyAppId={
      	GoodsId:GoodsId,
      	orderId:orderId
      }
      return HmyAppId;
}
