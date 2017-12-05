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

var appURL = 'http://192.168.112.160/api'
var appResourceURL = 'http://172.16.100.147/devlis'

/*
    原生代码给HTML传值接口
    @params data  json格式
*/
var SFAppData;

//datas前端传值给手机端数据包含id以及data
/*
 * 打开地址 选择器

 @params
 datas 	: 参数数组 [<str>]
*/
function openAdressPickerMethod(datas,successFn,failFn) {
   Cordova.exec(successFn, failFn, "SFAdressPickerPlugin", "adressPicker", datas);
}

/*
 * 打开单选 选择器
*/
function openOtherPickerMethod(datas,successFn,failFn) {
	Cordova.exec(successFn, failFn, "SFOtherPickerViewPlugin", "otherSelectePicker", datas);
}


function openLeftAlignPicker(datas) {
    Cordova.exec(successFunction, failFunction, "SFOtherPickerViewPlugin", "singleTablePicker", datas);
}


/* 展示成功提示框 */
function showSuccessMessage(message) {
    Cordova.exec(null, null, "SFMessageViewPlugin", "showSuccessMessage", message);
}

/* 展示失败提示框 */
function showErrorMessage(message) {
    Cordova.exec(null, null, "SFMessageViewPlugin", "showErrorMessage", message);
}


/*
 * 打开多选 选择器
*/
function openMoreSelectedPickerMehtod(datas) {
	Cordova.exec(successFunction, failFunction, "SFMoreSelectedPickerPlugin", "moreSelectedPicker", datas);
}

/*
 * 打开日历 选择器
*/
function openDatePickerMethod(datas,successDayFunction,failFunction) {
	Cordova.exec(successDayFunction, failFunction, "SFDatePickerPlugin", "datePicker", datas);
}

/* 
 * 打开车辆选择器 
 * datas : ['carNum1','carNum2']
 *
 * 回调参数 : {"message" : jsonObject
              "fromId"  : <str>
              "price"   : "请输入价格"" (固定值)
            }
*/
function openSelectedCarMethod(datas,successDayFunction,failFunction) {
    Cordova.exec(successDayFunction, failFunction, "SFChooseCarPlguin", "chooseCar", datas);
}

/*
 * 选择发布周期
 * datas : [{"fromId" : <str>}]
 * 
 * 回调参数 : {
    "message" : <str>, (eg.只发布一次)
    "fromId"  : <str> 
 }
 */
function openSelectedReleaseTimeMehtod(datas,successFn,failFn) {
    Cordova.exec(successFn, failFn, "SFChooseReleaerTimePlugin", "chooseReleaseTime", datas);
}

/** 导航控制器  **/
var navigation = {};
navigation.push  = function (target,title,successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","push",[target,title])
}
navigation.pushToVC = function (target,successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","pushToViewController",[target])
}
navigation.pop  = function (successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","pop",[])
}
navigation.present  = function (target,title,successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","present",[target,title])
}
navigation.dismiss  = function (successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","dismiss",[])
}
navigation.setTitle  = function (title,successDayFunction,failFunction) {
    cordova.exec(successDayFunction,failFunction,"CDVNavigationManage","setTitle",[title])
}

navigation.actionDic = {}
navigation.itemAction = function (itemId) {
    var func = this.actionDic[itemId]
    if(func){
        func();
    }
}

navigation.addRightItem  = function (itemId,title,img,action,successFunction, errorFunc) {
    this.actionDic[itemId] = action;
    cordova.exec(successFunction, errorFunc,"CDVNavigationManage","addRightItem",[itemId,title,img])
}

navigation.modifiyRightItem = function (itemId,title,img,action,successFunction, errorFunc) {
    this.actionDic[itemId] = action;
    cordova.exec(successFunction, errorFunc,"CDVNavigationManage","modifiyRightItem",[itemId,title,img])
}

/** 一些桥接逻辑 **/
var bridge = {};
bridge.execNativaFunc = function (functionId,obj,successFunction, failFunction) {
    cordova.exec(successFunction, failFunction, "SFNetworkingPlugin", "execFunction", [functionId,obj]);
}


/*
 * 请求原生接口
 @parmas 参数说明
 datas 				: [jsonStr]
	jsonStr = {
		apiName : 网络接口名 (原生需要拼接域名)
		params : 参数JSON
	}; 
*/
function requestNetworkMethod (datas,successFunction,failFunction) {
    cordova.exec(successFunction, failFunction, "SFNetworkingPlugin", "requestNetworking", datas);
}

var SF_ReqestManage = {};

/*
* post请求
* @params header  请求的子路径
* @params params  携带的参数列表
* @params success 成功 回调 返回result获取到的对象          function(result){};
* @params error   失败 回调 返回err对象 err.code错误码 err.message错误信息  function(err){};
* */
SF_ReqestManage.post = function(header,params,success,error){
    cordova.exec(success, error, "SFNetworkingPlugin", "post", [header,params]);
}

/*
 * get请求
 * @params header  请求的子路径
 * @params params  携带的参数列表
 * @params success 成功 回调 返回result获取到的对象          function(result){};
 * @params error   失败 回调 返回err对象 err.code错误码 err.message错误信息  function(err){};
 * */
SF_ReqestManage.get = function(header,params,success,error){
    cordova.exec(success, error, "SFNetworkingPlugin", "get", [header,params]);
}


/*HUD*/
SF_ReqestManage.showSuccess = function(mes) {
    cordova.exec(function () {},function () {},"SFNetworkingPlugin", "showSuccess",[mes])
}

SF_ReqestManage.showFault = function showFault(mes) {
    cordova.exec(function () {},function () {},"SFNetworkingPlugin", "showFault",[mes])
}

/*
*
*
* @params success 成功回调
* 回调返回的对象数据结构如下
* result = {account: "goods1",
 guid: "ff2ab804-da94-4cba-98ab-57b6235885d2",
 head_src: "",
 mobile: "13599999999",
 name: "goods1",
 reg_date: "1507885892",
 role: 2,
 role_type: "Goods",
 sex: "",
 status: "A",
 token: "ff2ab804-da94-4cba-98ab-57b6235885d2",
 updated_date: "1507885892"
 }
*
* */
SF_ReqestManage.currentUser = {};
SF_ReqestManage.getCurrentUser = function (success,error) {
    cordova.exec(function (result) {
        this.currentUser = result;
        success(result);
    }, error, "SFNetworkingPlugin","getCurrentUser",[]);
}

//只允许输入数字和小数
function onlyNumber(obj) {
    var t = obj.value.charAt(0);
    obj.value = obj.value.replace(/[^\d\.]/g, '');
    obj.value = obj.value.replace(/^\./g, '');
    obj.value = obj.value.replace(/\.{2,}/g, '.');
    obj.value = obj.value.replace('.', '$#$').replace(/\./g, '').replace('$#$', '.');
    if (t == '-') {
        t ='0';
    };
};



window.confirm = function (message) {
   var iframe = document.createElement("IFRAME");
   iframe.style.display = "none";
   iframe.setAttribute("src", 'data:text/plain,');
   document.documentElement.appendChild(iframe);
   var alertFrame = window.frames[0];
   var result = alertFrame.window.confirm(message);
   iframe.parentNode.removeChild(iframe);
   return result;
 };


var userNativa = true;
var baseUrl = /*"http://192.168.112.160/api"*/  "http://172.16.100.147/lisapi/api"
function post(header,params,success,error){
    if(userNativa){
        SF_ReqestManage.post(header,params,success,error);
    }else{
        $.ajax({
            url:baseUrl + "/" + header,
            type:'POST', //GET
            async:true,    //或false,是否异步
            data:params,
            timeout:5000,    //超时时间
            dataType:'json',    //返回的数据格式：json/xml/html/script/jsonp/text
            success:function(data,textStatus,jqXHR){
                console.log(data)
                console.log(textStatus)
                console.log(jqXHR)
                if(data.Code == 0){
                    success(data.Data);
                }else{
                    error({"code":data.Code,"message":data.Error})
                }
            },
            error:function(xhr,textStatus){
                console.log('错误')
                console.log(xhr)
                console.log(textStatus)
                error({"code":404,"message":"网络异常请重试"});
            }
        })
    }
}
