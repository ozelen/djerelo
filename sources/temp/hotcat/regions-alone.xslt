<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/hotcat/lib/regions.xslt"/>
    <xsl:template match="/">
		<xsl:apply-templates select="//regions"/>
	</xsl:template>
</xsl:stylesheet>