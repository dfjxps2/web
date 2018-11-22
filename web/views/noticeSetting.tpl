%rebase base
<style type="text/css">
   .addForm{
   padding:0 0 8% 0;
   }
   .la{
   padding:0;
   line-height:27px;
   }
   .inp{
   height:26px;
   padding:0;
   margin-left:-25px;
   }
   .al{
   color:red;
   display:none;
   padding:0;
   line-height:27px;
   margin-left:13px;
   }
</style>
<section class="content container-fluid">
  <div class="box box-primary">
  	<div class="box-header">
      <h3 class="box-title">告警通知设置</h3>
    </div>
    <div class="box-body">
       <form role="form" method="post" action="/report/1" class="form-inline">
        <div class="form-group" style="margin-left: 20px">
           <label>开始日期:</label>
               <input id="startdate" name="startdate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'enddate\')}'})"/>
        </div>
        <div class="form-group">
            <label>结束日期:</label>
               <input id="enddate" name="enddate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startdate\')}'})"/>
         </div>
        <div class="form-group">
          <label>规则名称：</label>
          <input style = "height:26px" id="notice_name" name="notice_name" type="text"/>
        </div>
        <div class="form-group">
          <label>发送对象：</label>
          <input style = "height:26px;" id="notice_obj" name="notice_obj" type="text"/>
        </div>
        <div class="form-group">
          <button type="button" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
         <div class="form-group">
          <input id ="addBtn" type = "button" value = "添加" class="btn btn-primary" onclick = "return addrule()"/>
        </div>
      </form>
      <table id = "notice_info" class="table table-striped" style="margin-top: 10px">

      </table>
    </div>
  </div>
  <input id = "list1"  type="hidden" value = "{{list}}"/>
  <input id = "ruleId"  type="hidden" value = "0"/>
</section>
 <div id = "addRule" style = "display:none;">
       <div id = "add">
            <div id = "add_title">
                <label>添加设置</label>
                <i onclick = "return closerule()" class="fa fa-window-close"></i>
            </div>
            <div style = "margin-left:15px;">
                <div id = "check" class = "addForm col-xs-12" style = "margin-top:10%;">
                    <label>发送频率：</label>
                    <input id = "ck1" name="Fruit" type="radio" value="1"  checked = "checked"/>
                    <label>一小时</label>
                    <input id = "ck2" style= "margin-left:23px;" name="Fruit" type="radio" value="2" />
                    <label>一天</label>
                    <input id = "ck3" style= "margin-left:23px;" name="Fruit" type="radio" value="3" />
                    <label>一周</label>
                </div>
                <div class = "addForm col-xs-12">
                        <label class = "col-xs-3" style = "padding:0;line-height:27px;">发送对象：</label>
                        <input  class = "col-xs-5" style = "height:26px;padding:0;margin-left:-25px;" id="noticeObj" name="noticeObj" type="text"/>
                        <span id = "al2" class = "al col-xs-4" style = "color:red;display:none;padding:0;line-height:27px;margin-left:13px;">*发送对象不能为空</span>
                </div>
                <div class = "addForm col-xs-12">
                        <label id = "t_label" class = "col-xs-3 " style = "padding:0;line-height:27px;">手机号：</label>
                        <input  class = "col-xs-5" style = "height:26px;padding:0;margin-left:-25px;" id="telephone" name="telephone" type="text"/>
                        <span id = "al3" class = "al col-xs-4" style = "color:red;display:none;padding:0;line-height:27px;margin-left:13px;">*手机号不能为空</span>
                </div>
                <div class = "addForm">
                    <button id = "bnt" value = "add" onclick = "return addNotice(this.value);" style = "height:33px;width:77px;margin-right:20%;" class="btn btn-primary pull-right">保存</button>
                </div>
            </div>
       </div>
       </div>
  </div>
<script type="text/javascript">
  $(document).ready(function(){
     addTable(JSON.parse($("#list1").val()));
     dragPanelMove("#add_title","#addRule");
            $('#noticeObj').blur(function (){
            if(this.value == ""){
                $('#al2').css("display","block");
            }
        });
          $('#noticeObj').focus(function ()//得到教室时触发的时间
            {
               $('#al2').css("display","none");
            })
        $('#telephone').blur(function (){
            if(this.value == ""){
                $('#al3').css("display","block");
            }
        });
          $('#telephone').focus(function ()//得到教室时触发的时间
            {
               $('#al3').css("display","none");
            });
});

function addNotice(value){
    var notice_rate = $('#check input:checked ').val();
    var notice_obj = $("#noticeObj").val();
    var telephone = $("#telephone").val();
    var creat_date = getNowFormatDate();
    var id = $("#ruleId").val();
    if ( notice_obj == "" || telephone == ""){
        if(notice_obj == ""){
            $('#al2').css("display","block");
        }
        if(telephone == ""){
            $('#al3').css("display","block");
        }
        return;
    }

    if(isName(notice_obj) == false){
         $('#al2').css("display","block");
         $('#al2').html("*对象姓名错误！");
         return;
    }
    if(isPhoneNumber(telephone) == false){
         $('#al3').css("display","block");
         $('#al3').html("*手机号码错误！");
         return;
    }

    var data={"notice_rate":notice_rate,"notice_obj":notice_obj,"telephone":telephone,"creat_date":creat_date,"types":value,"id":id};
    $.ajax({
               type: 'POST',
               url:"/addNotice/1",
               data:data, //转化字符串
               contentType: 'json',
               //async:false,
               success:function(data){ //成功的话，得到消息
                    if (data.state  == "0"){
                        alert(data.info);
                    }else{
                        addTable(JSON.parse(data.data));
                        closerule();
                    }
               }
           });
}

function clearForm(){
    $("#startdate").val("");
    $("#enddate").val("");
    $("#notice_name").val("");
    $("#notice_obj").val("");

    $("#noticeObj").val("");
    $("#telephone").val("");
    $("#ck1").prop("checked",true);
    $("#way1").prop("checked",true);
}

function updataNotice(id,value){
    $("#bnt").val("updata");
    $("#ruleId").val(id);
    $(".t_noice").attr('id','');
    var cl = '.name'+id;
    $(cl).attr('id','log1');
    var data={"id":id,"type":value};
    $.ajax({
               type: 'POST',
               url:"/noticeSettingById/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                    var d = JSON.parse(data);
                    if (value == 1){
                        addrule();
                        var id1 = '#ck'+d[0].notice_rate;
                        var id2 = '#way'+d[0].notice_way;
                         $(id1).prop("checked",true);
                        $("#noticeObj").val(d[0].notice_obj);
                        $(id2).prop("checked",true);
                        $("#telephone").val(d[0].telephone);
                    }else {
                        addTable(d);
                        clearForm();
                    }
               }
           });
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
        var hours = date.getHours(); //获取当前小时数(0-23)
        var minutes = date.getMinutes(); //获取当前分钟数(0-59)
        var seconds = date.getSeconds(); //获取当前秒数(0-59)
        if (hours >= 0 && hours <= 9) {
            hours = "0" + hours;
        }
        if (minutes >= 0 && minutes <= 9) {
            minutes = "0" + minutes;
        }
        if (seconds >= 0 && seconds <= 9) {
            seconds = "0" + seconds;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate + ' '+hours+':'+minutes+":"+seconds;
        return currentdate;
    }


function addTable(data){
     var d = ["一小时","一天","一周"];
     var tbody=window.document.getElementById('notice_info');
     	var str = '<tr>'+
          '<th>序号</th>'+
          '<th>规则名称</th>'+
          '<th>发送频率</th>'+
          '<th>发送对象</th>'+
          '<th>联系方式</th>'+
          '<th>创建时间</th>'+
          '<th>操作</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
            var a = i+1;
            str = str +'<tr>'+
          '<td>'+a+'</th>'+
          '<td><span class = "t_noice name'+data[i].id+'">'+data[i].notice_name+'</span></th>'+
          '<td>'+d[data[i].notice_rate-1]+'</td>'+
          '<td>'+data[i].notice_obj+'</th>'+
          '<td>'+data[i].telephone+'</th>'+
          '<td>'+data[i].creat_date+'</th>'+
          '<td><a target="_blank" onclick  = "return updataNotice('+data[i].id+',1)" class="btn btn-primary btn-xs">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick  = "return updataNotice('+data[i].id+',2)" target="_blank" class="btn btn-primary btn-xs">作废</a></td>'+
            '</tr>';
          }
          tbody.innerHTML = str;
}

function showBy(){
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        notice_name = $("#notice_name").val(),
        notice_obj = $("#notice_obj").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","notice_name":notice_name,"notice_obj":notice_obj,"id":"0"};
    $.ajax({
               type: 'POST',
               url:"/noticeSettingBy/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   addTable(JSON.parse(data));
               }
           });
}

function addrule(){
    $("#addRule").css("display","block");
}

function closerule(){
    $("#addRule").css("display","none");
    $(".al").css("display","none");
    $("#addRule").css("top","14%");
    $("#addRule").css("left","38%");
    $(".t_noice").attr('id','');
    clearForm();
}


</script>
