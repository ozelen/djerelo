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
	<xsl:include href="sources/temp/standart/classify.xslt"/>
    <xsl:template match="/">
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="cur" 	select="/out/current/page"/>
		<xsl:variable name="blocks"	select="$cur/blocks"/>
	<!-- ****************** -->
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$cur/title"/></xsl:with-param>
		</xsl:call-template>
	<!-- ****************** -->	

		
			<div id="wrapper">
				<div id="content_sub" class="mainTextArea" style="margin-left:0px">

						<div id="dbg" style="display:none"></div>
						<h1>[<xsl:value-of select="/out/user/name"/>]: <xsl:value-of select="$cur/title"/></h1>
						<br />
						
						<xsl:call-template name="WinClassify">
							<xsl:with-param name="owner_tbl">Objects</xsl:with-param>
							<xsl:with-param name="owner_id">new</xsl:with-param>
							<xsl:with-param name="uri">/classes/objects</xsl:with-param>
							<xsl:with-param name="fields">
								<input type="hidden" name="objid" value="new" />
								<fieldset>
								
								<legend>Name</legend>
									<input type="text" name="name" style="width:100%"/>
								</fieldset>
								
							</xsl:with-param>
						</xsl:call-template>
						
						
						<xsl:apply-templates select="//objects" mode="widelist"/>
						<xsl:if test="not(//objects/object)"><div align="center">You have not any objects</div></xsl:if>

				</div>
			</div>
			
			<div id="extra_sub" style="text-align:center; padding-top:30px">
				<button ico="ui-icon-home" ico2="ui-icon-plus" onclick="winClassify('Objects', 'new')"><xsl:value-of select="//c[@id='hotcat.object.add']"/></button>
			</div>
		
		
	<!-- ****************** -->	
		<xsl:call-template name="DocumentFullFooter"/>
	<!-- ****************** -->	
		
		
	</xsl:template>

</xsl:stylesheet>