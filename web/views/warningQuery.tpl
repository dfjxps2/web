%rebase base
<style type="text/css">
 .addForm{
   padding:0 0 3% 13px;
   }
   .la{
   padding:0;
   line-height:27px;
   }
   .al{
   color:red;
   display:none;
   padding:0;
   line-height:27px;
   margin-left:13px;
   }
   textarea{
   max-width:360px;
   max-height:105px;
   min-width:360px;
   min-height:105px;
   }
</style>
<section class="content container-fluid">
  <div class="box box-primary">
  	<div class="box-header">
      <h3 class="box-title">告警查询</h3>
    </div>
    <div class="box-body">
      <form role="form" method="post" class="form-inline">
        <div class="form-group">
          <label>开始日期:</label>
          <input id="startdate" name="startdate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'enddate\')}'})"/>
        </div>
        <div class="form-group">
          <label>结束日期:</label>
          <input id="enddate" name="enddate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startdate\')}'})"/>
        </div>
        <div id = "level" class="form-group">

        </div>
        <div id = "hosts" class="form-group">

        </div>
        <div class="form-group">
           <button type="button" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
      </form>

    <table id = "table_info" class="table table-striped" style="margin-top: 10px">

      </table>
       <div id = "addRule" style = "display:none;">
       <div id = "add" style = "width:400px;height:460px;margin-left:13%;">
            <div id = "add_title">
                <label>发送信息</label>
                <i onclick = "return close_mea()" class="fa fa-window-close"></i>
            </div>
                <div class = "addForm col-xs-12" style = "margin-top:5%;">
                        <label id = "t_label" class = "col-xs-3 " style = "padding:0;line-height:27px;">手机号：</label>
                        <input  class = "col-xs-5" style = "height:26px;padding:0;margin-left:-25px;" id="telephone" name="telephone" type="text"/>
                        <span id = "al3" class = "al col-xs-4" style = "color:red;display:none;padding:0;line-height:27px;margin-left:13px;">*手机号为空！</span>
                </div>
                 <div class = "addForm col-xs-12">
                        <label class = "col-xs-3" style = "padding:0;line-height:27px;">详细信息：</label>
                        <textarea cols="4" id = "mea" name = "rule_explain" rows="4" readonly="readonly">
                       </textarea>
                </div>
                 <div class = "addForm col-xs-12">
                        <label class = "col-xs-3" style = "padding:0;line-height:27px;">备注信息：</label>
                        <textarea cols="4" id = "bei" name = "rule_explain" rows="3">
                       </textarea>
                </div>
                <div class = "addForm">
                    <button id = "bnt" value = "add" onclick = "return short_message();" style = "height:33px;width:77px;margin-right:20%;" class="btn btn-primary pull-right">发送</button>
                </div>
            </div>
       </div>
       </div>
  </div>
    </div>
  </div>
  <input id = "list1"  type="hidden" value = "{{list}}"/>
</section>

<script type="text/javascript">
var listData = JSON.parse($("#list1").val());
  $(document).ready(function(){
    getList(1,0,1);
    addTable(JSON.parse($("#list1").val()));
   dragPanelMove("#add_title","#addRule");
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

function addTable(data){
     var tbody=window.document.getElementById('table_info');
     	var str = '<tr>'+
          '<th>序号</th>'+
          '<th>服务</th>'+
          '<th>主机</th>'+
          '<th>产生时间</th>'+
          '<th>级别</th>'+
          '<th style = "width:50%">详细日志</th>'+
          '<th>操作</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
            var a = i+1;
            str = str +'<tr>'+
          '<td>'+a+'</th>'+
          '<td>'+data[i].service_name+'</th>'+
          '<td>'+data[i].host_name+'</td>'+
          '<td>'+data[i].info_date+'</th>'+
          '<td>'+data[i].level_name+'</th>'+
          '<td><span class = "t_log name'+i+'">'+data[i].info+'</span></th>'+
          '<td><a onclick = "return open_mea('+i+');" target="_blank" class="btn btn-primary btn-xs">发送通知</a></td>'
        '</tr>';
          }
          tbody.innerHTML = str;
}

function short_message(){
     var phone = $("#telephone").val();
     var meassage ='\n'+ $("#mea").val();
      var bei = trim($("#bei").val());
      if (bei.length>0){
        meassage = meassage+'；\n备注：'+bei+'。';
      }else{
        meassage = meassage+'。';
      }
    if(isPhoneNumber(phone) == false){
         $('#al3').css("display","block");
         $('#al3').html("*手机号码错误！");
         return;
    }
    var data={"phone":phone,"meassage":meassage};
    $.ajax({
               type: 'POST',
               url:"/shortMeassage/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   if(data.state == '1'){
                     close_mea();
                     alert(data.info);
                   }else{
                     alert(data.info);
                   }
               }
           });
}

function showBy(){
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        level = $("#errSelect").val(),
        systems = $("#sysSelect").val(),
        hosts = $("#hostSelect").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","level":level>0?level:"0","systems":systems>0?systems:"0","hosts":hosts>0?hosts:"0"};
    $.ajax({
               type: 'POST',
               url:"/warningQueryBy/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   listData = JSON.parse(data);
                   addTable(JSON.parse(data));
               }
           });
}
var siz = '';
function open_mea(a){
    siz = a;
    $(".t_log").attr('id','');
    var cl = '.name'+a;
    $(cl).attr('id','log1');
     var str = '主机：'+listData[a].host_name+'；\n'+'服务：'+listData[a].service_name+'；\n'+'异常时间：'+listData[a].info_date+'；\n'+'异常：'+listData[a].level_name+'；\n'+'日志信息：'+listData[a].info;
     $("#addRule").css("display","block");
     $("#mea").val(str);
}
function close_mea(){
     $("#addRule").css("display","none");
     $("#mea").val("");
     $("#bei").val("");
     $("#telephone").val("");
     $('#al3').css("display","none");
     $('#al3').html("*手机号为空！");
     $(".t_log").attr('id','');
     $("#addRule").css("top","14%");
     $("#addRule").css("left","38%");
}
</script>
