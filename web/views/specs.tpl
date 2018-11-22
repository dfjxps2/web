%rebase base
<section class="content container-fluid">
  <div class="box box-primary">
  	<div class="box-header">
      <h3 class="box-title">合规性TopN</h3>
    </div>
    <div class="box-body">
      <form role="form" method="post" class="form-inline">
        <div class="form-group">
          <label>开始日期:</label>
          <input value = "{{stateDate}}" id="startdate" name="startdate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'enddate\')}'})"/>
        </div>
        <div class="form-group">
          <label>结束日期:</label>
          <input  value = "{{endDate}}" id="enddate" name="enddate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startdate\')}'})"/>
        </div>
        <div id = "level" class="form-group">

        </div>
        <div id = "system" class="form-group">

        </div>
        <div id = "hosts" class="form-group">

        </div>
        <div class="form-group">
            <button id = "btn" type="button" value = "1" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
      </form>

      <div id="show" class="show">
      </div>

      <table id = "table_code" class="table table-striped" style="margin-top: 20px">
      </table>
      <div id = "log_table" style="display:none">
           <div class = "log_top">
                <div id = "log_type"></div>
                <div class = "log_close">
                    <i onclick = "return clickGet();" class="fa fa-window-close"></i>
                </div>
           </div>
           <div id="show_table"></div>
      </div>
    </div>
  </div>
  <input id = "list1"  type="hidden" value = "{{list}}"/>
  <input id = "error_type"  type="hidden" value = ""/>
</section>

<script type="text/javascript">
  $(document).ready(function(){
    getList(1,1,1);
  	show(JSON.parse($("#list1").val()));
  	addTable(JSON.parse($("#list1").val()));
});



function addTable(data){
     var tbody=window.document.getElementById('table_code');
     	var str = '<tr>'+
          '<th>序号</th>'+
          '<th>异常类型</th>'+
          '<th>异常条数</th>'+
          '<th>开始日期</th>'+
          '<th>结束日期</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
            var a = i+1;
            str = str +'<tr>'+
          '<th>'+a+'</th>'+
          '<th><span class ="'+data[i].error_type+' et">'+data[i].error_type+'</span></th>'+
          '<td><a onclick = "return showByType(this.id)" id = "'+data[i].error_type+'" target="_blank" class="btn btn-primary btn-xs ">'+data[i].cou+'</a></td>'+
          '<th>'+data[i].minDate+'</th>'+
          '<th>'+data[i].maxDate+'</th>'+
        '</tr>';
          }
          tbody.innerHTML = str;
}

function clickGet(){
       $("#log_table").css('display','none');
       $('.et').attr('id','');
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
               url:"/codeBy/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   show(JSON.parse(data));
                   clickGet();
                   addTable(JSON.parse(data));
               }
           });
}

function showByType(value){
    $("#log_table").css('display','');
    $("#log_type").html('<p style = "margin-left:10px">'+value+'</p>');
    var cl = "."+value;
    $('.et').attr('id','');
    $(cl).attr('id','log1');
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        level = $("#errSelect").val(),
        systems = $("#sysSelect").val(),
        hosts = $("#hostSelect").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","level":level>0?level:"0","systems":systems>0?systems:"0","hosts":hosts>0?hosts:"0","error_type":value};
    $.ajax({
               type: 'POST',
               url:"/codeByType/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   var ps = new PerfectScrollbar('#show_table');
                   addTable_log(JSON.parse(data));
               }
           });
}

function addTable_log(data){
     var tbody=window.document.getElementById('show_table');
     	var str = '<table id = "table_log" class="table table-striped" style = "font-size:9pt;">'+
     	  '<tr>'+
     	  '<th>#</th>'+
          '<th>时间</th>'+
          '<th>系统</th>'+
          '<th>主机</th>'+
          '<th>异常类型</th>'+
          '<th style = "width:65%;">详细信息</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
          var a = i+1;
          if(i%2 == 0){
            str = str +'<tr style = "background-color:#cadef9">';
          }else {
            str = str +'<tr>';
          }
           str = str +'<th>'+a+'</th>'+
          '<th>'+data[i].error_date+'</th>'+
          '<td>'+data[i].sys_name+'</td>'+
          '<th>'+data[i].host_name+'</th>'+
          '<th>'+data[i].level_name+'</th>'+
           '<th>'+data[i].logs+'</th>'+
        '</tr>';
          }
          str = str +'</table>';
          tbody.innerHTML = str;
}

function show(data){
      var f = false;
  if(data.length>0){
     f = true;
  }
    console.log($("#show").length);
  var xAxisData = [];
  var legendData= ['代码异常TOP'];
  var title = "";
  var metaDate = []
  var d = [];
  for(var i=0; i < data.length ; i++){
    xAxisData.push(data[i].error_type);
    d.push(data[i].cou);
  }
  metaDate.push(d);
  showChart(metaDate,f,legendData,xAxisData,title,'bar','show');
}
</script>