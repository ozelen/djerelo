<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	
	<xsl:template match="/">
	</xsl:template>
	
	
	<xsl:template name="pricetable-totalperiod">
	
		<xsl:param name="periods" select="//periods"/>
		<xsl:param name="dow" select="//sitemap//locale//c[@id='dow']"/>
		<xsl:param name="curper" select="$periods/period[@id=//categories/@per]"/>
		<xsl:param name="perid" select="$curper/@id"/>
			<xsl:choose>
			<xsl:when test="$curper/week/cat or (//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user')">
			<table width="100%" class="pricetable">
				<tr class="ui-state-default">
					<td style="text-align:center">
						<xsl:value-of select="$curper/begin"/> - <xsl:value-of select="$curper/end"/>
					</td>
					<xsl:for-each select="$dow/day">
						<td title="{.}" class="dow d{@id}"><xsl:value-of select="@short"/></td>
					</xsl:for-each>
				</tr>

				
				<xsl:for-each select="$curper/week/cat">
				<tr>
					<xsl:variable name="id" select="@id"/>
					
					<xsl:variable name="cat" select="//categories/category[@id=$id]"/>
					<xsl:variable name="classify" select="$cat/classify"/>
					<xsl:param name="nameclass-id" select="$classify/class[val/@id=//sitemap//page[params/nameof[.='Categories']]/@id]/val/@id"/> 
					<xsl:param name="nameclass" select="//sitemap//page[@id=$nameclass-id]/title"/>
					
					
					<td class="leftcol">
						<xsl:if test="not($cat/name='')">
							<xsl:value-of select="$cat/name"/>
						</xsl:if>
						<xsl:if test="$cat/name=''">
							<xsl:value-of select="$nameclass"/>
						</xsl:if>
						<xsl:if test="$cat/name='' and not($nameclass)">
							Category&amp;nbsp;<xsl:value-of select="$cat/@id"/>
						</xsl:if>
						
					</td>
					<xsl:for-each select="day">
						<td colspan="{@span}" class="price"><xsl:value-of select="."/></td>
					</xsl:for-each>
				</tr>
				
				<xsl:if test="//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user'">
				<xsl:variable name="catid" select="@id"/> <!-- same that previous -->
				<xsl:variable name="defprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=0]"/>
				
				<tr class="edit" style="display:none">
					<td class="leftcol" id="d_{$perid}" title="{//locale/c[@id='hotcat.object.pricetable.default']}">
						<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_0-acc_-id_{$defprice/@id}" value="{$defprice}"/>
					</td>
					<xsl:for-each select="$dow/day">
						<xsl:variable name="dayid" select="@id"/>
						<xsl:variable name="dayprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=$dayid]"/>
						<td title="{.}" class="dow d{@id}">
						<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_{$dayid}-acc_-id_{$dayprice/@id}" value="{$dayprice}"/>
						</td>
					</xsl:for-each>
				</tr>
				</xsl:if>
				
				
				</xsl:for-each>
				
				<xsl:for-each select="//categories/category[not(@id=$curper/week/cat/@id) and (//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user')]">
					<xsl:variable name="cat" select="."/>
					<xsl:variable name="classify" select="classify"/>
					<xsl:param name="nameclass-id" select="$classify/class[val/@id=//sitemap//page[params/nameof[.='Categories']]/@id]/val/@id"/> 
					<xsl:param name="nameclass" select="//sitemap//page[@id=$nameclass-id]/title"/>
					<xsl:variable name="catid" select="@id"/> <!-- same that previous -->
					<xsl:variable name="defprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=0]"/>
					<tr class="ui-state-highlight">
						<td class="leftcol">
							<xsl:if test="not($cat/name='')">
								<xsl:value-of select="$cat/name"/>
							</xsl:if>
							<xsl:if test="$cat/name=''">
								<xsl:value-of select="$nameclass"/>
							</xsl:if>
							<xsl:if test="$cat/name='' and not($nameclass)">
								Category&amp;nbsp;<xsl:value-of select="$cat/@id"/>
							</xsl:if>
							
						</td>
						<td colspan="7" class="dow"><xsl:value-of select="//c[@id='standarts.undefined']"/>...</td>
					</tr>
					<tr class="edit ui-state-highlight" style="display:none">
						<td class="leftcol" id="d_{$perid}" title="{//locale/c[@id='hotcat.object.pricetable.default']}">
							<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_0-acc_-id_{$defprice/@id}" value="{$defprice}"/>
						</td>
						<xsl:for-each select="$dow/day">
						<xsl:variable name="dayid" select="@id"/>
						<xsl:variable name="dayprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=$dayid]"/>
						<td title="{.}" class="dow d{@id}">
							<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_{$dayid}-acc_-id_{$dayprice/@id}" value="{$dayprice}"/>
						</td>
						</xsl:for-each>
					</tr>
				</xsl:for-each>
				
				
			</table>
			</xsl:when>
			<xsl:otherwise>
				<div style="text-align:center; margin:10px"><xsl:value-of select="//c[@id='hotcat.object.pricetable.default']"/>...</div>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="pricetable">
		<xsl:param name="dow" select="//locale//c[@id='dow']"/>
		<xsl:param name="periods"/>
		<xsl:param name="catid"/>
		<xsl:param name="viewmode" select="//object/@viewmode"/>
		<input type="hidden" name="temp" value="hotcat/prices-alone.php" />
		
		
		<xsl:if test="$periods/period">
		<table width="100%" class="pricetable">
			<tr class="ui-state-default">
				<td></td>
				<xsl:for-each select="$dow/day">
					<td title="{.}" class="dow d{@id}"><xsl:value-of select="@short"/></td>
				</xsl:for-each>
			</tr>
			
			<xsl:for-each select="$periods/period">
				<xsl:variable name="perid" select="@id"/>
				<xsl:variable name="cat" select="$periods/period[@id=$perid]/week/cat"/>
				<xsl:variable name="id" select="$cat/@id"/>
				<xsl:variable name="defprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=0]"/>
				<tr>
					<td class="leftcol">
						<xsl:apply-templates select="date[@id='begin']/@pretty"/>
						&amp;ndash;
						<xsl:apply-templates select="date[@id='end']/@pretty"/>
					</td>
					<xsl:for-each select="$cat[@id=$catid]/day">
						<td colspan="{@span}" class="price"><xsl:value-of select="."/></td>
					</xsl:for-each>
					<xsl:if test="$viewmode and not($cat[@id=$catid]/day)">
						<td colspan="7" class="price"><xsl:value-of select="//locale/c[@id='standarts.undefined']"/></td>
					</xsl:if>
				</tr>
				
				<xsl:if test="//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user'">
				<tr class="edit" style="display:none">
				
					<td class="leftcol" id="d_{$perid}" title="{//locale/c[@id='hotcat.object.pricetable.default']}">
						<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_0-acc_-id_{$defprice/@id}" value="{$defprice}"/>
					</td>
					<xsl:for-each select="$dow/day">
						<xsl:variable name="dayid" select="@id"/>
						<xsl:variable name="dayprice" select="$periods/period[@id=$perid]/prices/price[@catid=$catid and @perid=$perid and @day=$dayid]"/>
						<td title="{.}" class="dow d{@id}">
						<input style="width:100%" name="price--cat_{$catid}-per_{$perid}-day_{$dayid}-acc_-id_{$dayprice/@id}" value="{$dayprice}"/>
						</td>
					</xsl:for-each>
				
				</tr>
				</xsl:if>
			
			</xsl:for-each>
			
			
		</table>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>