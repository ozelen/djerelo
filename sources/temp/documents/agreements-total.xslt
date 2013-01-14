<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/classify.xslt"/>
	<xsl:include href="sources/temp/documents/docs.xslt"/>
	<xsl:template match="/">
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="/admin/">Admin</a>
								<ul>
									<li>Agreements</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">Agreements</xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
		
		<h1>Agreements</h1>
		<div class="ui-widget-header ui-corner-all" style="padding:5px">
			<form class="ajax" target="doclist" action="/prg/callaction.php?mode=doclist" method="post" style="margin:0px">
			<input type="hidden" name="temp" value="documents/docs-alone.xslt" />
			<table width="100%">
				<tr>
					<td style="vertical-align:middle; text-align:center"><label for="keyword">Find:</label></td>
					<td><input id="keyword" name="keyword" style="width:100%;"/></td>
					<td width="150">
						<select name="searchin" style="width:100%">
							<option value="objname">by Object Name</option>
							<option value="owner">by Person Name</option>
							<option value="number">by Doc Number</option>
						</select>
					</td>
					<td width="120" style="text-align:center">
						<label for="addPerFrom">From&amp;nbsp;</label>
						<input type="text" alt="addPerFrom_alt" id="addPerFrom" style="width:80px"/>
						<input type="hidden" id="addPerFrom_alt" name="from"/>
					</td>
					<td width="100">
						<label for="addPerTo">to&amp;nbsp;</label>
						<input type="text" id="addPerTo" alt="addPerTo_alt" style="width:80px"/>
						<input type="hidden" id="addPerTo_alt" name="to"/>
					</td>
					<td width="5"><button ico="ui-icon-search ui-icon" style="width:30px; height:25px"></button></td>
				</tr>
			</table>
			</form>
		</div>
		<div id="doclist" style="margin:10px 0">
			<xsl:apply-templates select="//docs"/>
		</div>
		<xsl:call-template name="DocumentFullFooter"/>
		
	</xsl:template>
	
</xsl:stylesheet>