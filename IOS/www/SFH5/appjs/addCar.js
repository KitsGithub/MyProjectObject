/**
 * Created by chaocaiwei on 2017/10/27.
 */

var resource = {hwtype: ['木材', '食品', '蔬菜', '矿产', '电子电器', '农副产品', '生鲜', '纺织品', '药品', '日用品', '建材', '化工', '设备', '其他', '家畜'],
    cartype: ['保温车', '平板车', '飞翼车', '半封闭车', '危险品车', '集装车', '敞篷车', '金杯车', '自卸货车', '高低板车', '高栏车', '冷藏车', '厢式车'],
    hwweight:['吨','立方'],
    hwvolume: ['20c', '30c', '40c', '50c', '60c', '70c', '20c', '30c', '40c', '50c', '60c', '70c'],
    hwlength: ['4.2米', '4.8米', '5.2米', '5.8米', '6.2米', '6.8米', '7.2米', '8.6米', '9.6米', '12.0米', '12.5米', '13.5米', '16.0米', '17.5米'],
    hwcm:['111','222','30','40','50','60','111','222','30','40','50','60']};



function successFunction(data){

    //data手机端回调给前端的数据
    var clas = data.class;
    if (data.numbers){ //  多选情况
        var numbers =  JSON.parse(data.numbers);
        var htmls = numbers.join("  ");  // data.message;
        selCars = numbers;
        $(clas).text(htmls)
    }else{
        var htmls = data.message;
        $(clas).text(htmls)

        switch (clas){
            case ".carno_province":
                province_code = data.message;
                break;
            case ".carno_city":
                city_code  = data.message;
                break;
            case ".car_type":
                carType  = data.message;
                break;
            case ".car_long":
                carLong = data.message;
                break;
            default:
                break;
        }
    }
    $(clas).next("span").removeClass("active")
    // confirm(data.address);
}



var proCodes = ["京","津","渝","沪","冀","晋","辽","吉","黑","苏","浙","皖","闽","赣","鲁","豫","鄂","湘","粤","琼","川/蜀","黔/贵","云/滇","陕/秦","甘/陇","青","台","内蒙古","桂","宁","新","藏","港","澳"]
var chars   = ["A","B","C","D","E","F","G","H","I","J","K","L","M","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
/*
* 根据省份名称返回省份简称
* @param province
* @returns {String}
*/
function provinceForShort(province){
    if(province == "北京市")
        return "京";
    else if(province == "天津市")
        return "津";
    else if(province == "重庆市")
        return "渝";
    else if(province == "上海市")
        return "沪";
    else if(province == "河北省")
        return "冀";
    else if(province == "山西省")
        return "晋";
    else if(province == "辽宁省")
        return "辽";
    else if(province == "吉林省")
        return "吉";
    else if(province == "黑龙江省")
        return "黑";
    else if(province == "江苏省")
        return "苏";
    else if(province == "浙江省")
        return "浙";
    else if(province == "安徽省")
        return "皖";
    else if(province == "福建省")
        return "闽";
    else if(province == "江西省")
        return "赣";
    else if(province == "山东省")
        return "鲁";
    else if(province == "河南省")
        return "豫";
    else if(province == "湖北省")
        return "鄂";
    else if(province == "湖南省")
        return "湘";
    else if(province == "广东省")
        return "粤";
    else if(province == "海南省")
        return "琼";
    else if(province == "四川省")
        return "川/蜀";
    else if(province == "贵州省")
        return "黔/贵";
    else if(province == "云南省")
        return "云/滇";
    else if(province == "陕西省")
        return "陕/秦";
    else if(province == "甘肃省")
        return "甘/陇";
    else if(province == "青海省")
        return "青";
    else if(province == "台湾省")
        return "台";
    else if(province == "内蒙古自治区")
        return "内蒙古";
    else if(province == "广西壮族自治区")
        return "桂";
    else if(province == "宁夏回族自治区")
        return "宁";
    else if(province == "新疆维吾尔自治区 ")
        return "新";
    else if(province == "西藏自治区")
        return "藏";
    else if(province == "香港特别行政区")
        return "港";
    else if(province == "澳门特别行政区")
        return "澳";
    else  return province;

}

/*
 * Cordova 失败回调
 */
function failFunction(error){
    var clas=error.class;
    $(clas).next("span").removeClass("active")
    // confirm("失败了");
}


function addPickerListener(cla,type,data){
    var data=[{
        class:cla,
        title:type,
        data:data
    }];

    var parent = $(cla).parent().parent();
    $(parent).click(function () {
        openLeftAlignPicker(data)
        $(cla).next("span").addClass("active")
    })
};


var province_code = "京";
var city_code = "A";
var	carType = "";
var	carLong = "";
function onClickSave(){
    var number = $("#input_carno_number").val()
    var params = {}
    params.UserId  = currentUser.guid
    params.CarNo  = province_code + city_code  + number
    params.CarType  = carType
    params.CarLong  = carLong

    post("CarTeam/AddCar",params,reqSussess,reqError)
}

function reqSussess(result){
    reqestManage.showSuccess("添加车辆成功")
    navigation.pop()
}


function reqError(err){
    reqestManage.showFault(err.message)
}




addPickerListener(".carno_province","选择车牌省份代码",proCodes)
addPickerListener(".carno_city","选择车牌城市代码",chars)
addPickerListener(".car_type",'选择车辆类型',resource.cartype);
addPickerListener(".car_long",'选择车长度',resource.hwlength);


var currentUser;
app.addLoadListener(function () {
    navigation.addRightItem("addcar_save","保存",null,onClickSave)
    navigation.setTitle("添加车辆")
    reqestManage.getCurrentUser(function (result) {
        currentUser  = result;
    })
})
