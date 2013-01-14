<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		<xsl:apply-templates select="/page"/>
	</xsl:template>
	<xsl:template match="page[@mode='view' and @multiform='true']">
		<table width="100%" height="90%">
			<tr>
				<td>
				</td>
				<td></td>
			</tr>
			<tr>
				<td width="20">
					<ul class="icons ui-widget ui-helper-clearfix">
						<li class="ui-state-default ui-corner-all" onclick="addLang('langmenu_{@uid}', 'pagedata_{@uid}', '/prg/editpage.php')"><span class="ui-icon ui-icon-circle-plus"></span></li>
					</ul>
					
					<div id="langmenu_{@uid}_prompt" style="display:none" title="{//locale/c[@id='edit.langs.choose']}">
						<select style="width:100%">
							<xsl:for-each select="//locale/c[@id='langs']/l">
								<option value="{@id}">
									<xsl:if test="@id=/page/var/@lang"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
									<xsl:value-of select="."/>
								</option>
							</xsl:for-each>
						</select>
					</div>
					
					<div id="langmenu_{@uid}" uid="{@uid}">
						<xsl:apply-templates select="/page" mode="lang_menu"/>
					</div>
				</td>
				<td id="pagedata_{@uid}" class="ui-widget-content ui-corner-all" style="padding:2px 20px">
					<div id="pagedata_{@uid}_{@lang}">
						<xsl:apply-templates select="var[@lang=/page/@lang]"/>
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="page">
		<xsl:apply-templates select="var"/>
	</xsl:template>
	
	<xsl:template match="page[@mode='addlang']">
		<xsl:apply-templates select="/page" mode="lang_menu"/>
	</xsl:template>
	
	<xsl:template match="page" mode="lang_menu">
		<ul class="myMenu icoMenu">
			<xsl:apply-templates select="var"  mode="lang_button"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="var" mode="lang_button">
		<!--<input value="/prg/editpage.php?lang={@lang}" />-->
		<li hr="/prg/editpage.php?lang={@lang}" target="pagedata_{/page/@uid}" lang="{@lang}">
			<xsl:if test="@lang=/page/@lang"><xsl:attribute name="class">ui-state-active ui-state-default ui-corner-left</xsl:attribute></xsl:if>
			<xsl:if test="not(@lang=/page/@lang)"><xsl:attribute name="class">ui-state-default ui-corner-left</xsl:attribute></xsl:if>
			<xsl:value-of select="@lang"/>
		</li>
	</xsl:template>
	
	<xsl:template match="var" mode="simple">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="var">
		<input name="content_Title_{@lang}" type="text" value="{title}" style="width:100%; margin:5px 0" />
		<textarea name="content_Source_{@lang}" id="textarea_{/page/@uid}_{@lang}" style="width:100%; height:300px"><xsl:value-of select="source"/></textarea>
		<ul class="icons ui-widget ui-helper-clearfix">
			<li class="ui-state-default ui-corner-all" onclick="wymEd('textarea_{/page/@uid}_{@lang}', '{@lang}', this)" title="WYSIWYG Editor"><span class="ui-icon ui-icon-carat-2-e-w"></span></li>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>