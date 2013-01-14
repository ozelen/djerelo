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
		
			<div class="ui-corner-all widget-header" style="height:18px; margin-bottom:2px">
				<h1 style="float:left">Карта Драгобрата</h1>
				<div style="float:right"><a href="http://skiworld.org.ua/">Отдых в Карпатах</a></div>
			</div>
			
			<div style="height:481; background:url(/img/iface/dragobrat/map.png)"></div>
			
			<div style="clear:both; height:10px"></div>
		
			<div id="wrapper">
			
			<div id="content" style="width:485px; margin-left:473px; clear:both">
<inject id="adsense-468x60"></inject>
		<div class="ui-corner-all widget-header"><h1>Карта Драгобрата On-Line</h1></div>
		<div id="viewport" style="height: 350px;" class="ui-corner-all">
		  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
		  	<input type="hidden" id="lat" value="48.248184012736445"/>
			<input type="hidden" id="lng" value="24.243949223656294"/>
			<input type="hidden" id="zoom" value="16"/>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/services/address.js"></script> 
			<script type="text/javascript" src="/js/visicom/settings.js"></script>
		</div>

				</div>
			</div>
			<div id="navigation" style="width:470px">
<inject id="adsense-468x60"></inject>
				<xsl:apply-templates select="//settlements"/>
				<xsl:apply-templates select="//block/content/menu[.='mainmenu']"/>
<inject id="adsense-468x60"></inject>

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