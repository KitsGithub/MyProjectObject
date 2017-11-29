
/*
 * js test File
*/

var errorString = "请输入正确的参数";

var arr = ["A","B","C","D"];

function count () {

    max = arr.length;

    document.getElementById("num").innerHTML = arr[parseInt(max * Math.random())];

}

function start() {
    timeId = setInterval("count();", 100);
}

function stop() {
    clearInterval(timeId);
}





