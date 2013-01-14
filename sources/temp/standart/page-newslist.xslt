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
	<xsl:include href="sources/temp/standart/news.xslt"/>
	
    <xsl:template match="/">

	<!-- ****************** -->
		<xsl:variable name="current" select="//items"/>
		<xsl:variable name="lang" select="//presets/lang"/>
		

	<xsl:if test="//items/@type='news'">
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="//locale/c[@id='standarts.news']"/></xsl:with-param>
			<xsl:with-param name="navigation">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><xsl:value-of select="//locale/c[@id='standarts.news']"/></li>
						</ul>
					</li>
				</ul>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	
	<xsl:if test="//items/@type='papers'">
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="//locale/c[@id='standarts.papers']"/></xsl:with-param>
			<xsl:with-param name="navigation">
				<ul>
					<li><a href="/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="/{$lang}/papers/"><xsl:value-of select="//locale/c[@id='standarts.papers']"/></a>
								<ul>
									<li><a href="/{$lang}/papers/{//items/section/@id}"><xsl:value-of select="//items/section"/></a>
										<ul>
											<li><xsl:value-of select="$current/name"/></li>
										</ul>
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	
	<!-- ****************** -->	

			<div id="wrapper">
				<div id="content_sub" style="margin-left:0px">
					<div class="mainTextArea">
						<div id="dbg" style="display:none"></div>
						<h1><xsl:value-of select="//current//page/title"/></h1>
						
						<xsl:if test="//items/@type='news'">
							<xsl:call-template name="moveto"/>
							<xsl:apply-templates select="//items" mode="blog"/>
							<xsl:call-template name="moveto"/>
						</xsl:if>
						<xsl:if test="//items/@type='papers'">
							<xsl:apply-templates select="//items" mode="list">
								<xsl:with-param name="by-num-id" select="1"/>
							</xsl:apply-templates>
						</xsl:if>
						
						
						
					</div>
				</div>
			</div>
			<div id="extra_sub">
				<xsl:call-template name="subpage-bannerlist"><xsl:with-param name="inside">
						<!-- BANNER -->
						<xsl:call-template name="bn300x110"/>
						<div style="padding-top:20px"></div>
				</xsl:with-param></xsl:call-template>
			</div>


		<xsl:call-template name="DocumentFullFooter"/>
	</xsl:template>

	<xsl:template name="moveto">
		<xsl:variable name="current" select="//items"/>
		<xsl:variable name="lang" select="//presets/lang"/>
		<p align="center">
			<a href="/{$lang}/news/archive/{//items/@skip + 20}">&lt;&lt; <xsl:value-of select="//locale/c[@id='standarts.previous']"/> 20</a>
			<xsl:if test="//items/@skip>=20">
			| <a href="/{$lang}/news/archive/{//items/@skip - 20}"><xsl:value-of select="//locale/c[@id='standarts.next']"/> 20 &gt;&gt;</a>
			</xsl:if>
		</p>
	</xsl:template>

	
</xsl:stylesheet>