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
		<xsl:variable name="cur" select="//current/page"/>
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">
				<xsl:value-of select="$cur/seo-title"/> &amp;mdash; Море, Крым, отдых на KrymTour.net
			</xsl:with-param>
		</xsl:call-template>
			<div style="height:350px">
					<div class="ui-corner-all widget-header"><h1><xsl:value-of select="//locale/c[@id='standarts.map.crimea']"/></h1></div>
					<div id="viewport" style="height: 320px; margin-top:5px">
					  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
						<input type="hidden" id="lng" value="34.33557820459289"/>
						<input type="hidden" id="lat" value="44.93418347681625"/>
						<input type="hidden" id="zoom" value="8"/>
						<input type="hidden" id="marker" value="false"/>
						<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
						<script type="text/javascript" src="/js/visicom/settings.js"></script>
					</div>




			</div>
			<div id="wrapper">
				<div id="content" style="width:640px;">
					<xsl:apply-templates select="//settlements"/>
						
						
					<!-- TPL: NEWSBLOCK -->
					<div class="ui-corner-all widget-header"><h1><xsl:value-of select="//locale/c[@id='standarts.news']"/></h1></div>

					<xsl:apply-templates select="//items[@type='news']" mode="blog"/>
					<a href="/{/out/@lang}/news/archive/{//items/@skip + 20}">&lt;&lt; <xsl:value-of select="//locale/c[@id='standarts.previous']"/> 20</a>
					<br />
					
					<div class="mainTextArea titext">
						<xsl:value-of select="//current/page/source"/>
					</div>
				</div>
			</div>
			<div style="float:left; width:315px; margin-left:-315px;">
				<xsl:apply-templates select="//block/content/menu[.='articles']"/>
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