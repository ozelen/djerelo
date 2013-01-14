<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../sources/temp/hotcat/prices.xslt"/>
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="out"/>
	</xsl:template>
	
	<xsl:template match="out">
		<!--<textarea><xsl:copy-of select="."/></textarea>-->
		<xsl:variable name="catid" select="//categories/@cat"/>
		<xsl:call-template name="pricetable">
			<xsl:with-param name="periods" 	select="//object/categories/periods"/>
			<xsl:with-param name="catid" select="$catid"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="out[@mode='totalperiod']">
		<xsl:variable name="catid" select="//categories/@cat"/>
		<xsl:call-template name="pricetable-totalperiod">
			<xsl:with-param name="periods" 	select="//object/categories/periods"/>
			<xsl:with-param name="catid" select="$catid"/>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>