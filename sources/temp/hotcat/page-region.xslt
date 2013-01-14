<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/hotcat/lib/cities.xslt"/>
	<xsl:include href="sources/temp/hotcat/lib/objects.xslt"/>
	
    <xsl:template match="/">

	<!-- ****************** -->
		<xsl:variable name="current" select="//block/content/region"/>
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><xsl:value-of select="$current/name"/></li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/>, <xsl:value-of select="//fastobjlist/class"/></xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
	<!-- ****************** -->	
	
		<xsl:apply-templates select="$current" mode="currentView"/>
		
			
		<xsl:call-template name="DocumentFullFooter"/>
		
		
		
	</xsl:template>
	<xsl:template match="region" mode="currentView">

			<div id="wrapper">
				<div id="content_sub" style="margin-left:0px">
					<div class="mainTextArea">
						<div id="dbg" style="display:none"></div>
						
						<h1><xsl:value-of select="page/title"/></h1>
						<br />
						
						<div style="overflow:auto; margin:10px 0; clear:both">
							<xsl:apply-templates select="settlements"/>
						</div>

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
	

	<xsl:template match="class">
	

		
	
	</xsl:template>


	
</xsl:stylesheet>