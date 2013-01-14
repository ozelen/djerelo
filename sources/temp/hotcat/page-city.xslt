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
							<li><a href="/{/out/@lang}/loc/ukraine/{$current/region/@ident}/"><xsl:value-of select="$current/region"/></a>
								<ul>
									<li><xsl:value-of select="$current/name"/></li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/></xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
			<xsl:with-param name="headers"><script>$(function() {pageTracker._trackEvent('Settlements','Visits','<xsl:value-of select="$current/ident"/>');});</script></xsl:with-param>
		</xsl:call-template>
	<!-- ****************** -->	

		
		<xsl:apply-templates select="$current" mode="currentView"/>
			
		<xsl:call-template name="DocumentFullFooter"/>
		
		
		
	</xsl:template>
	<xsl:template match="city" mode="currentView">
			<xsl:variable name="city" select="."/>

			
			<div class="mainTextArea">
				<h1><xsl:value-of select="name"/></h1>
			</div>

			
			<div id="citymap" style="width:638px; float:left">

			<xsl:if test="not(bookit='')">
				<div style="clear:both; height:10px"></div>
				<xsl:call-template name="BookitForm" />
				<div style="clear:both; height:10px"></div>
			</xsl:if>

				<xsl:if test="location">
					<div style="margin-bottom:3px" class="widget-header ui-corner-all">
						<h3><xsl:value-of select="name"/>&amp;nbsp;<xsl:value-of select="//locale/c[@id='hotcat.city.map']"/>:</h3> <!-- CAPTION: Map -->
					</div>
					<xsl:apply-templates select="location">
						<xsl:with-param name="height" select="380"/>
					</xsl:apply-templates>
				</xsl:if>

			</div>
			
			<div style="float:right; width:320px">
					<div style="padding-top:10px; padding-bottom:23px">
						<xsl:call-template name="bn300x110"/>
					</div>

					<div>
						<xsl:if test="//forecast">
							<div style="margin-bottom:3px" class="widget-header ui-corner-all">
								<h3><xsl:value-of select="//locale/c[@id='hotcat.weather-today']"/>: </h3> <!-- CAPTION: Weather -->
							</div>
							<div class="weatherblock">
								<table width="100%">
									<tr>
										<td style="text-align:center"><img src="/img/icons/weather/{//forecast/day/pict}"/></td>
										<td style="vertical-align:middle"><xsl:value-of select="//forecast/day/t/min"/> &amp;mdash; <xsl:value-of select="//forecast/day/t/max"/></td>
										<td style="vertical-align:middle"><a href="./weather/"><xsl:value-of select="name"/>, <xsl:value-of select="//locale/c[@id='hotcat.weather-5days']"/></a></td>
									</tr>
								</table>
							</div>
						</xsl:if>
					</div>
					<div>
						<div style="margin-bottom:3px" class="widget-header ui-corner-all">
							<h3><xsl:value-of select="name"/>, <xsl:value-of select="//locale/c[@id='hotcat.infrastructure']"/>: </h3> 
						</div>
						<!--<textarea><xsl:copy-of select="inf"/></textarea>-->
						
						<xsl:for-each select="inf/profile">
							<xsl:variable name="profid" select="@id"/>
							<h4 style="margin:2px 40px">
								<a href="/{/out/@lang}/goto/{$city/ident}/infrastructure/{@id}/"><xsl:value-of select="."/>:</a>
							</h4>
							<ul style="margin:5px 0">
							<xsl:for-each select="../type[@profile=$profid]">
								<li style="margin-bottom:0.5em">
									<a href="/{/out/@lang}/goto/{$city/ident}/infrastructure/{@id}/"><xsl:value-of select="."/></a> (<xsl:value-of select="@objcount"/>)
								</li>
							</xsl:for-each>
							</ul>
						</xsl:for-each>
					</div>
					<xsl:if test="near/settlements/settlement">
					<div title="{//locale/c[@id='standart.measure.radius.description']}">
						<div style="margin-bottom:3px" class="widget-header ui-corner-all">
							<h3>
								<xsl:value-of select="//locale/c[@id='hotcat.cities.in-radius']"/> <xsl:text> </xsl:text>
								<xsl:value-of select="near/@radius"/><xsl:text> </xsl:text>
								<xsl:value-of select="//locale/c[@id=current()/near/@measure]"/>*: 
							</h3> <!-- CAPTION: Nearest settlements -->
						</div>
						<ul>
						<xsl:for-each select="near/distances/d">
							<xsl:sort data-type="number" select="."/>
							<xsl:variable name="stlm" select="@for"/>
							<xsl:variable name="elem" select="../../settlements/settlement[@id=$stlm]"/>
							<li style="margin-bottom:0.5em">
								<a href="/{/out/@lang}/goto/{$elem/ident}"><xsl:value-of select="$elem/page/title"/></a> (<xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="//locale/c[@id=current()/@measure]"/>)
							</li>
						</xsl:for-each>
						</ul>
					</div>
					</xsl:if>

			</div>

			<div id="wrapper">
			
				<div id="content_sub" style="margin-left:0px">
					<div class="mainTextArea">


					
					
<!-- CITY MENU -->

					<div style="width:50%; float:left">
						<xsl:apply-templates select="infrastructure" mode="accordion"/>
					</div>

<!--/CITY MENU -->
<!--			
			<div class="tabs">
				<ul>
					<li><a href="#city-main-infra"><xsl:value-of select="name"/>, <xsl:value-of select="//locale/c[@id='hotcat.infrastructure']"/></a></li>
					<li><a href="/booking/Settlements/{@id}/"><xsl:value-of select="//c[@id='hotcat.object.free-booking']"/></a></li>
				</ul>
				<div id="city-main-infra">

				</div>
			</div>
-->

					<div style="overflow:auto; clear:both;">
						<xsl:apply-templates select="//fastobjlist"/>
					</div>
			
			<!--		
						<div style="overflow:auto; margin:10px 0; clear:both;">
							<xsl:apply-templates select="//fastobjlist"/>
						</div>
						
			-->		
						
						<div style="overflow:auto; margin:20px 0; clear:both">
							<xsl:apply-templates select="page" mode="display">
								<xsl:with-param name="objid" select="@id"/>
								<xsl:with-param name="viewmode">guest</xsl:with-param>
								<xsl:with-param name="content" select="page/source"/>
								<xsl:with-param name="field">source</xsl:with-param>
							</xsl:apply-templates>
						</div>
						
						<!--<xsl:value-of select="info"/>-->
						
						<div id="dbg" style="display:none"></div>
						
					</div>
				</div>
			</div>
			

			

			<div id="extra_sub">
			
	
				<div style="padding:10px 0">
					<inject id="adsense-300x250"></inject>
				</div>
<xsl:call-template name="xdrive" />
			<!-- Banners
[
				<xsl:call-template name="subpage-bannerlist"><xsl:with-param name="inside">
						<xsl:call-template name="bn300x110"/>
						<div style="padding-top:20px"></div>
				</xsl:with-param></xsl:call-template>
]
			-->
				
			</div>
			
			<div class="forum_tabs" style="clear:both; padding-top:30px" id="comments">
				<ul>
					<li><a href="/{/out/@lang}/forums/{topic/@id}/"><xsl:value-of select="name"/>,&amp;nbsp;<xsl:value-of select="//locale/c[@id='forum.header-sm']"/></a></li> <!-- All -->
				</ul>
			</div>
			<xsl:call-template name="forum-form"/>
			

	</xsl:template>
	

	


	
</xsl:stylesheet>