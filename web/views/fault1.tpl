%rebase base
<section class="content container-fluid">
  <div class="box box-primary">
  	<div class="box-header">
      <h3 class="box-title">系统故障TopN</h3>
    </div>
    <div class="box-body">
      <form role="form" method="post" action="/report/1" class="form-inline">
        <div class="form-group">
          <label>开始日期:</label>
          <input id="startdate" name="startdate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'enddate\')}'})"/>
        </div>
        <div class="form-group">
          <label>结束日期:</label>
          <input id="enddate" name="enddate" type="text" onClick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startdate\')}'})"/>
        </div>
        <div id = "level" class="form-group">
             <label>故障级别:</label>
            <select id = "errSelect" style = "height:26px;width:78px;">
                <option value = "0">请选择</option>
                <option value = "1">一级故障</option>
                <option value = "2">二级故障</option>
                <option value = "3">三级故障</option>
                <option value = "4">四级故障</option>
            </select>
        </div>
        <div id = "hosts" class="form-group">
        </div>
        <div class="form-group">
          <button type="button" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
      </form>

      <div id="show" class="show"></div>

      <div id = "log_table" style="display:none">
           <div class = "log_top" style = "width:100%">
                <div id = "log_type"></div>
                <div class = "log_close">
                    <i onclick = "return clickGet();" class="fa fa-window-close"></i>
                </div>
           </div>
           <div id="show_table"></div>
      </div>
      <table id = "table_code" class="table table-striped" style="margin-top: 16px">
      </table>
    </div>
  </div>
    <input id = "list1"  type="hidden" value = "{{list}}"/>
</section>

<script type="text/javascript">
  $(document).ready(function(){
 	getList(0,0,1);
  	show(JSON.parse($("#list1").val()));
  	addTable(JSON.parse($("#list1").val()))
});

function addTable(data){
     var tbody=window.document.getElementById('table_code');
     	var str = '<tr>'+
          '<th>序号</th>'+
          '<th>故障类型</th>'+
          '<th>故障条数</th>'+
          '<th>开始日期</th>'+
          '<th>结束日期</th>'+
        '</tr>';
        for(var i=0; i < data.length ; i++){
            var a = i+1;
            str = str +'<tr>'+
          '<th>'+a+'</th>'+
          '<th><span class ="type_l'+a+' et">'+data[i].failure_type+'</span></th>'+
          '<td><a onclick = "return showByType(this.id)" id = "type_l'+a+'" target="_blank" class="btn btn-primary btn-xs">'+data[i].cou+'</a></td>'+
          '<input id = "vtype_l'+a+'"  type="hidden" value = "'+data[i].failure_type+'"/>'+
          '<th>'+data[i].minDate+'</th>'+
          '<th>'+data[i].maxDate+'</th>'+
        '</tr>';
          }
          tbody.innerHTML = str;
}

function showBy(){
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        level = $("#errSelect").val(),
        hosts = $("#hostSelect").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","level":level>0?level:"0","hosts":hosts>0?hosts:"0"};
    $.ajax({
               type: 'POST',
               url:"/faultBy/1",
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
    var cl = "#v"+value;
    var cl2 = "."+value;
    $('.et').attr('id','');
    $(cl2).attr('id','log1');
    var failure_type =  $(cl).val();
    $("#log_type").html('<p style = "margin-left:10px">'+failure_type+'</p>');
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        level = $("#errSelect").val(),
        systems = $("#sysSelect").val(),
        hosts = $("#hostSelect").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","level":level>0?level:"0","systems":systems>0?systems:"0","hosts":hosts>0?hosts:"0","failure_type":failure_type};
    $.ajax({
               type: 'POST',
               url:"/faultByType/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   var ps = new PerfectScrollbar('#show_table');
                   addTable_log(JSON.parse(data));
               }
           });
}

function addTable_log(data){
     var dj = ['','一级故障','二级故障','三级故障','四级故障'];
     var tbody=window.document.getElementById('show_table');
     	var str = '<table id = "table_log" class="table table-striped" style = "font-size:9pt;">'+
     	  '<tr>'+
     	  '<th>#</th>'+
          '<th>时间</th>'+
          '<th>故障等级</th>'+
          '<th>主机</th>'+
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
          '<th>'+data[i].failure_date+'</th>'+
          '<td>'+dj[data[i].level_id]+'</td>'+
          '<th>'+data[i].host_name+'</th>'+
           '<th>'+data[i].log+'</th>'+
        '</tr>';
          }
          str = str +'</table>';
          tbody.innerHTML = str;
}

function clickGet(){
       $("#log_table").css('display','none');
       $('.et').attr('id','');
}



function show(data){
    var f = false;
  if(data.length>0){
     f = true;
  }
	console.log($("#show").length);
  var xAxisData = [];
  var legendData= ['系统故障TOP'];
  var title = "";
  var metaDate = [];
  var d = [];
  for(var i=0; i < data.length ; i++){
    xAxisData.push(data[i].failure_type);
    d.push(data[i].cou);
  }
  metaDate.push(d);
  showChart(metaDate,f,legendData,xAxisData,title,'bar','show');

}
</script>