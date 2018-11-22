%rebase base

<script>
var route = {
	"oper":"http://59.212.146.123:5601/app/kibana#/discover/5bfeaf30-8f0b-11e8-8049-372e963276b5?_g=(refreshInterval:('$$hashKey':'object:433',display:'5%20seconds',pause:!f,section:1,value:5000),time:(from:now-24h,mode:quick,to:now))&_a=(columns:!(host,'@log'),filters:!(),index:sys_log,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"mysql":"http://59.212.146.123:5601/app/kibana#/discover/ed03f3b0-93ab-11e8-8aa3-c7a11d37d157?_g=(refreshInterval:('$$hashKey':'object:642',display:'1%20minute',pause:!f,section:2,value:60000),time:(from:now-30d,mode:quick,to:now))&_a=(columns:!(host,'@log'),filters:!(),index:mysql,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"redis":"http://59.212.146.123:5601/app/kibana#/discover/5bfeaf30-8f0b-11e8-8049-372e963276b5?_g=(refreshInterval:('$$hashKey':'object:642',display:'1%20minute',pause:!f,section:2,value:60000),time:(from:now-30d,mode:quick,to:now))&_a=(columns:!(host,'@log'),filters:!(),index:redis,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"service":"http://59.212.146.123:5601/app/kibana#/discover/5bfeaf30-8f0b-11e8-8049-372e963276b5?_g=(refreshInterval:('$$hashKey':'object:11171',display:'1%20minute',pause:!f,section:2,value:60000),time:(from:now%2Fy,mode:quick,to:now%2Fy))&_a=(columns:!(service,host,level,'@log'),filters:!(),index:service,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"app":"http://59.212.146.123:5601/app/kibana#/discover/4abdeec0-94ab-11e8-b80f-d50b4170f2a2?_g=(refreshInterval:('$$hashKey':'object:1797',display:'10%20seconds',pause:!f,section:1,value:10000),time:(from:now-15m,mode:quick,to:now))&_a=(columns:!(host,app,level,'@log'),filters:!(),index:app,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"platform":"http://59.212.146.123:5601/app/kibana#/discover/b8b50db0-9630-11e8-bae0-f7af3af0e4a1?_g=(refreshInterval:('$$hashKey':'object:1439',display:'1%20minute',pause:!f,section:2,value:60000),time:(from:now%2Fy,mode:quick,to:now%2Fy))&_a=(columns:!(platform,host,file,'@log'),filters:!(),index:platform,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc))",
	"login":"http://59.212.146.123:5601/app/kibana#/discover/5bfeaf30-8f0b-11e8-8049-372e963276b5?_g=(refreshInterval:('$$hashKey':'object:433',display:'5%20seconds',pause:!f,section:1,value:5000),time:(from:now-24h,mode:quick,to:now))&_a=(columns:!(host,'@log'),filters:!(),index:sys_log,interval:auto,query:(query_string:(analyze_wildcard:!t,query:sshd)),sort:!(timestamp,desc))",
	"biz":"http://59.212.146.123:5601/app/kibana#/discover/9eeb91c0-8108-11e8-9d05-9d6f8feabfa3?_g=(refreshInterval:('$$hashKey':'object:433',display:'5%20seconds',pause:!f,section:1,value:5000),time:(from:now-24h,mode:quick,to:now))&_a=(columns:!(host,uid,session,pwd,cmd),filters:!(),index:sys_op,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!(timestamp,desc),uiState:(vis:(legendOpen:!t)))"
};
var qt = '{{qt}}';
$(document).ready(function(){
	var p = $("#kb").parent();
	
	$("#kb").height(p.height()).width('100%').attr("src", route[qt]);
});
</script>
<!--<section class="content-header">
  <h1>
    
  </h1>
</section>-->

<section class="content container-fluid">
  <div style="overflow:auto;height:calc(100% - 55px);">
  	<iframe id="kb" width="1100" height="500" frameborder="0"></iframe>
  </div>
</section>

