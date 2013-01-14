<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">

	</xsl:template>
	
	<xsl:template match="docs[@mode='agreements-total']">
		<div id="opendocwin" title="Edit Document"></div>
		<table width="100%" cellspacing="0" class="zebra">
			<tr>
				<td width="20">ID</td>
				<td width="50">Number</td>
				<td><span class="ui-icon ui-icon-home" style="float:left"></span>Object</td>
				<td><span class="ui-icon ui-icon-person" style="float:left"></span>FIO</td>
				<td width="50">Price</td>
				<td width="100"><span class="ui-icon ui-icon-calendar" style="float:left"></span>BeginDate</td>
				<td width="50"><span class="ui-icon ui-icon-document" style="float:left"></span>Expire</td>
				<td width="20" title="Bills"><span class="ui-icon ui-icon-document-b" style="float:left"></span></td>
				<td width="20" title="Status"><span class="ui-icon ui-icon-flag" style="float:left"></span></td>
			</tr>
			<xsl:apply-templates select="doc"/>
		</table>
	</xsl:template>
	
	<xsl:template match="docs[@mode='agreements-total']/doc">
		<tr id="doc_{@id}" style="cursor:pointer" onclick="$('.controls').fadeOut(); $(this).find('.controls').fadeIn();">
			<td width="30">
				<xsl:value-of select="@id"/>
				<div style="float:left">
					<ul class="icons ui-widget ui-helper-clearfix controls ui-state-default ui-corner-all" style="position:absolute; display:none; margin-top:1em">
						<li class="ui-widget-header ui-corner-all" onclick="winHref('opendocwin', '/ua/admin/agreements/{@id}/bills/')" style="margin-right:10px"><span class="ui-icon ui-icon-document-b"></span></li>
						<li class="ui-widget-header ui-corner-all" onclick="winHref('opendocwin', '/ua/admin/agreements/{@id}/')" title="Edit"><span class="ui-icon ui-icon-pencil"></span></li>
						<li class="ui-widget-header ui-corner-all" onclick="winHref('opendocwin', '/ua/admin/agreements/{@id}/prolong/')" title="Prolong"><span class="ui-icon ui-icon-copy"></span></li>
						<li class="ui-widget-header ui-corner-all" onclick="winHref('opendocwin', '/ua/admin/agreements/{@id}/csv/')" title="CSV"><span class="ui-icon ui-icon-print"></span></li>
						<li class="ui-widget-header ui-corner-all" onclick="if(confirm('Delete document {field[@id='Ser']} {field[@id='Number']}?'))$.post('/ua/admin/agreements/{@id}/delete/', function(data){{$('#doc_{@id}').remove()}})" title="Delete"><span class="ui-icon ui-icon-trash"></span></li>
					</ul>
				</div>
			</td>
			<td><xsl:value-of select="field[@id='Ser']"/>&amp;nbsp;<xsl:value-of select="field[@id='Number']"/></td>
			<td><xsl:value-of select="field[@id='ObjName']"/></td>
			<td><xsl:value-of select="field[@id='LastName']"/>&amp;nbsp;<xsl:value-of select="field[@id='FirstName']"/>&amp;nbsp;<xsl:value-of select="field[@id='Patronymic']"/></td>
			<td><xsl:value-of select="field[@id='Price']"/></td>
			<td><xsl:value-of select="field[@id='BeginDate']"/></td>
			<td><xsl:value-of select="field[@id='Expire']"/></td>
			<td><xsl:value-of select="field[@id='BillsCount']"/></td>
			<td>
				<xsl:value-of select="field[@id='Status']"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="docs">
		<table width="100%">
			<xsl:for-each select="doc">
				<tr>
					<xsl:for-each select="field">
						<td><xsl:value-of select="."/></td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>