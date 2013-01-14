<!DOCTYPE html>
<html>
	<head>
		<title>Slideshow</title>

		<script src="jquery.js" ></script>
		<script src="cycle.js" ></script>

		<script>
			
		$(document).ready(function() {
			$('.slideshow').cycle({
				fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
			});
		});


		</script>
	</head>
	<body style="margin:0">
		<a href="http://deltakarpat.com/?module=fncatalogue&showitem=14" target="_blank">
			<div class="slideshow" style="position:inline; float:left">
				<img src="img/1.jpg" width="960" height="110" />
				<img src="img/2.jpg" width="960" height="110" />
				<img src="img/3.jpg" width="960" height="110" />
			</div>
		</a>
	</body>
</html>