<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:import href="../sources/temp/hotcat/gallery-controls.xslt"/>
	<xsl:import href="../sources/temp/standart/accessories.xslt"/>
    <xsl:template match="/">
		<xsl:apply-templates select="/album" mode="controls"/>
	</xsl:template>
</xsl:stylesheet>