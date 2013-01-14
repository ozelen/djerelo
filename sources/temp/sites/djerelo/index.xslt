<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/news.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
    <xsl:template match="/">
		<html>
			<head>
				<title>Djerelo.Info &amp;mdash; Tourist web projects</title>
				<link href="/css/ui/default/jquery-ui-1.8.10.custom.css" rel="stylesheet" type="text/css" />
				<script type="text/javascript" src="/js/jquery/jquery-1.4.4.min.js"></script>
				<script type="text/javascript" src="/js/jquery/jquery-ui-1.8.10.custom.min.js"></script>
			</head>
			<body style="background:url(/img/iface/djerelo/bg.png) repeat-x #031643; font-family:'Lucida Sans Unicode', 'Lucida Grande', sans-serif">
				<div style="width:800px; min-height:450px; background:#fff; margin:auto; margin-top:100px" class="ui-corner-all">
					<div style="float:right; margin:10px">
						<a href="/">ua</a> | <a href="/ru/">ru</a> | <a href="/en/">en</a>
					</div>
					<div style="width:230px; height:318px; background:url(/img/iface/djerelo/logo.png); margin:auto; position:relative; top:96px"></div>
					<div style="height:26px; background:#e8f2fa; width:550px; float:left"></div>
					<div style="background:url(/img/iface/djerelo/arrow.png); width:12px; height:26px; float:left"></div>
					<div style="background:url(/img/iface/djerelo/djerelo.png); width:135px; height:26px; margin:0 5px; float:left"></div>
					<div style="height:26px; background:#e8f2fa; width:80px; float:right"></div>
					<div style="background:url(/img/iface/djerelo/bckarrow.png); width:13px; height:26px; float:right"></div>
					<div style="margin-left:570px; padding-top:20px; font-size:13px">Tourist Web Projects</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>