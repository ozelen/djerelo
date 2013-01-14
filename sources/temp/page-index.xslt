<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="imports-index.xslt" />
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/" name="uindex">
		<xsl:param name="cur" 	select="/out/current/page"/>
	    <xsl:param name="title" select="$cur/title" />
	    <xsl:param name="content" select="$cur/source" />
	    <xsl:param name="navigation" />

		<xsl:variable name="blocks"	select="$cur/blocks"/>

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title" select="$title" />
			<xsl:with-param name="navigation" select="$navigation" />
		</xsl:call-template>
			<div style="height:120px">

			<div style="float:left; width:650px;">
				<xsl:call-template name="BookitForm" />
			</div>
			<div style="float:right">
				<xsl:call-template name="bn300x110"/>
			</div>
			</div>
			<div id="wrapper" style="padding:10px 0">
				<div id="content" style="width:650px;">
					<table width="100%" class="mainPageMarkupTable">
						<tr>
							<td width="200">
								<xsl:apply-templates select="//settlements" mode="vertical"/>
							</td>
							<td style="padding-left:2px" class="mainTextArea">

								<h1><xsl:value-of select="$title"/></h1>

								<xsl:value-of select="$content"/>
								
								<xsl:apply-templates select="/out/sitemap//page[@id=$cur/@id]/pages" mode="mainmenu">
									<xsl:with-param name="class" select="'submenu'" />
									<xsl:with-param name="level" select="$cur/@id" />
								</xsl:apply-templates>


							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="extra">
				<!-- <xsl:apply-templates select="//block[name='objlist']" mode="accordion"/> -->
				<div>
					<div style="padding: 20px 0">
						<inject id="adsense-300x250"></inject>
					</div>

					<div style="margin-top:5px">
						<xsl:apply-templates select="//banners/banner[@id=3]"/>
					</div>
				</div>
				<xsl:call-template name="adsense-vertical"/>
			</div>
		<xsl:call-template name="DocumentFullFooter"/>
	</xsl:template>



</xsl:stylesheet>