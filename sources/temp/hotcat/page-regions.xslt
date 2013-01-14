<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/classify.xslt"/>
	<xsl:include href="sources/temp/hotcat/lib/regions.xslt"/>
	<xsl:template match="/">
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="/admin/">Admin</a>
								<ul>
									<li>Regions</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">Regions and Settlements</xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
		
		<h1>Regions and Settlements</h1>
		<div id="regwin" title="Edit"></div>
		<div class="ui-widget-header ui-corner-all" style="padding:5px">
			<form class="ajax" target="reglist" action="/prg/editobj.php?mode=objtable" method="post" style="margin:0px">
			<input type="hidden" name="temp" value="hotcat/reglist-alone.xslt" />
			<table width="100%">
				<tr>
					<td width="30"><a href="/{/out/@lang}/admin/settlements/region/0/" target="reglist" class="btn ajax" ico="ui-icon-home" style="width:30; height:30"></a></td>
					<td width="80" style="vertical-align:middle; text-align:center"><label for="keyword">Find:</label></td>
					<td><input id="keyword" name="keyword" style="width:100%;"/></td>
					<td width="25"><button ico="ui-icon-search" style="margin:0">Search</button></td>
				</tr>
			</table>
			</form>
		</div>
		
		<div id="reglist" style="margin:10px 0">
			<xsl:apply-templates select="//regions"/>
		</div>
		<xsl:call-template name="DocumentFullFooter"/>
		
	</xsl:template>
	
</xsl:stylesheet>