<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
    <xsl:template match="/">
	<!-- ****************** -->
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li> <b><xsl:value-of select="//locale/c[@id='standarts.login']"/></b></li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">Login</xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
	<!-- ****************** -->	
	
	
			<div id="wrapper">
				<div id="content_sub">
					<div class="mainTextArea">
						
						<xsl:apply-templates select="/out/sysmsg/message"/>
					
						<form method='post'>
							<xsl:call-template name="blk">
								<xsl:with-param name="header">Login</xsl:with-param>
								<xsl:with-param name="content">
									<table width="100%">
										<tr>
											<td>E-mail</td>
											<td><input name="email" style="width:100%"/></td>
										</tr>
										<tr>
											<td>Password</td>
											<td><input name="password" type="password" style="width:100%"/></td>
										</tr>
										<tr>
											<td>Acception code</td>
											<td><input name="keystring" style="width:100%"/></td>
										</tr>
										<tr>
											<td></td>
											<td><img src="http://ski.djerelo.info/prg/kcaptcha/?{/out/session}={/out/session/@id}"/></td>
										</tr>
										<tr>
											<td></td>
											<td><button>Login!</button></td>
										</tr>
									</table>
								
								</xsl:with-param>
							</xsl:call-template>
						</form>

					</div>
				</div>
			</div>
			<div id="navigation_sub">
				<!--<div><xsl:apply-templates select="//banners/banner[@id=1]"/></div>-->
				
			</div>
			<div id="extra_sub">
				<xsl:apply-templates select="//banners/banner[@type='300x250']"/>
			</div>
			
		
			
		<xsl:call-template name="DocumentFullFooter"/>

	</xsl:template>
	
</xsl:stylesheet>
