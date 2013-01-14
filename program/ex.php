<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>WYMeditor</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.1.min.js"></script>
<script type="text/javascript" src="wymeditor/jquery.wymeditor.pack.js"></script>
<script type="text/javascript">

jQuery(function() {
    jQuery(".wymeditor").wymeditor({
       html: '<p>Hello, World!<\/p>',
       stylesheet: 'styles.css'
    });
	
	$('form.ajax').live('submit',
		function(){
			//alert($(this).attr('action'));
			var form_data = {one: 1, two:2};
			var current = $(this);
			$.post(
				//type: 		(current.attr('method')),
				current.attr('action'),
				form_data,
				function(html){
					alert(current.attr('action'));
					$('#'+current.attr('target')).html(text);
				},
				'html'
			);
			
			return false;
		}
	);
});



</script>
</head>

<body>
<form class="ajax" method="POST" action="http://skiworld.org.ua/program/text.php" target="outDiv">
	<textarea class="wymeditor"></textarea>
	<input type="submit" class="wymupdate" />
</form>

<div id="outDiv">
	abcd
</div>


</body>

</html>
