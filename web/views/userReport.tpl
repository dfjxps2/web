%rebase base

<section class="content container-fluid">
  <div class="box box-primary">
  	<div class="box-header">
      <h3 class="box-title">用户活动报表</h3>
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
        <div id = "hosts" class="form-group">
        </div>
        <div class="form-group">
           <button type="button" onclick = "return showBy();" class="btn btn-primary pull-right">查询</button>
        </div>
      </form>

<div id="show" class="show"></div>

    </div>
  </div>
  <input id = "list1"  type="hidden" value = "{{list}}"/>
</section>

<script type="text/javascript">
  $(document).ready(function(){
  	getList(0,0,1);
  	show(JSON.parse($("#list1").val()));
});

function showBy(){
    var startDate = $("#startdate").val(),
        endDate = $("#enddate").val(),
        systems = $("#sysSelect").val(),
        hosts = $("#hostSelect").val();
    var data={"startDate":startDate.length>0?startDate:"0","endDate":endDate.length>0?endDate:"0","systems":systems>0?systems:"0","hosts":hosts>0?hosts:"0"};
    $.ajax({
               type: 'POST',
               url:"/userReportBy/1",
               data:data, //转化字符串
               contentType: 'json',
               success:function(data){ //成功的话，得到消息
                   show(JSON.parse(data));
               }
           });
}

function show(data){
	console.log($("#show").length);
  var xAxisData = [];
  var legendData= ['hive','etl','hdfs','root'];
  var title = "";
  var metaDate = [];
  var a=[],
  b = [],
  c = [];
   for(var i=0; i < data.length ; i++){
        xAxisData.push(data[i].activity_type);
        a.push(data[i].hive);
        b.push(data[i].etl);
        c.push(data[i].hdfs);
  }
  metaDate.push(a,b,c);
 showChart(metaDate,'true',legendData,xAxisData,title,'line','show');
}
</script>
