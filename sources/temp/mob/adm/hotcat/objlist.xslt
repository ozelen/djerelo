<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			
			<head>
			
				<title>Djerelo Objects</title>
				<link href="/css/ui/default/jquery-ui-1.8.10.custom.css" rel="stylesheet" type="text/css" />
				<script type="text/javascript" src="/js/jquery/jquery-1.4.4.min.js"></script>
				<script type="text/javascript" src="/js/jquery/jquery-ui-1.8.10.custom.min.js"></script>
				<script src="/js/main.js"></script>
				
				<style>
					body{width:240px}
					div#container{ background:#fff;}
					body, table, input, select{font-family:arial; font-size:12px; padding:0px; margin:0px}
					h1, h2, h3, h4, h5 {margin:0px; padding:3px}
					h1{font-size:16px;}
				</style>
				
			</head>
			<body>
			
				<div id="container">
					<h1>Objects <a href="/ua/admin/objects/addform/" target="objlist" class="btn ajax" ico="ui-icon-plus">+</a></h1>
					<div id="geodata"></div>
					<div class="ui-widget-header ui-corner-all" style="padding:1px; margin:2px">
						<form class="ajax" target="objlist" action="/prg/editobj.php?mode=objtable" method="post" style="margin:0px">
						<input type="hidden" name="temp" value="mob/adm/hotcat/objlist-alone.xslt" />
						<table width="100%">
							<tr>
								<td colspan="2"><input id="keyword" name="keyword" style="width:100%;"/></td>
							</tr>
							<tr>
								<td width="150">
									<select name="searchin" style="width:100%">
										<option value="objname">by Object Name</option>
										<option value="settlement">by Settlement</option>
									</select>
								</td>
								<td><button style="width:100%">Find</button></td>
							</tr>
						</table>
						</form>
					</div>
					<div id="objlist" class="ui-widget-content ui-corner-all" style="margin:2px; padding:1px">
						<div style="text-align:center">Click "Search" button</div>
					</div>
				</div>
			
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>