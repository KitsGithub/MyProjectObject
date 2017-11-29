
/*
 * js Constants File
*/

var errorString = "请输入正确的参数";

var arr = ["A","B","C","D"];

function count () {
    
    max = 1;
    
    document.getElementById("num").innerHTML = arr[parseInt(max * Math.random())];
    
}

function start() {
    timeId = setInterval("count();", 100);
}

function stop() {
    clearInterval(timeId);
}


// 定位
function LocationMethod () {
    Cordova.exec(successFunction, failFunction, "KXLoactionPlugin", "starLoaction", ["定位功能"]);
}

function testMethod (an,bn) {
    Cordova.exec(successFunction, failFunction, "KXLoactionPlugin", "starLoaction", [an,bn]);
}
