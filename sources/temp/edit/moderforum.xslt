<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:include href="sources/temp/hotcat/categories.xslt"/>
	<xsl:include href="sources/temp/standart/forum.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	
    <xsl:template match="/">
		<xsl:variable name="lang" select="//presets/lang"/>
		
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li>
								<xsl:value-of select="//current//page/title"/>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
		
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="//current//page/title"/></xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
		
		<div>
			<h1><xsl:value-of select="//current//page/title"/></h1>
			
			<div class="tabs">
				<ul>
					<li><a href="/{/out/@lang}/forums/moderate/">Not Moderated</a></li>
					<li><a href="/{/out/@lang}/forums/chasm/">All Comments</a></li>
				</ul>
			</div>
			
		
		</div>
		
		<xsl:call-template name="DocumentFullFooter"/>
	</xsl:template>
	<xsl:template match="classes">
		<ul>
			<xsl:apply-templates select="class"/>
		</ul>
	</xsl:template>
	<xsl:template match="class">
		<li>
			<xsl:apply-templates select="page" mode="display">
				<xsl:with-param name="viewmode" select="admin"/>
				<xsl:with-param name="content" select="page/title"/>
				<xsl:with-param name="field">title</xsl:with-param>
			</xsl:apply-templates>
			<ul><xsl:apply-templates select="classes"/></ul>
		</li>
	</xsl:template>
</xsl:stylesheet>