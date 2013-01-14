<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/news.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
    <xsl:template match="/">

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">
				Крым, отдых в Крыму
			</xsl:with-param>
		</xsl:call-template>
			<div style="height:380px">

				<div  style="width: 960px; height: 20px; float:left">
					<xsl:call-template name="blk">
						<xsl:with-param name="header" select="//locale/c[@id='standarts.map.karp']"/>
					</xsl:call-template>
					
					<div id="viewport" style="height: 350px; margin-top:5px">
					  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
						<input type="hidden" id="lng" value="{34.33557820459289"/>
						<input type="hidden" id="lat" value="{44.93418347681625}"/>
						<input type="hidden" id="zoom" value="6"/>
						<input type="hidden" id="marker" value="false"/>
						<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
						<script type="text/javascript" src="/js/visicom/settings.js"></script>
					</div>
					
				</div>
			
			</div>
			<div id="wrapper">
				<div id="content" style="width:550px; margin-left:405px">
					<div style="width:0px; height:500px; float:left"></div>
						
					<!-- TPL: NEWSBLOCK -->
					<xsl:call-template name="blk">
						<xsl:with-param name="header" select="//locale/c[@id='standarts.news']"/>
					</xsl:call-template>
					<xsl:apply-templates select="//items[@type='news']" mode="list"/>
					<div style="text-align:right"><a href="/{//presets/lang}/news/archive/"><xsl:value-of select="//locale/c[@id='standarts.news.archive']"/></a></div>
					<br />

				</div>
			</div>
			<div id="navigation" style="width:400px">
				<xsl:call-template name="blk">
					<xsl:with-param name="header" select="/out/current/page/blocks/block/content/conceptions/name"/>
				</xsl:call-template>
                <div style="padding:0px 40px">
                	<xsl:apply-templates select="//banners/banner[@id=3]"/>
                </div>
				<xsl:apply-templates select="/out/current/page/blocks/block/content/conceptions" mode="accordion"/>
				<div style="height:10px"></div>
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