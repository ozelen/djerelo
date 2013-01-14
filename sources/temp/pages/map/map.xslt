<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="cur" 	select="/out/current/page"/>
		<xsl:variable name="blocks"	select="$cur/blocks"/>
	<!-- ****************** -->
		<xsl:variable name="lang" select="//presets/lang"/>

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title" select="$cur/title" />
			<xsl:with-param name="navigation">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li>
								<xsl:with-param name="title" select="$cur/title"/>
							</li>
						</ul>
					</li>
				</ul>
			</xsl:with-param>
		</xsl:call-template>


	<!-- ****************** -->

				<div  style="height: 20px; float:left">
					<div class="ui-corner-all widget-header"><h1><xsl:value-of select="//locale/c[@id='standarts.map.karp']"/></h1></div>
					<div id="viewport" style="height: 500px; margin-top:5px">
					  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
						<input type="hidden" id="lng" value="{23.87556391078998}"/>
						<input type="hidden" id="lat" value="{48.36617293951964}"/>
						<input type="hidden" id="zoom" value="8"/>
						<input type="hidden" id="marker" value="false"/>
						<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
						<script type="text/javascript" src="/js/visicom/settings.js"></script>
					</div>
				</div>
		


	</xsl:template>
</xsl:stylesheet>