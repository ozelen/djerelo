<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
    <xsl:template match="/">
		<xsl:call-template name="DocumentFullHeader"/>
			<xsl:apply-templates select="/out/current//categories/category[@id=//presets/uri-vars/catid]" mode="currentView"/>
		<xsl:call-template name="DocumentFullFooter"/>
	</xsl:template>
	<xsl:template match="category" mode="currentView">
			<div id="wrapper">
				<div id="content">

					Page category template1

				</div>
			</div>
			<div id="navigation">
			
			
			
			</div>
			<div id="extra">

			</div>
		

	</xsl:template>
</xsl:stylesheet>