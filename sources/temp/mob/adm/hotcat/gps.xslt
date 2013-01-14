<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<script src="http://localhost:12175/javascript/GpsGate.js"></script>
				<script src="/js/mob/gps.js"></script> 
			</head>
			<body>
				<h1>GPS</h1>
<![CDATA[
<b>GpsGate "GPS in browser" demo</b><br> 
Make sure GpsGate is installed and started. Then click "GPS info".<br><br><div id="position"></div> 
<br><br><div id="time"></div> 
<br><br><form name="f1"><input value="GPS info" type="button" onclick="JavaScript:GpsGate.Client.getGpsInfo(CallbackMessage)" id="button1" name="button1"></form> 


]]>			
</body>
		</html>
	</xsl:template>
</xsl:stylesheet>