<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="mini-gallery.xslt"/>
	<xsl:import href="gallery-controls.xslt"/>
	<xsl:import href="../standart/accessories.xslt"/>
    <xsl:template match="/">
		gals:
		<xsl:apply-templates select="//album" mode="controls"/>
	</xsl:template>
</xsl:stylesheet>