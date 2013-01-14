<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="sources/temp/hotcat/categories.xslt"/>
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:include href="sources/temp/hotcat/categories.xslt"/>
	<xsl:include href="sources/temp/standart/forum.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/standart/classify.xslt"/>
    <xsl:template match="/">
	<!-- ****************** -->

		<xsl:variable name="current" select="/out//object"/>
		
		
		<xsl:apply-templates select="$current/categories" mode="collapse">
			<xsl:with-param name="obj" select="$current"/>
		</xsl:apply-templates>
		
	</xsl:template>
</xsl:stylesheet>