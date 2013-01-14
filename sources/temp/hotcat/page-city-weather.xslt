<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/forum.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:include href="sources/temp/hotcat/weather.xslt"/>
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
									<li> <b><xsl:value-of select="//locale/c[@id='hotcat.weather-5days']"/></b></li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/>, <xsl:value-of select="//locale/c[@id='hotcat.weather-5days']"/></xsl:with-param>
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
						<div id="dbg" style="display:none">debug</div>
						<h1><xsl:value-of select="name"/>, <xsl:value-of select="//locale/c[@id='hotcat.weather-5days']"/></h1>
						<br />

						<xsl:apply-templates select="//forecast[day]"/>

					</div>
				</div>
			</div>

			<div id="extra_sub">

				<!-- Banners -->
				<xsl:call-template name="subpage-bannerlist"><xsl:with-param name="inside">
						<!-- BANNER -->
						<xsl:call-template name="bn300x110"/>
						<div style="padding-top:20px"></div>
				</xsl:with-param></xsl:call-template>
				

				
			</div>
			


	</xsl:template>
	

	


	
</xsl:stylesheet>