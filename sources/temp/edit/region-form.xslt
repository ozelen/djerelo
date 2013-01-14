<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		<!-- It can be only one of them -->
		<xsl:apply-templates select="//form/region"/>
		<xsl:apply-templates select="//form/settlement"/>
	</xsl:template>
	
	<xsl:template match="region">
		<h1 style="margin:10px 0">
			<xsl:apply-templates select="page" mode="display">
				<xsl:with-param name="objid" select="@id"/>
				<xsl:with-param name="viewmode" select="'admin'"/>
				<xsl:with-param name="content" select="page/title"/>
				<xsl:with-param name="tbl" select="'Regions'"/>
				<xsl:with-param name="field">title</xsl:with-param>
			</xsl:apply-templates>
		</h1>
		<table width="100%">
			<tr>
				<td>Ident</td>
				<td><input name="Ident" type="text" style="width:100%" value="{ident}"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="settlement">
		<!--<textarea><xsl:copy-of select="."/></textarea>-->
		<h1 style="margin:10px 0">
			<xsl:apply-templates select="page" mode="display">
				<xsl:with-param name="objid" select="@id"/>
				<xsl:with-param name="viewmode" select="'admin'"/>
				<xsl:with-param name="content" select="page/title"/>
				<xsl:with-param name="tbl" select="'Settlements'"/>
				<xsl:with-param name="field">title</xsl:with-param>
			</xsl:apply-templates>
		</h1>
		<table width="100%">
			<tr>
				<td>Ident</td>
				<td><input name="Ident" type="text" style="width:100%" value="{ident}"/></td>
			</tr>
			<tr>
				<td width="100">Latitude</td>
				<td><input name="lat" type="text" style="width:100%" value="{location/lat}"/></td>
			</tr>
			<tr>
				<td width="100">Longtitude</td>
				<td><input name="lng" type="text" style="width:100%" value="{location/lng}"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="region[page/@id='-1']">
		<xsl:call-template name="multilang-form">
			<xsl:with-param name="element" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="settlement[page/@id='-1']">
		<!--<textarea><xsl:copy-of select="."/></textarea>-->
		<xsl:call-template name="multilang-form">
			<xsl:with-param name="element" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="multilang-form">
		<xsl:param name="element"/>
		<form class="ajax" action="{/out/presets/virtual-uri}" target="regwin">
		<input type="hidden" name="owner_tbl" value="{name($element)}"/>
		<input type="hidden" name="owner_id" value="{$element/@id}"/>
		<table width="100%">
			<tr>
				<td>Ident</td>
				<td><input name="Ident" type="text" style="width:100%" value="{$element/ident}"/></td>
			</tr>
			<tr>
				<td width="100">Ukrainian</td>
				<td><input name="content_Title_ua" type="text" style="width:100%"/></td>
			</tr>
			<tr>
				<td>Russian</td>
				<td><input name="content_Title_ru" type="text" style="width:100%" value="{$element/name}"/></td>
			</tr>
			<tr>
				<td>English</td>
				<td><input name="content_Title_en" type="text" style="width:100%"/></td>
			</tr>
			<tr>
				<td></td>
				<td><button ico="ui-icon-disk">Save</button></td>
			</tr>
		</table>
		
		</form>
	</xsl:template>
</xsl:stylesheet>