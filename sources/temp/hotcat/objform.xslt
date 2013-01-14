<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/hotcat/lib/objects.xslt"/>
	<xsl:template match="/">
	<h3>Create new Object</h3>
		<div style="width:300px; padding:10px 5px; margin:0 auto">
			<div class="ui-widget-header ui-corner-all" style="padding:5px; margin:2px 0">Step 1: Base Information</div>
			<div class="ui-widget-content ui-corner-all" style="padding:5px" align="center">
				<form action="/ua/admin/objects/add/postdata/" class="ajax" target="objlist">
					<table width="100%">
						<tr>
							<td width="20%">Name</td>
							<td><input name="Name" style="width:100%"/></td>
						</tr>
						<tr>
							<td>Ident</td>
							<td><input name="Ident" style="width:100%"/></td>
						</tr>
						<tr>
							<td>E-mail</td>
							<td><input name="Email" style="width:100%"/></td>
						</tr>
						<tr>
							<td></td>
							<td>
								<button ico2="ui-icon-arrowthick-1-e">Next Step</button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div style="float:right; margin:5px 0">Step 1 from 6</div>
		</div>
	</xsl:template>
</xsl:stylesheet>