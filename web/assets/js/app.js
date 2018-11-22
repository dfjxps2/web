$(document).ready(function(){
	var a, uri = location.pathname;
	$(".sidebar-menu a").each(function(i){
		if($(this).attr("href").indexOf(uri)==0){
			a = $(this);
			return true;
		}
	});
	if(a){
		$(".sidebar-menu").filter(".menu-open").removeClass("menu-open");
	  $(".sidebar-menu").filter(".active").removeClass("active");
	  a.parent().addClass("active");
	  a.parent().parent().parent().addClass("active").addClass("menu-open");
	}
});