<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/forum.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
    <xsl:template match="/">

	<!-- ****************** -->
		<xsl:variable name="current" select="//city[ident=//presets/uri-vars/identcity]"/>
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="{/out/home}/{$lang}/goto/{$current/ident}"><xsl:value-of select="$current/name"/></a>
								<ul>
									<li> <b><xsl:value-of select="//locale/c[@id='forum.header-sm']"/></b></li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/>, <xsl:value-of select="//locale/c[@id='forum.header-sm']"/></xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
	<!-- ****************** -->	
	
		<xsl:apply-templates select="$current" mode="currentView"/>
			
		<xsl:call-template name="DocumentFullFooter"/>

	</xsl:template>
	<xsl:template match="city" mode="currentView">

			<div id="wrapper">
				<div id="content_sub" style="margin-left:0px">
					<div class="mainTextArea">
						<div id="dbg" style="display:none"></div>
						<h1><xsl:value-of select="name"/>, <xsl:value-of select="//locale/c[@id='forum.header-sm']"/></h1>

						<xsl:apply-templates select="//topic"/>

					</div>
				</div>
			</div>

			<div id="extra_sub">
				<h2>
					<xsl:value-of select="name"/>&amp;nbsp;<xsl:value-of select="//locale/c[@id='hotcat.city.map']"/>: <!-- CAPTION: Map -->
				</h2>
				
				
				
				<div class="rounded-box-3">
						<b class="r3"></b><b class="r1"></b><b class="r1"></b>
						<div class="inner-box">
							

						<div id="viewport" style="width: 310px; height: 320px;">
						  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
							<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
							<script type="text/javascript" src="/js/visicom/settings.js"></script>
						</div>
							
							
							<xsl:apply-templates select="location"/>
							
						</div>
						<b class="r1"></b><b class="r1"></b><b class="r3"></b>
				</div>
				
				

				
			</div>
			


	</xsl:template>
	

	


	
</xsl:stylesheet>