<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		<xsl:apply-templates select="block"/>
	</xsl:template>

	<xsl:template name="BookitForm">
		<div class="ui-widget-content ui-corner-all ui-state-highlight maintextarea">
				<h1 style="padding:10px">
					<xsl:if test="name"><xsl:value-of select="name" />. </xsl:if>
					<xsl:value-of select="//locale/c[@id='bookit.form.header']"/>
				</h1>
			<form id="nzSearchForm" action="http://bookit.djerelo.info/search" target="_blank" method="get" style="padding:5px; margin:0">
				<table width="100%">
					<tr>
						<td>
							<xsl:if test="not(bookit) or bookit/@id=''">
								<label for="nzSearch"><xsl:value-of select="//locale/c[@id='bookit.form.entername']"/></label>
							</xsl:if>
						</td>
						<td><label for="nzArrival"><xsl:value-of select="//locale/c[@id='bookit.form.arrival']"/></label></td>
						<td><label for="nzDeparture"><xsl:value-of select="//locale/c[@id='bookit.form.departure']"/></label></td>
					</tr>
					<tr>
						<td>
							<input id="nzSearch" style="width:100%" value="{bookit}" />
						</td>
						<td width="100">
							<input name="p[start]" id="nzArrival" link="nzd2" style="width:100%;" value="" />
						</td>
						<td width="100">
							<input name="p[end]" id="nzDeparture" link="nzd1" style="width:100%" />
						</td>
						<td style="text-align:right; width:80px">
							<button ico="ui-icon-newwin" style="height:100%"><xsl:value-of select="//locale/c[@id='bookit.form.find']"/></button>
						</td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2" style="vertical-align:middle">
							<input id="nzFree" type="checkbox" name="p[free]" />
							<label for="nzFree"><xsl:value-of select="//locale/c[@id='bookit.form.free']"/></label>
						</td>
					</tr>
				</table>
				<input type="hidden" name="p[target]" value="{bookit/@id}" id="nzSearchTarget" />
				<input type="hidden" name="p[name]" value="{bookit/@name}" id="nzSearchName" />
			</form>
		</div>
	</xsl:template>



	<xsl:template name="BookitFormBlock">
		<div style="width:230px" class="ui-widget-content ui-corner-all">
			<div class="widget-header ui-widget-header ui-corner-all" style="margin:2px; padding:2px 5px">
				<h1><xsl:value-of select="//locale/c[@id='bookit.form.header']"/></h1>
			</div>
			<form id="nzSearchForm" action="http://bookit.djerelo.info/search" target="_blank" method="get" style="padding:5px; margin:0">
				<table width="100%">
					<tr>
						<td colspan="2">
							<label for="nzSearch"><xsl:value-of select="//locale/c[@id='bookit.form.entername']"/></label>
							<input id="nzSearch" style="width:100%" />
						</td>
					</tr>
					<tr>
						<tr>
							<td>
								<label for="nzArrival"><xsl:value-of select="//locale/c[@id='bookit.form.arrival']"/></label>
								<input name="p[start]" id="nzArrival" link="nzd2" style="width:100%" />
							</td>
							<td>
								<label for="nzDeparture"><xsl:value-of select="//locale/c[@id='bookit.form.departure']"/></label>
								<input name="p[end]" id="nzDeparture" link="nzd1" style="width:100%" />
							</td>
						</tr>
						<tr>
							<td>
								<input id="nzFree" type="checkbox" name="p[free]" />
								<label for="nzFree"><xsl:value-of select="//locale/c[@id='bookit.form.free']"/></label>
							</td>
							<td style="text-align:right">
								<button ico="ui-icon-newwin"><xsl:value-of select="//locale/c[@id='bookit.form.find']"/></button>
							</td>
						</tr>
					</tr>
				</table>
				<input type="hidden" name="p[target]" id="nzSearchTarget" />
				<input type="hidden" name="p[name]" id="nzSearchName" />
			</form>
		</div>
	</xsl:template>




	<xsl:template match="block[name='hotcat.cities.menu']">
		<xsl:apply-templates select="content/infrastructure" mode="accordion">
			<xsl:with-param name="city" select="params"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="conceptions" mode="accordion">
		<div>
			<xsl:for-each select="conception">
				<div class="ui-widget-content ui-corner-all" style="padding:2px">
					<div class="ui-widget-header ui-corner-all" style="padding:5px 10px"><xsl:value-of select="name"/></div>
						<div style="padding:15px 12px">
							<xsl:for-each select="city">
								<a href="/{/out/@lang}/goto/{city-id}"><xsl:value-of select="caption"/></a>,
							</xsl:for-each>
						</div>
					</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="block[name='objmenu']">
		<xsl:variable name="uid" select="generate-id()"/>
		<xsl:variable name="objid" select="//categories/object/@id"/>
		<xsl:variable name="objacc" select="//categories/object/account"/>
		<xsl:variable name="objname" select="//categories/object/name"/>
		<xsl:variable name="objimg" select="//categories/object/image"/>
		<table class="objMenuTable">
			<tr>
				<td width="100" style="vertical-align:middle; text-align:center">
					<div id="catMenuImg_{$uid}" align="center" style="text-align:center">
						<img src="http://pic.djerelo.info/img/hotcat/objects/{$objid}/albums/album/{$objimg}/mini.jpg"/>
					</div>
					<div id="mainMenuImg_{$uid}" style="display:none">
						<img src="http://pic.djerelo.info/img/hotcat/objects/{$objid}/albums/album/{$objimg}/mini.jpg"/>
					</div>
				</td>
				<td>
					<h4><a href="/{//presets/lang}/cat/{//content/categories/object/account}"><xsl:value-of select="//content/categories/object/name"/></a></h4>
					<xsl:for-each select="//cat-types/type[@id=//category/type/@id]">
						<div style="margin:5px 0 10px 0;">
							<h4><xsl:value-of select="."/></h4>
							<ul>
								<xsl:for-each select="//categories/category[type/@id=current()/@id]">
									<li>
										<div style="display:none" id="catMenuImg_{$uid}_{@id}">
											<xsl:if test="not(image='')"><img src="http://pic.djerelo.info/img/hotcat/objects/{../@objid}/categories/{@id}/album/{image}/mini.jpg"/></xsl:if>
										</div>
										<a href="/{//presets/lang}/cat/{../object/account}/categories/{@id}" onmouseover="putItThere('catMenuImg_{$uid}_{@id}', 'catMenuImg_{$uid}')" onmouseout="putItThere('mainMenuImg_{$uid}', 'catMenuImg_{$uid}')"><xsl:value-of select="name"/></a>
									</li>
								</xsl:for-each>
							</ul>
						</div>
					</xsl:for-each>
					
					
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="block[name='objlist']" mode="accordion">
		<xsl:variable name="block_id" select="@id"/>
		<div class="rounded-box-3">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
				<div class="inner-box">
					<h3>title: <xsl:value-of select="title"/></h3>
				</div>
				
				<div class="hotel_list">
					<xsl:for-each select="//content/objects/object">
						<xsl:variable name="objid" select="@id"/>
						<div class="header" id="objMenuHeader_{@id}" onclick="do_or_close('/prg/bexec.php', 'objMenuHeader_{@id}', 'objMenuContent_{@id}', 'post')">
							<strong><xsl:value-of select="name"/></strong>, <xsl:value-of select="city"/>
							<input type="hidden" name="mod_name" value="objmenu" />
							<input type="hidden" name="mod_temp" value="standart/modules.xslt" />
							<input type="hidden" name="mod_param" value="{@id}" />
						</div>
						<div id="objMenuContent_{@id}">
						<!--
							<table>
								<tr>
									<td width="100"></td>
									<td>
										<xsl:for-each select="//cat-types/type[@id=current()/categories/category/type/@id]">
											<div style="margin:5px 0;">
												<h4><xsl:value-of select="."/></h4>
												<ul>
													<xsl:for-each select="//object[@id=$objid]/categories/category[type/@id=current()/@id]">
														<li><a href="/{/out/@lang}/{//object[@id=$objid]/account}/categories/{@id}"><xsl:value-of select="name"/></a></li>
													</xsl:for-each>
												</ul>
											</div>
										</xsl:for-each>
									</td>
								</tr>
							</table>
						-->
						</div>
					</xsl:for-each>
				</div>
				<div id="objMenuContent"></div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
	</xsl:template>

</xsl:stylesheet>