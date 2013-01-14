<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="sources/temp/page-index.xslt" />
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	
    <xsl:template match="/">

	    <!-- <xsl:call-template name="newspage" /> -->
			<xsl:variable name="current" select="//item"/>
			<xsl:variable name="lang" select="//presets/lang"/>

	    <xsl:call-template name="uindex" >
		    <xsl:with-param name="title" select="$current/title" />
		    <xsl:with-param name="content"  select="$current/content" />

	    </xsl:call-template>
	    <!--<xsl:call-template name=""-->
		
	</xsl:template>

	<xsl:template name="newspage">


		<!-- ****************** -->
			<xsl:variable name="current" select="//item"/>
			<xsl:variable name="lang" select="//presets/lang"/>



		<xsl:if test="//items/@type='news'">
			<xsl:call-template name="DocumentFullHeader">
				<xsl:with-param name="title"><xsl:value-of select="//locale/c[@id='standarts.news']"/></xsl:with-param>
				<xsl:with-param name="navigation">
					<ul>
						<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
							<ul>
								<li><a href="{/out/home}/{$lang}/news/"><xsl:value-of select="//locale/c[@id='standarts.news']"/></a>
									<ul>
										<li><xsl:value-of select="//item/title"/></li>
									</ul>
								</li>
							</ul>
						</li>
					</ul>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="//items/@type='papers'">
			<xsl:call-template name="DocumentFullHeader">
				<xsl:with-param name="title"><xsl:value-of select="$current/title"/> | <xsl:value-of select="//locale/c[@id='standarts.papers']"/></xsl:with-param>
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
			<xsl:apply-templates select="$current" mode="currentView"/>


			<xsl:call-template name="DocumentFullFooter"/>

		


	</xsl:template>


	<xsl:template match="item" mode="currentView">

			<div id="wrapper">
				<div id="content_sub" style="margin-left:0px">
					<div class="mainTextArea">
						<div id="dbg" style="display:none">debug</div>
						<!--
						<xsl:if test="/out/user/level=1">
							<div class=" ui-widget-header ui-corner-top" style="margin:5 0">
								<ul class="icons ui-widget ui-helper-clearfix">
									<li class="ui-state-default ui-corner-all" onclick="winPageEdit('{$uid}', {@id})" title="Edit"><span class="ui-icon ui-icon-pencil"></span></li>

								</ul>
							</div>
						</xsl:if>
						-->
						<h1><xsl:value-of select="title"/></h1>
						<div style="padding:10px; margin-left:auto">
							<inject id="adsense-468x60"></inject>
						</div>
						<p><xsl:apply-templates select="content"/></p>
						<p>
						<xsl:value-of select="from"/><br/>
						<xsl:if test="not(guid)=''">
							<a href="{guid}"><xsl:apply-templates select="guid"/></a>
						</xsl:if>
						</p>
					</div>
				</div>
			</div>

			<div id="extra_sub">

				<xsl:call-template name="subpage-bannerlist"><xsl:with-param name="inside">
						<!-- BANNER -->
						<xsl:call-template name="bn300x110"/>
						<div style="padding-top:20px"></div>
				</xsl:with-param></xsl:call-template>
				<inject id="adsense-300x250"></inject>

				
			</div>
			


	</xsl:template>
	

	


	
</xsl:stylesheet>