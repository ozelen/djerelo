<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//c[@id=/cout/@id]"/>
	</xsl:template>
	<xsl:template match="val">
		<b><xsl:value-of select="//values/val[@id=current()/@id]"/></b>
	</xsl:template>
	<xsl:template match="link">
		<a>
			<xsl:attribute name="href"><xsl:apply-templates select="href"/></xsl:attribute>
			<xsl:value-of select="text"/>
		</a>
	</xsl:template>
	<xsl:template match="br"><br/></xsl:template>
	<xsl:template match="hr"><hr/></xsl:template>
</xsl:stylesheet>
