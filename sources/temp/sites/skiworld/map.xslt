<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<!--<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>-->
    <xsl:template match="/">

		<xsl:variable name="cur" 	select="/out/current/page"/>
		<xsl:variable name="blocks"	select="$cur/blocks"/>

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title" select="$cur/title"/>
			<!--<xsl:with-param name="navigation" select="$nav"/>-->
		</xsl:call-template>

			<div id="wrapper">
				<div id="content" class="mainTextArea">
					<xsl:if test="not(submenu) and not($blocks/block[place='navigation'])">
						<xsl:attribute name="style">margin-left:0</xsl:attribute>
					</xsl:if>
					<h1 style="margin:0.5em 20px"><xsl:value-of select="$cur/title"/></h1>

					<div style="padding:0 20px">
						<xsl:apply-templates select="$blocks/block[place='content' ]">
						<xsl:sort select="range" data-type="number"/>
						</xsl:apply-templates>

					<div id="viewport" style="height: 500px; margin-top:5px">
					  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
						<input type="hidden" id="lng" value="{23.87556391078998}"/>
						<input type="hidden" id="lat" value="{48.36617293951964}"/>
						<input type="hidden" id="zoom" value="8"/>
						<input type="hidden" id="marker" value="false"/>
						<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
						<script type="text/javascript" src="/js/visicom/settings.js"></script>
					</div>

					<xsl:value-of select="$cur/source"/>

					</div>
				</div>
			</div>

			<xsl:if test="submenu or $blocks/block[place='navigation']">
				<div id="navigation">
					<div class="mainMenuList">
						<xsl:call-template name="submenu"/>
					</div>
					<xsl:apply-templates select="$blocks/block[place='navigation']">
						<xsl:sort select="range" data-type="number"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>


			<div id="extra">
				<xsl:apply-templates select="$blocks/block[place='extra']">
					<xsl:sort select="range" data-type="number"/>
				</xsl:apply-templates>
			</div>

	<xsl:call-template name="DocumentFullFooter"/>

	</xsl:template>
</xsl:stylesheet>