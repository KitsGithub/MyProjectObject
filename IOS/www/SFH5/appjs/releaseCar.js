
// SFAppData={Guid:"0d5c0302-582a-48b7-be16-af7f1241be77"};
   var orderId;
   
   //原生调用暂存的方法
function rendCardetail(orderId){
	if(orderId){
		justCar();	    
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
saveaddress($("#sf_fromAdd"),"sf_fromAdd")
saveaddress($("#toAddress"),"toAddress")



//请求原生选中车辆成功
function appendCarNumber(datas){
	var html="";
	if(datas.price!=undefined){
		var data =datas.message;
		for(var i=0; i<data.length;i++){
			html+='<li><div><i class="iconcar"></i><span class="carNumber">'+data[i].car_no+'</span><i class="iconcloose" onclick="closeCar(this)"></i></div><div><span>'+data[i].car_type+'</span><span>'+data[i].car_long+'米  </span><span>'+data[i].dead_weight+'吨  </span><span>'+data[i].car_size+'方</span></div><div><input type="text" placeholder="'+datas.price+'"  value= ""  onkeyup="onlyNumber(this)"  id="releaseCarprice" class="releaseCarprice" /><i class="iconprice"></i></div></li>'
		}
	}else{
		for(var i=0; i<datas.length;i++){
			html+='<li><div><i class="iconcar"></i><span class="carNumber">'+datas[i].car_no+'</span><i class="iconcloose" onclick="closeCar(this)"></i></div><div><span>'+datas[i].car_type+'</span><span>'+datas[i].car_long+'米  </span><span>'+datas[i].dead_weight+'吨  </span><span>'+datas[i].car_size+'方</span></div><div><input type="text" placeholder="'+datas[i].order_fee+'"  value= "'+datas[i].order_fee+'"  onkeyup="onlyNumber(this)"  id="releaseCarprice" class="releaseCarprice" /><i class="iconprice"></i></div></li>'
		}
	}
	$("#carWraps").append(html);

}

//点击选择车辆选车
$("#choseCarnumber").click(function(){
	$(this).children(".sf_develop").addClass("active");
	var arrs = $("#carWraps").find("li");
	var cars = [];
	if(arrs.length==0){
		cars.push("");
	}else{
		for(i=0;i<arrs.length;i++){
   		var idd = $(arrs[i]).children().eq(0).text();
		var val = $(arrs[i]).children().eq(2).children().val();
		cars.push(idd);
       }
	};
    var data ={fromId:"carNumber",cars:cars};
	openSelectedCarMethod([data],successFn,null)
	
})

//点击关闭删除当前车辆信息
function closeCar(obj){
	$(obj).parents("li").remove();
}



////点击立即发布
function justCar(){
	//出发城市
	var sf_fromAdd=$("#sf_fromAdd");
	var input_from_detail = $("#input_from_detail");
	//到达城市
	var toAddress=$("#toAddress");
	var input_to_detail = $("#input_to_detail");
	//填写价格
	var releaseCarprice = $(".releaseCarprice");
	
	
	if(sf_fromAdd.val()==""){
		showErrorMessage(["请选择出发地省市县"]);
		return false;	
	};
	if(input_from_detail.val()==""){
		showErrorMessage(["请填写出发地详细地址"]);
		return false;
	};
	if(toAddress.val()==""){
		showErrorMessage(["请选择到达地省市县"])
		return false;
	};
	if(input_to_detail.val()==""){
		showErrorMessage(["请填写到达地详细地址"])
		return false;
	};
	
	if(releaseCarprice.val()==undefined){
		showErrorMessage(["请选择车辆"])
		return false;
	}else{
		if(releaseCarprice.val()==""){
			releaseCarprice.val("面议")
		}
		var fromObj = toCityObj($("#sf_fromAdd").val()); 
		var toObj   = toCityObj($("#toAddress").val());	
		var carsmodel = CarsModel(fromObj,toObj);
		releaseCarnews(carsmodel);
	}
};



//点立即发布，发送数据给后台
function releaseCarnews(datas){
	$.ajax({
	        url: appURL+"/Cars/IssueCarOrder",
	        type: "post",
	        dataType:"json",
	        data: datas,
	        success: function (data) {
//	        	var head_src = 'http://172.16.100.147/devlis' + data.Data.head_src
//	        	data.Data.head_src = head_src
//	        	that.datas=data.Data
	            console.log(data);
	            showSuccessMessage(["发布成功"]);
	            navigation.dismiss(null,null);
	            
	        },
	        error: function (error) {
	            showErrorMessage(["发布失败"])
	        }
		});
}
//http://192.168.112.44/lisapi/api
//暂存订单请求
function requestCardetail(){
	$.ajax({
	        url:appURL+"/CarsBooking/GetCarsOrderDetails",
	        type: "post",
	        dataType:"json",
	        data: SFAppData,
	        success: function (data) {
	        	console.log(data)
	        	var cars_details =data.Data.cars_details; 
	        	var cars_info = data.Data.cars_info;
	            temporaryDetail(cars_details,cars_info);
	        },
	        error: function (error) {
	            showErrorMessage(["发布失败"])
	        }
		});
}

//暂存数据渲染
function temporaryDetail(data,cars_info){
		var sf_fromAdd=$("#sf_fromAdd").val(data.from_province+"-"+data.from_city+"-"+data.from_district);
		var input_from_detail =  $("#input_from_detail").val(data.from_address);
		
		var toAddress=$("#toAddress").val(data.to_province+"-"+data.to_city+"-"+data.to_district);;
		var input_to_detail = $("#input_to_detail").val(data.to_address);
		var input_remark = $("#input_remark").val(data.car_remark);
		
		appendCarNumber(cars_info);	
}

// requestCardetail()
