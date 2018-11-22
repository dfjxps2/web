%rebase base
<style type="text/css">
   .addForm{
   padding:0 0 6% 0;
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
      <h3 class="box-title">告警规则设置</h3>
    </div>
    <div class="box-body">
       <form role="form" method="post" action="/report/1" class="form-inline">
        <div class="form-group">
          <label>规则名称：</label>
          <input id = "rule_name" style = "height:26px" type="text"/>
        </div>
       <div id = "level" class="form-group">

        </div>
        <div class="form-group">
          <label>开始日期:</label>
          <input id="startdate" name="startdate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'enddate\')}'})"/>
        </div>
        <div class="form-group">
          <label>结束日期:</label>
          <input id="enddate" name="enddate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startdate\')}'})"/>
        </div>
        <div class="form-group">
          <button type="button" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
         <div class="form-group">
          <input id ="addBtn" type = "button" value = "添加" class="btn btn-primary" onclick = "return addrule()"/>
        </div>
      </form>
      <table id = "rule_info" class="table table-striped" style="margin-top: 10px">

      </table>
    </div>
  </div>
  <div id = "addRule" style = "display:none;">
       <div id = "add" style = "width:400px;height:380px;">
            <div id = "add_title">
                <label>添加设置</label>
                <i onclick = "return closerule()" class="fa fa-window-close"></i>
            </div>
            <div style = "margin-left:15px;">
               <!-- <div class = "addForm col-xs-12" style = "margin-top:7%;">
                        <label class = "col-xs-3 la">规则名称：</label>
                        <input  class = "col-xs-5 inp"  id="ruleName" name="ruleName" type="text"/>
                        <span id = "al1" class = "al col-xs-4" style = "">*规则名称不能为空</span>
                </div>-->
                <div id = "check" class = "addForm col-xs-12" style = "margin-top:7%;">
                    <label>级别：</label>
                    <input id = "ck1" name="rule_level" type="radio" value="1" checked = "checked" />
                    <label>ALERT</label>
                    <input id = "ck2" style= "margin-left:13px;" name="rule_level" type="radio" value="2" />
                    <label>ERROR</label>
                    <input id = "ck3" style= "margin-left:13px;" name="rule_level" type="radio" value="3" />
                    <label>WARNING</label>
                    <input id = "ck4" style= "margin-left:13px;" name="rule_level" type="radio" value="4" />
                    <label>INFO</label>
                </div>
                <div class = "addForm col-xs-12">
                        <label class = "col-xs-3 la">表达式：</label>
                        <input  class = "col-xs-5 inp"  id="rule_exp" name="rule_exp" type="text"/>
                        <span id = "al2" class = "al col-xs-4" style = "">*表达式不能为空</span>
                </div>
                <div class = "addForm col-xs-12">
                    <label>描述：</label>
                           <textarea cols="4" id = "rule_explain" name = "rule_explain" rows="4" style = "min-width:360px;max-width:360px;max-height:112px;">
                            </textarea>
                </div>
                <div class = "addForm">
                   <button id = "bnt" value = "add" onclick = "return addRule(this.value);" style = "height:33px;width:77px;margin-right:20%;" class="btn btn-primary pull-right">保存</button>
                </div>
            </div>
       </div>
  </div>
   <input id = "list1"  type="hidden" value = "{{list}}"/>
   <input id = "ruleId"  type="hidden" value = ""/>
</section>
<script type="text/javascript">
var sa =JSON.parse($("#list1").val());
  $(document).ready(function(){
        getList(1,0,0);
        addTable(JSON.parse($("#list1").val()));
        dragPanelMove("#add_title","#addRule");
          $('#rule_exp').focus(function ()//得到教室时触发的时间
            {
               $('#al2').css("display","none");
            });
            $('#rule_exp').blur(function (){
            if(this.value == ""){
                $('#al2').css("display","block");
            }
        });
});


function addRule(value){
    //var rule_name = $("#ruleName").val();
    var rule_level = $('#check input:checked ').val();
    var rule_exp = $("#rule_exp").val();
    var rule_info = $("#rule_explain").val();
    var creat_date = getNowFormatDate();
    var id = $("#ruleId").val();
    var data={"rule_level":rule_level,"rule_exp":rule_exp,"rule_info":rule_info,"creat_date":creat_date,"types":value,"id":id};
    $.ajax({
               type: 'POST',
               url:"/addRule/1",
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

function updataRule(id,value){
    $("#bnt").val("updata");
    $("#ruleId").val(id);
    $(".t_rule").attr('id','');
    var cl = '.name'+id;
    $(cl).attr('id','log1');
    var data={"id":id,"type":value};
    $.ajax({
               type: 'POST',
               url:"/ruleSettingById/1",
               data:data, //转化字符串
               contentType: 'json',
               headers: {'Content-Type': 'application/json'},
               success:function(data){ //成功的话，得到消息
                    var d = JSON.parse(data);
                    if (value == 1){
                        addrule();
                       // $("#ruleName").val(d[0].rule_name);
                        $("#rule_exp").val(d[0].rule_exp);
                        $("#rule_explain").val(d[0].rule_info);
                        var id = '#ck'+d[0].level_id;
                        $(id).prop("checked",true);
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
     var tbody=window.document.getElementById('rule_info');
     	var str = '<tr>'+
          '<th>序号</th>'+
          '<th>名称</th>'+
          '<th>级别</th>'+
          '<th style = "width:32%">表达式</th>'+
          '<th style = "width:16%">创建时间</th>'+
          '<th style = "width:16%">描述</th>'+
          '<th>操作</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
            var a = i+1;
            str = str +'<tr>'+
          '<td>'+a+'</th>'+
          '<td><span class = "t_rule name'+data[i].id+'">'+data[i].rule_name+'</span></th>'+
          '<td>'+data[i].level_name+'</td>'+
          '<td>'+data[i].rule_exp+'</th>'+
          '<td>'+data[i].creat_date+'</th>'+
          '<td>'+data[i].rule_info+'</th>'+
          '<td><a target="_blank" onclick  = "return updataRule('+data[i].id+',1)" class="btn btn-primary btn-xs">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick  = "return updataRule('+data[i].id+',2)" target="_blank" class="btn btn-primary btn-xs">作废</a></td>'+
            '</tr>';
          }
          tbody.innerHTML = str;
}

function showBy(){
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        level = $("#errSelect").val(),
        rule_name = $("#rule_name").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","level":level>0?level:"0","rule_name":rule_name>0?rule_name:"0"};
    $.ajax({
               type: 'POST',
               url:"/ruleSettingBy/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   addTable(JSON.parse(data));
               }
           });
}


function addrule(){
    $("#addRule").css("display","block");
     $('.al').css("display","none");
     clearForm();
}

function closerule(){
    $("#addRule").css("display","none");
     $("#bnt").val("add");
      $(".t_rule").attr('id','');
    clearForm();
}

function clearForm(){
     $("#startdate").val("");
     $("#enddate").val("");
     $("#rule_name").val("");

    $("#ruleName").val("");
    $("#rule_exp").val("");
    $("#check input").prop("checked",false);
    $("#rule_explain").val("");
    $('.al').css("display","none");
    $("#ck1").prop("checked",true);

    $(".al").css("display","none");
    $("#addRule").css("top","14%");
    $("#addRule").css("left","38%");
}

</script>
