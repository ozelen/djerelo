<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/news.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
    <xsl:template match="/">

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">
				<xsl:value-of select="//current/page/title"/>
			</xsl:with-param>
		</xsl:call-template>
			<div id="wrapper">
				<div id="content" style="width:550px; margin-left:405px">

<div class="ui-corner-all widget-header"><h1>Карта Яремче On-Line</h1></div>

		<div id="viewport" style="height: 350px;">
		  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
		  	<input type="hidden" id="lat" value="48.4483054528054"/>
			<input type="hidden" id="lng" value="24.5525534628941"/>
			<input type="hidden" id="zoom" value="14"/>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/services/address.js"></script> 
			<script type="text/javascript" src="/js/visicom/settings.js"></script>
		</div>


<inject id="seotext-{/out/@lang}"></inject>
					<!-- TPL: NEWSBLOCK -->
					<div class="ui-corner-all widget-header"><xsl:value-of select="//locale/c[@id='standarts.news']"/></div>
					<xsl:apply-templates select="//items[@type='news']" mode="list"/>
					<div style="text-align:right"><a href="/{//presets/lang}/news/archive/"><xsl:value-of select="//locale/c[@id='standarts.news.archive']"/></a></div>
					<br />

				</div>
			</div>
			<div id="navigation" style="width:400px">
				<xsl:apply-templates select="//settlements"/>
<inject id="adsense-336x280"></inject>
				<xsl:apply-templates select="//block/content/menu[.='mainmenu']"/>
			</div>
			
		<xsl:call-template name="DocumentFullFooter"/>
				
	</xsl:template>
	
	<xsl:template match="sections">
		<ul class="ul_accord">
			<xsl:apply-templates select="section[article]"/>
		</ul>
	</xsl:template>
	<xsl:template match="section">
		<li class="li_accord">
			<div class="hdr" style="padding:5px 0"><a href="/{//presets/lang}/papers/{@id}/" class="dropdown"><xsl:value-of select="name"/></a></div>
			<div style="display:none" class="hdzone">
				<ul>
					<xsl:for-each select="article">
						<li><a href="/{//presets/lang}/papers/show/{@id}/"><xsl:value-of select="name"/></a></li>
					</xsl:for-each>
				</ul>
			</div>
		</li>
	</xsl:template>
</xsl:stylesheet>