<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="../sources/temp/standart/accessories.xslt"/>
	<xsl:include href="../sources/temp/standart/classify.xslt"/>
    <xsl:template match="/">
	
		<!--<xsl:apply-templates select="categories/catgroup"/>-->
		<table width="100%">
			<tr>
				<td width="50%">
					<xsl:apply-templates select="//page[uri='/classes/objects/services/hotels/categories']/pages/page" mode="catgroup"/>
				</td>
				<td>
					<xsl:apply-templates select="//catgroup"/>
				</td>
			</tr>
		</table>
		
	</xsl:template>

	<xsl:template match="page" mode="catgroup">
		<div class="ui-state-default ui-corner-all" style="margin:5px 0">
			<div class="ui-state-active ui-corner-top" style="border:none; padding:5px 10px">
				<xsl:value-of select="title"/>
			</div>
			
			<ul id="{../../@id}_{@id}" class="catgroup control-list" style="padding:10px">
				<xsl:apply-templates select="//category[classify/class/val/@id=current()/@id]" mode="edit"/>
			</ul>
		</div>
	</xsl:template>
	
	
	<xsl:template match="catgroup">
		<xsl:variable name="cats" select="category[not(classify/class/val/@id)]"/>
		<xsl:if test="$cats">
			<div class="ui-state-default ui-corner-all" style="margin:5px 0">
				<div class="ui-state-error ui-corner-top" style="border:none; padding:5px 10px">
					<xsl:value-of select="name"/>
				</div>
				
				<ul id="{@id}" class="catgroup control-list" style="padding:10px">
					<xsl:apply-templates select="$cats" mode="edit"/>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="category" mode="edit">
		<li class="ui-state-default ui-corner-all control-element" id="{@id}" style="height:30px">
				<!--
				<xsl:apply-templates select="page" mode="display">
					<xsl:with-param name="lang" select="/categories/@lang"/>
					<xsl:with-param name="objid" select="@objid"/>
					<xsl:with-param name="viewmode">admin</xsl:with-param>
					<xsl:with-param name="content" select="page/title"/>
					<xsl:with-param name="field">title</xsl:with-param>
				</xsl:apply-templates>
				
						<a href="javascript:winClassify('Categories', {@id})">
							<xsl:choose>
								<xsl:when test="$classname">
									[<xsl:value-of select="$classname"/>]
								</xsl:when>
								<xsl:when test="not($classname)">
									[not classified]
								</xsl:when>
							</xsl:choose>
						</a>
				
				-->
				
			<xsl:variable name="classname" select="classify//class[key/@id='378']/val"/>
			<xsl:variable name="pagetitle" select="page/title"/>
				
				
				
				<ul class="icons" style="float:right">
					<li class="ui-state-default ui-corner-all" title="Classification" onclick="winClassify('Categories', {@id})"><span class="ui-icon ui-icon-tag"></span></li>
				</ul>
				


				<xsl:apply-templates select="page" mode="display">
					<xsl:with-param name="lang" select="/categories/@lang"/>
					<xsl:with-param name="objid" select="@objid"/>
					<xsl:with-param name="viewmode">admin</xsl:with-param>
					<xsl:with-param name="content" select="page/title"/>
					<xsl:with-param name="field">title</xsl:with-param>
				</xsl:apply-templates>

				[<xsl:value-of select="@id"/>]
				<xsl:choose>
					<xsl:when test="$classname">
						[<xsl:value-of select="$classname"/>]
					</xsl:when>
					<xsl:when test="not($classname)">
						[not classified]
					</xsl:when>
				</xsl:choose>


					
				
			
			<xsl:call-template name="WinClassify">
				<xsl:with-param name="uid">editcat_<xsl:value-of select="@id"/></xsl:with-param>
				<xsl:with-param name="owner_tbl">Categories</xsl:with-param>
				<xsl:with-param name="owner_id" select="@id"/>
				<xsl:with-param name="uri">/classes/objects/services/hotels/categories</xsl:with-param>
				<xsl:with-param name="fields">
					<input type="hidden" name="objid" value="{@objid}" />
				</xsl:with-param>
				<xsl:with-param name="title"><xsl:value-of select="page/title"/>: Classification tags</xsl:with-param>
			</xsl:call-template>
				
				
		</li>
	</xsl:template>
</xsl:stylesheet>