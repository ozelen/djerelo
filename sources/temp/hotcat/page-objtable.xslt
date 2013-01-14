<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/classify.xslt"/>
	<xsl:include href="sources/temp/hotcat/lib/objects.xslt"/>
	<xsl:template match="/">
		<xsl:variable name="lang" select="//presets/lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="/admin/">Admin</a>
								<ul>
									<li>Objects</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>
		</xsl:variable>
	
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">Objects</xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
		</xsl:call-template>
		
		<h1>Object List</h1>
		<div class="ui-widget-header ui-corner-all" style="padding:5px">
			<form class="ajax" target="objlist" action="/prg/editobj.php?mode=objtable" method="post" style="margin:0px">
			<input type="hidden" name="temp" value="hotcat/objtable-alone.xslt" />
			<table width="100%">
				<tr>
					<td style="vertical-align:middle; text-align:center"><label for="keyword">Find:</label></td>
					<td><input id="keyword" name="keyword" style="width:100%;"/></td>
					<td width="150">
						<select name="searchin" style="width:100%">
							<option value="objname">by Object Name</option>
							<option value="settlement">by Settlement</option>
						</select>
					</td>
					<td width="25"><button ico="ui-icon-search" style="margin:0">Search</button></td>
                    <td width="25"><a href="/ua/admin/objects/addform/" target="objlist" class="btn ajax" ico="ui-icon-plus">Add</a></td>
				</tr>
			</table>
			</form>
		</div>
		
		<form class="ajax" target="objlist" action="/prg/editobj.php?mode=objtable" method="post" style="margin:0px">
			<input type="hidden" name="temp" value="hotcat/objtable-alone.xslt" />
			<div class="radio" style="margin:5px; text-align:center">
				<input type="radio" id="radio1" name="haveno" value="balance" /><label for="radio1">Out of Balance</label>
				<input type="radio" id="radio2" name="haveno" value="settlement" /><label for="radio2">No Settlement</label>
				<input type="radio" id="radio3" name="haveno" value="location" /><label for="radio3">No Coordinates</label>
			</div>
		</form>
		<div id="objlist" style="margin:10px 0">
			Click "Search" button
		</div>
		<xsl:call-template name="DocumentFullFooter"/>
		
	</xsl:template>
	
</xsl:stylesheet>