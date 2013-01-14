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
				Карпаты, отдых в Карпатах, погода в Карпатах. Горные лыжи. Горнолыжные курорты Карпаты
			</xsl:with-param>
		</xsl:call-template>
			<div style="height:380px">

				<div  style="width: 960px; height: 20px; float:left">
					<xsl:call-template name="blk">
						<xsl:with-param name="header" select="//locale/c[@id='standarts.map.karp']"/>
					</xsl:call-template>
					
					<div id="viewport" style="height: 350px; margin-top:5px">
					  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
						<input type="hidden" id="lng" value="{23.87556391078998}"/>
						<input type="hidden" id="lat" value="{48.36617293951964}"/>
						<input type="hidden" id="zoom" value="8"/>
						<input type="hidden" id="marker" value="false"/>
						<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
						<script type="text/javascript" src="/js/visicom/settings.js"></script>
					</div>
					
				</div>
			
			</div>
			<div id="wrapper">

<div style="width:600; float:left">				
<xsl:apply-templates select="//settlements"/>
</div>

<div style="width:350; float:right; padding:20px 0">
<inject id="adsense-336x280"></inject>
</div>

<div style="clear:both"></div>

					<!-- TPL: NEWSBLOCK -->
					<div class="ui-corner-all widget-header"><xsl:value-of select="//locale/c[@id='standarts.news']"/></div>
					<xsl:apply-templates select="//items[@type='news']" mode="blog"/>
					<div style="text-align:right"><a href="/{//presets/lang}/news/archive/"><xsl:value-of select="//locale/c[@id='standarts.news.archive']"/></a></div>
					<br />

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