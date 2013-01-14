function test(){alert("Scripts working");}



	$(document).ready(function() {
		$("a.zoom").fancybox();
	
		$("a.zoom1").fancybox({
			'overlayOpacity'	:	0.7,
			'overlayColor'		:	'#FFF'
		});
	
		$("a.zoom2").fancybox();
	});

	/*
		$("a.zoom2").fancybox({
			'zoomSpeedIn'		:	500,
			'zoomSpeedOut'		:	500
		});
	*/
$(".ajlink").live("click", function(){
	alert($(this).attr('class'));
	//$("a.zoom").fancybox();
	//$("a.zoom1").fancybox();
	//$("a.zoom2").fancybox();
});
