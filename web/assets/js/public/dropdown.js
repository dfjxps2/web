
function uniqueArray(array, key){
  var result = [array[0]];
  for(var i = 1; i < array.length; i++){
    var item = array[i];
    var repeat = false;
    for (var j = 0; j < result.length; j++) {
      if (item[key] == result[j][key]) {
        repeat = true;
        break;
      }
    }
    if (!repeat) {
      result.push(item);
    }
  }
  return result;
}

 var host_list = [];
 var sys_list = [];
 var user_list =[];
function getList(l1,l2,l3,l4){
    upDiv();
           $.ajax({
               type: 'POST',
               url:"/selec/1",
               //data:JSON.stringify(data), //转化字符串
               contentType: 'application/json;charset=UTF-8',
               success:function(data){ //成功的话，得到消息
                  host_list = JSON.parse(data.host_list);
                  user_list = JSON.parse(data.user_list);
                  sys_list = JSON.parse(data.system_list);
                  var tmp = {};
                 /* for(var i=0; i < host_list.length ; i++){
                      tmp = {};
                      tmp.id = host_list[i].sys_id;
                      tmp.name = host_list[i].sys_name;
                      sys_list.push(tmp);
                  }
                  sys_list = uniqueArray(sys_list,"id");*/
                  if(l1 == 1){
                      levelList(JSON.parse(data.level_list));
                  }
                  if(l2 == 1){
                      //systemList(sys_list);
                  }
                  if(l3 == 1){
                      hostsList(0);
                  }
                  if(l4 == 1){
                      userList(0);
                  }
               }
           });
}
function levelList(data) {
   var tbody=window.document.getElementById('level');
   	var str = ' <label>异常级别:</label>' +
        '<select id = "errSelect" style = "height:26px">'+
           '<option value = "">请选择</option>';
                  for (var i = 0; i < data.length; i++) {
						str = str+ '<option value = "'+data[i].id+'">'+data[i].level_name+'</option>';
					}
                str = str+'</select>';
   	tbody.innerHTML = str;
}

function systemList(data) {
   var tbody=window.document.getElementById('system');
    	var str = ' <label>系统:</label>' +
             '<select id = "sysSelect" style = "height:26px;width:70px;">'+
                    '<option onclick = "return hostsList(this.value)" value = "0">请选择</option>';
                  for (var i = 0; i < data.length; i++) {
						str = str+ '<option onclick = "return hostsList(this.value)" value = "'+data[i].id+'">'+data[i].name+'</option>';
					}
                str = str+'</select>';
   	tbody.innerHTML = str;
}

function userList(value) {
   var tbody=window.document.getElementById('user_list');
    	var str = ' <label>用户:</label>' +
             '<select id = "sysSelect" style = "height:26px;width:113px;">'+
                    '<option value = "0">请选择</option>'+
                    '<option value = "-1">root</option>\'';
                  for (var i = 0; i < user_list.length; i++) {
                      if(value > 0){
                          if(user_list[i].host_id == value){
                                str = str+ '<option value = "'+user_list[i].id+'">'+user_list[i].user_name+'</option>';
                            }
                      }else {
                          str = str + '<option value = "' + user_list[i].id + '">' + user_list[i].user_name + '</option>';
                      }
                  }
                str = str+'</select>';
   	tbody.innerHTML = str;
}




function hostsList(value) {
   var tbody=window.document.getElementById("hosts");
    	var str = ' <label>主机:</label>' +
             '<select id = "hostSelect" style = "height:26px;width:160px;">'+
                 '<option onclick = "return userList(this.value);" value = "0">请选择</option>';
             if(value>0){
                for (var i = 0; i < host_list.length; i++) {
                    if(host_list[i].sys_id == value){
                       str = str+ '<option onclick = "return userList(this.value);" value = "'+host_list[i].host_id+'">'+host_list[i].host_name+'</option>';
                    }
                 }
            }else{
               for (var j = 0; j < host_list.length; j++) {
                     str = str+ '<option onclick = "return userList(this.value);" value = "'+host_list[j].host_id+'">'+host_list[j].host_name+'</option>';
               }
             }
                str = str+'</select>';
   	tbody.innerHTML = str;
}

function dragPanelMove(downDiv,moveDiv){
    //var maxH = $('.container-fluid').width();
    $(downDiv).mousedown(function (e) {
        var isMove = true;
        var div_x = e.pageX - $(moveDiv).offset().left;
        //var div_y = e.pageY - $(moveDiv).offset().top;

        $(document).mousemove(function (e) {
            if (isMove) { var obj = $(moveDiv);
             obj.css({"left":e.pageX - div_x}); } }).mouseup( function () {
             isMove = false;
             });
      });
    }

    //验证手机号
    function isPhoneNumber(tel) {
    var reg =/^0?1[3|4|5|6|7|8][0-9]\d{8}$/;
    return reg.test(tel);
}

//验证邮箱
function isEmail(email) {
 var regex = /^([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/g;
  return regex.test(email);
 }

 //验证姓名
 function isName(name) {
 var nameReg = /^[\u4E00-\u9FA5]{2,4}$/;
  return nameReg.test(name);
 }

  //纯数字验证
 function isNumber(val) {
    var regPos = /^\d+(\.\d+)?$/; //非负浮点数
    var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/;
    if(regPos.test(val) || regNeg.test(val)){
        return true;
    }else{
        return false;
    }
 }

 function ss(value){
var l = /^(.*(Error)).*$/;
//var s = 'dwqwasdwqeddassa';
l.test(value);
}


//去左右空格;
function trim(s){
    return s.replace(/(^\s*)|(\s*$)/g, "");
}

//去随机整数
function RandomNum(Min,Max){
	var Range = Max - Min;
	var Rand = Math.random();
	var num = Min + Math.round(Rand * Range);
	return num;
	}

//获取当前日期
function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate;
        return currentdate;
    }

function upDiv(){
     $(".sidebar-toggle").click(function(){
     var wid1 = $(".box-body").width();
      var wid2 = $("body").width();
      if(wid2-wid1 < 120){
         $("#log_table").css('width','79.3%');
      }else{
          $("#log_table").css('width','92.6%');
      }
});
}

function showChart(metaDate,f,legendData,xAxisData,title,type,id){
    var myChart = echarts.init(document.getElementById(id));
    var serieData = [];
    if(type == 'bar') {
        for(var v=0; v < legendData.length ; v++){
          var serie = {
              name:'',
              type:'bar',
              barWidth: '60%',
              data: metaDate[v]
          };
          serieData.push(serie)
        }
    }else if(type == 'line'){
        for(var v=0; v < legendData.length ; v++){
          var serie = {
              name:legendData[v],
              type: 'line',
              symbol:"circle",
              symbolSize:10,
              data: metaDate[v]
          };
          serieData.push(serie)
        }
    }
    var tr = false;
    if(legendData.length>1){
       tr = true;
    }

  var colors = ["#036BC8","#4A95FF","#5EBEFC","#2EF7F3","#FFFFFF"];
  var option = {
      title : {text: title,textAlign:'left',textStyle:{color:"#fff",fontSize:"16",fontWeight:"normal"}},
      legend: {
        show:tr,right:"4%",data:legendData,y:"5%",
          itemWidth:18,itemHeight:12,textStyle:{color:"#fff",fontSize:14},
      },
      color:colors,
      grid: {left: '2%',top:"12%",bottom: "5%",right:"5%",containLabel: true},
      tooltip : { trigger: 'axis',axisPointer : { type : 'shadow'}},
      xAxis: [
          {
              type: 'category',
              show:f,
              axisLine: { show: true,lineStyle:{ color:'#6173A3' }},
              axisLabel:{interval:0,textStyle:{color:'#9ea7c4',fontSize:14} },
              axisTick : {show: false},
              data:xAxisData,
          },
      ],
      yAxis: [
          {
              show:f,
              axisTick : {show: false},
              splitLine: {show:false},
              axisLabel:{textStyle:{color:'#9ea7c4',fontSize:14} },
              axisLine: { show: true,lineStyle:{ color:'#6173A3'}},
          },
      ],
      series:serieData
  };
  myChart.setOption(option);
  var id1 = '#'+id+' div';
  var id2 = '#'+id+' canvas';
  $(id1).css('width','100%');
  $(id2).css('width','100%');
}



