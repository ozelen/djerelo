<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/documents/docs.xslt"/>
	<xsl:template match="/">
		<div id="adddocwin" title="Add Agreement"></div>
		<div class="ui-widget-header ui-corner-all" style="padding:5px">
			<table width="100%">
				<tr>
					<td><button ico="ui-icon-plus" onclick="winHref('opendocwin', '/ua/admin/agreements/obj/{//uri-vars/objid}/add/')">Add</button></td>
				</tr>
			</table>
		</div>
		<!--<textarea><xsl:copy-of select="/"/></textarea>-->
		<xsl:apply-templates select="//docs"/>
	</xsl:template>
</xsl:stylesheet>