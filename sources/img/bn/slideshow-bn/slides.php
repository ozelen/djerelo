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
	<body>
		<a href="http://google.com/" target="_blank">
			<div class="slideshow" style="position:inline; float:left">
				<img src="pic/1.jpg" width="960" height="110" />
				<img src="pic/2.jpg" width="960" height="110" />
				<img src="pic/3.jpg" width="960" height="110" />
			</div>
		</a>
	</body>
</html>