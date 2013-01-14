<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		
		<script>location.href = '/sources/docs/<xsl:value-of select="//uri-vars/identobj" />.pdf'</script>
	</xsl:template>
</xsl:stylesheet>