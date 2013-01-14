<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
	
	</xsl:template>
	<xsl:template match="regions">
		<!--<textarea><xsl:copy-of select="."/></textarea>-->
		<ul>
		<xsl:for-each select="settlements/settlement">
			<li style="list-style:none; margin:0.3em 0; min-height:18px; clear:both">
				<div class="ui-icon ui-icon-radio-on" style="float:left; margin-right:2px"></div>
				<div style="float:left">
				<xsl:choose>
					<xsl:when test="not(page/title) or page/title=''"><a href="javascript:winHref('regwin', '/admin/settlements/{@id}/edit/')" style="color:red"><xsl:value-of select="name"/></a></xsl:when>
					<xsl:otherwise><a href="javascript:winHref('regwin', '/admin/settlements/{@id}/edit/')"><xsl:value-of select="page/title"/></a></xsl:otherwise>
				</xsl:choose>
				</div>
				
				<xsl:call-template name="sitemenu">
					<xsl:with-param name="owner" select="."/>
					<xsl:with-param name="owner_tbl" select="'Settlements'"/>
				</xsl:call-template>
				<div id="city_{@id}"></div>
			</li>
		</xsl:for-each>
		<xsl:for-each select="region">
			<li style="margin:0.5em -20px; list-style:none; clear:both; min-height:20px">
				<a class="ajax" target="reg_{@id}" href="/admin/settlements/region/{@id}/">
					<div class="ui-icon ui-icon-circlesmall-plus" style="float:left; margin-right:2px" onclick="$(this).toggleClass('ui-icon-circlesmall-plus ui-icon-circlesmall-minus'); $('#reg_{@id}').toggle()"></div>
				</a>
				<div style="float:left">
					<xsl:choose>
						<xsl:when test="not(page/title) or page/title=''"><a href="javascript:winHref('regwin', '/admin/settlements/region/{@id}/edit/')" style="color:red"><xsl:value-of select="name"/></a></xsl:when>
						<xsl:otherwise><a href="javascript:winHref('regwin', '/admin/settlements/region/{@id}/edit/')"><xsl:value-of select="page/title"/></a></xsl:otherwise>
					</xsl:choose>
				</div>
				
				<xsl:call-template name="sitemenu">
					<xsl:with-param name="owner" select="."/>
					<xsl:with-param name="owner_tbl" select="'Regions'"/>
				</xsl:call-template>
				
				<div id="reg_{@id}" style="display:none; clear:both"></div>
			</li>
		</xsl:for-each>
		</ul>
	</xsl:template>
	<xsl:template name="sitemenu">
		<xsl:param name="owner"/>
		<xsl:param name="owner_tbl"/>
		<xsl:param name="owner_id" select="$owner/@id"/>
		<div class="dropmenu ui-widget-content ui-corner-all" style="float:left; padding:1px; margin:1px 5px; min-width:10px; min-height:10px">
			<xsl:for-each select="$owner/sites/site">
				<div style="width:20px; height:20px; background:url(/img/icons/sites/{.}.png); float:left;" title="{.}" id="ico_reg_{$owner_tbl}_{$owner_id}{position()}" class="siteiconstat{@status}">
				
				</div>
			</xsl:for-each>
			<div id="sitewin_{$owner_tbl}" style="position:absolute; display:none;" class="menuset buttonset">
				<xsl:for-each select="$owner/sites/site">
					<input type="checkbox" id="reg_{$owner_tbl}_{$owner_id}{.}" onchange="$.post('/prg/editobj.php?mode=editsitelink', {{'owner_tbl':'{$owner_tbl}', 'owner_id':'{$owner_id}', 'site_id':'{.}'}}); $('#ico_reg_{$owner_tbl}_{$owner_id}{position()}').toggle()">
						<xsl:if test="@status=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
					</input>
					<label for="reg_{$owner_tbl}_{$owner_id}{.}" title="{.}"><div style="width:20px; height:20px; background:url(/img/icons/sites/{.}.png)"></div></label>
				</xsl:for-each>
			</div>
			<div style="clear:both"></div>	
		</div>
	</xsl:template>
</xsl:stylesheet>