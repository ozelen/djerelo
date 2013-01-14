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
		<xsl:variable name="current" select="//city[ident=//presets/uri-vars/identcity]"/>
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="{/out/home}/{$lang}/goto/{$current/ident}"><xsl:value-of select="$current/name"/></a>
								<ul>
									<li> <b><xsl:value-of select="//locale/c[@id='hotcat.infrastructure']"/></b> </li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/>, <xsl:value-of select="//class/name"/></xsl:with-param>
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
						
						<h1><xsl:value-of select="name"/>, <xsl:value-of select="//class/name"/></h1>
						<br />
						
						<xsl:apply-templates select="//objects" mode="widelist"/>

					</div>
				</div>
			</div>

			<div id="extra_sub">

			<xsl:apply-templates select="//banners/banner[@type='300x250']"/>
				

				
			</div>
			


	</xsl:template>
	

	<xsl:template match="class">
	

		
	
	</xsl:template>


	
</xsl:stylesheet>