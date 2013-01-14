<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="prices.xslt"/>
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	
    <xsl:template match="/">
		<xsl:apply-templates select="categories"/>
	</xsl:template>
	
	
	<xsl:template match="categories" mode="controls">
	
		<xsl:param name="obj"/>
		<xsl:variable name="objid" select="$obj/@id"/>
		<xsl:variable name="object" select="$obj"/>
		
		<xsl:param name="objclasses" select="$object/classify"/>
		<xsl:param name="objprofclass" select="$objclasses/class[@profile='Objects']/val/@id"/>
		<xsl:param name="objclasstree" select="//sitemap//page[@id=$objprofclass]"/>
		<xsl:param name="objclasstree-cat" select="//sitemap//page[@id=$objprofclass]/pages/page[name='categories']"/>
		
		<xsl:variable name="objclassify" select="concat($objclasstree/uri, '/classify')"/>

		<div class=" ui-widget-header ui-corner-top" style="margin-top:30">
			<ul class="icons ui-widget ui-helper-clearfix">
				<li class="ui-state-default ui-corner-all" onclick="winCategories({$obj/@id})" title="Edit Categories"><span class="ui-icon ui-icon-pencil"></span></li>
				<li class="ui-state-default ui-corner-all" onclick="globalCatRefresh()" title="Refresh Categories"><span class="ui-icon ui-icon-refresh"></span></li>
			</ul>
		</div>
		<div id="winCategories" title="Edit Categories" style="display:none" class="control-area">
			<form class="toobar-form" action="/prg/editobj.php">
				<input type="hidden" name="objid" value="{$objid}" />
				<input type="hidden" name="lang" value="{/out/@lang}" />
				<input type="hidden" name="temp" value="edit/hotcat/categories.xslt" />
			</form>
			<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-top toolbar" uid="{@id}">
				<li class="ui-state-default ui-corner-all not-glue" onclick="catRefresh()" title="Refresh Categories"><span class="ui-icon ui-icon-refresh"></span></li>
				<li class="ui-state-default ui-corner-all not-glue" onclick="winClassify('Categories', 'new')" title="Add Category"><span class="ui-icon ui-icon-plus"></span></li>
				<li class="ui-state-default ui-corner-all" setting="selectable" title="Select Categories"><span class="ui-icon ui-icon-arrow-1-nw"></span></li>
				<li class="ui-state-default ui-corner-all" setting="sortable" title="Sort Categories"><span class="ui-icon ui-icon-shuffle"></span></li>
			</ul>
			
			<div class="submenu">
				<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-bottom selectable" style="display:none">
					<li class="ui-state-default ui-corner-all" title="Delete Selected" onclick="delSelectedCategories('winCategories')"><span class="ui-icon ui-icon-trash"></span></li>
				</ul>
				<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-bottom sortable" style="display:none">
					<li class="ui-state-default ui-corner-all" title="Save changes" onclick="saveSortCategories('winCategories')"><span class="ui-icon ui-icon-disk"></span></li>
					<li class="ui-state-default ui-corner-all" title="Cancel changes" onclick="cancelSortCategories('winCategories')"><span class="ui-icon ui-icon-cancel"></span></li>
				</ul>
			</div>
			
			
			<div class="actzone">

			</div>
			
			<xsl:call-template name="WinClassify">
				<xsl:with-param name="owner_tbl">Categories</xsl:with-param>
				<xsl:with-param name="owner_id">new</xsl:with-param>
				<xsl:with-param name="uri" select="$objclasstree-cat/uri"/>
				<xsl:with-param name="fields">
					<input type="hidden" name="objid" value="{$obj/@id}" />
					<fieldset>
					<legend><xsl:value-of select="//c[@id='hotcat.categories.add.name']"/></legend>
						<input type="text" name="name" style="width:100%"/>
					</fieldset>
				</xsl:with-param>
			</xsl:call-template>
			
			<div id="addCategoryWin" style="display:none" title="Add Category">
				<form action="/prg/editobj.php">
					<xsl:apply-templates select="//pages/page[uri=$objclassify]">
					
					</xsl:apply-templates>
				</form>
			</div>
			
		</div>
	</xsl:template>
	
	<xsl:template match="categories" mode="totalpricetable">
	
		<xsl:variable name="objid" select="@objid"/>
		<xsl:variable name="object" select="//object"/>
		<xsl:variable name="periods" select="../periods"/>
		
		<xsl:param name="objclasses" select="$object/classify"/>
		<xsl:param name="objprofclass" select="$objclasses/class[@profile='Objects']/val/@id"/>
		<xsl:param name="objclasstree" select="//sitemap//page[@id=$objprofclass]"/>
		<xsl:param name="objclasstree-cat" select="//sitemap//page[@id=$objprofclass]/pages/page[name='categories']"/>
		
		<!-- ************************************  Total Price Table ************************************ -->
		
		<xsl:if test="$periods/period or (//object/@viewmode='admin' or //object/@viewmode='subadmin' or //object/@viewmode='user')">
		<div class="pricetable total">
			<form class="sendprice" action="/prg/editobj.php?mode=saveprices&amp;objid={$objid}">
			<xsl:if test="(//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user')">
				<div class="ui-widget-header ui-corner-top headerpanel">
					<button class="open" ico="ui-icon-pencil" ico2="ui-icon-triangle-1-s" type="button"><xsl:value-of select="//c[@id='standarts.edit']"/></button>
					<button class="save" ico="ui-icon-disk" style="display:none"><xsl:value-of select="//c[@id='standarts.save']"/></button>
					
					<div class="ajax_loader send">Sending</div>
					<div class="ajax_loader refresh">Refreshing</div>
				</div>						
			</xsl:if>
			<div class="content">
				
				<xsl:if test="$periods/period and @per=''"><p><xsl:value-of select="//c[@id='hotcat.object.pricetable.periods.undefined']"/></p></xsl:if>
				<xsl:if test="not(@per='')">
					<xsl:call-template name="pricetable-totalperiod">
						<xsl:with-param name="periods" 	select="$periods"/>
					</xsl:call-template>
				</xsl:if>
				
				
			</div>
			</form>
			<form class="refreshpricetable" target="parent_element" action="/prg/editobj.php?mode=refreshpricetable">
				<input type="hidden" name="objid" value="{$objid}" />
				<input type="hidden" name="perid" value="{$periods/period[position()=1]/@id}" />
				<input type="hidden" name="mode" value="totalperiod" />
				<input type="hidden" name="temp" value="hotcat/prices-alone.xslt" />
				<!--<button>Refresh</button>-->
			</form>
		</div>
		</xsl:if>
		<!-- / Total Price Table -->
	</xsl:template>
	
	
	<xsl:template match="categories" mode="collapse">
		<xsl:variable name="objid" select="@objid"/>
		<xsl:variable name="object" select="//object"/>
		<xsl:variable name="periods" select="../periods"/>
		
		<xsl:param name="objclasses" select="$object/classify"/>
		<xsl:param name="objprofclass" select="$objclasses/class[@profile='Objects']/val/@id"/>
		<xsl:param name="objclasstree" select="//sitemap//page[@id=$objprofclass]"/>
		<xsl:param name="objclasstree-cat" select="//sitemap//page[@id=$objprofclass]/pages/page[name='categories']"/>
		
		<div class="">

		<!-- ************************************ Categories ******************************************** -->
		<!-- <textarea><xsl:copy-of select="/out/sitemap//page[@id=$objprofclass]" /></textarea> -->
		<xsl:for-each select="$objclasstree-cat/pages/page">
			<xsl:variable name="classid" select="@id"/>
			<xsl:variable name="items" select="//categories/category[classify/class/val/@id=$classid]"/>
			<xsl:if test="$items">
				<h3><xsl:value-of select="title"/></h3>
			</xsl:if>
			<xsl:for-each select="$items">
				<!--<textarea cols="50" rows="20"><xsl:copy-of select="classify"/></textarea>-->
				<xsl:variable name="catid" select="@id"/>
				<xsl:variable name="price" select="//period/prices/price[@catid=$catid]"/>
				
				<!-- Classification links of current Category -->
				<xsl:variable name="classify" select="classify"/>	
				
				<!-- ID of Classification link which detect Category <profile> parameter -->
				<xsl:param name="catprofclass" select="$classify/class[val/@id=//sitemap//page[params/profile[.='Categories']]/@id]/val/@id"/> 
				<!-- Definition Tree for Category, use <profile> class by class link -->
				<xsl:param name="catprofclasstree" select="//sitemap//page[@id=$catprofclass]"/>
				
				<!-- -->
				<xsl:param name="nameclass-id" select="$classify/class[val/@id=//sitemap//page[params/nameof[.='Categories']]/@id]/val/@id"/> 
				<xsl:param name="nameclass" select="//sitemap//page[@id=$nameclass-id]/title"/>
				
				<!-- Parent Classificator of all Categories for this Object -->
				<!-- created for non-duplicate (use "Alias" field) parameters in output, Category calls his own thread of class definitons -->
				<xsl:param name="catclasstree" select="$objclasstree-cat"/>	
				
				
				
			<div class="categories closed ui-state-default ui-corner-all" onclick="pageTracker._ trackPageview('/{/out/@lang}/{$object/account}/categories/{@id}/');" style="margin:2px 0">
				<table width="100%" style="margin:1px">
				<tr>
					<td width="50" height="50" style="padding:2px 5px; width:50px">
						<xsl:if test="not(image='')">

							<img src="http://pic.djerelo.info/crop/img/hotcat/objects/{../@objid}/categories/{@id}/album/{image}/thumb.{image/@ext}"/>
						</xsl:if>
					</td>
					<td style="vertical-align:middle;">
						<h3>
							<xsl:apply-templates select="page" mode="display">
								<xsl:with-param name="objid" select="$obj/@id"/>
								<xsl:with-param name="viewmode" select="$obj/@viewmode"/>
								<xsl:with-param name="content" select="page/title"/>
								<xsl:with-param name="field">title</xsl:with-param>
							</xsl:apply-templates>
						</h3>
						<xsl:if test="$nameclass and page/title=''">
							<h3><xsl:value-of select="$nameclass"/></h3>
						</xsl:if>
						<xsl:if test="$nameclass and not(page/title='')">
							/<xsl:value-of select="$nameclass"/>/
						</xsl:if>
					</td>
					<td></td>
					<td width="200">
						<!--
						<xsl:if test="$price>0">
							<xsl:value-of select="$price"/>
						</xsl:if>
						-->
						<ul id="prices_{$catid}" class="catPriceList" style="padding:0; margin:0; list-style:none">
							<xsl:for-each select="$periods/period">
								<xsl:variable name="perid" select="@id"/>
								<li id="per_{@id}" class="per_{@id}" style="padding:0; margin:0; line-height:80%">
									<xsl:variable name="difprice" select="$periods/period[@id=$perid]/week/cat[@id=$catid]"/>
									<xsl:variable name="statprice" select="prices/price[@catid=$catid]"/>
									
									
									<xsl:if test="$difprice[@max>@min] or $statprice>0">
									<div class="price big" style="text-align:center">
										<xsl:choose>
											<xsl:when test="$difprice[@max>@min]">
												<span style="font-size:14px"><xsl:value-of select="//c[@id='standarts.from']"/></span> 
												<span><xsl:value-of select="$difprice/@min"/>&amp;nbsp;</span>
											</xsl:when>
											<xsl:otherwise><span><xsl:value-of select="$statprice"/></span></xsl:otherwise>
										</xsl:choose>
										<span style="font-size:14px"><xsl:value-of select="//c[@id='currency']/cur[@id=//object/currency]/@short"/></span>
									</div>
										
									<div style="font-size:10px; text-align:center; color:#666; margin-top:2px">
										<xsl:value-of select="//c[@id='standarts.from']"/>&amp;nbsp;<xsl:apply-templates select="date[@id='begin']" mode="with-month"/>
										<br/>
										<xsl:value-of select="//c[@id='standarts.to']"/>&amp;nbsp;<xsl:apply-templates select="date[@id='end']" mode="with-month"/>
									</div>
									
									</xsl:if>
									

								</li>
							</xsl:for-each>
						</ul>
					</td>
				</tr>
				</table>
				
				<div class="details" style="margin:10px 5px">

					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
						
							<xsl:if test="not(image='') or //object/@viewmode = 'admin' or //object/@viewmode = 'subadmin'">
							<td width="290">
								
								<div style="vertical-align:middle; text-align:center;">
									<xsl:apply-templates select="xalbum/album[//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin']" mode="controls">
										<xsl:with-param name="owner_id" select="@id"/>
									</xsl:apply-templates>
									
								<xsl:if test="not(image='')">
									<a class="zoom ui-corner-all" title="{name}" href="http://pic.djerelo.info/img/hotcat/objects/{$objid}/categories/{$catid}/album/{image}/big.{image/@ext}">
									<div style="background:url(http://pic.djerelo.info/title_/img/hotcat/objects/{$objid}/categories/{$catid}/album/{image}/big.{image/@ext}) center no-repeat; width:290px;" class="ui-corner-all ui-widget-content">
									
										<img src="http://pic.djerelo.info/title_/img/hotcat/objects/{$objid}/categories/{$catid}/album/{image}/big.{image/@ext}"/>
									
									</div>
									</a>
								</xsl:if>
								</div>
								<div style="clear:both">
									<xsl:apply-templates select="xalbum/album" mode="crop"/>
								</div>
							</td>
							</xsl:if>
							<td>
									
								<xsl:if test="not(info='')">
									<p class="mainTextArea" style="padding:0 10px 0 25px"><xsl:value-of select="info"/></p>
								</xsl:if>
									
								<xsl:if test="//object/@viewmode='admin'">
								<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-top toolbar" uid="{@id}">
									<li class="ui-state-default ui-corner-all not-glue" onclick="winClassify('Categories', {@id})" title="Classificator"><span class="ui-icon ui-icon-tag"></span></li>
								</ul>
								</xsl:if>
													
								<ul style="padding:0 25px">
								<xsl:for-each select="$catprofclasstree//page[@id=$classify/class/key/@id]">
									<xsl:variable name="id" select="@id"/>
									<xsl:if test="not(params/visibility='hidden')">
									<li>
										<xsl:value-of select="title"/>
										<xsl:if test="params/classtype=radio"> &amp;mdash; <xsl:value-of select="val"/></xsl:if>
										<xsl:if test="not(params/classtype=radio)">:
										<ul style="padding:2px 20px">
											<xsl:for-each select="$classify/class[key/@id=$id]">
												<li><xsl:value-of select="val"/></li>
											</xsl:for-each>
										</ul>
										</xsl:if>
									</li>
									</xsl:if>
								</xsl:for-each>
								</ul>
								
								<xsl:call-template name="WinClassify">
									<xsl:with-param name="owner_tbl">Categories</xsl:with-param>
									<xsl:with-param name="owner_id" select="@id"/>
									<xsl:with-param name="uri">/classes/objects/services/hotels/categories</xsl:with-param>
								</xsl:call-template>
								
							
		
								
							</td>
						</tr>
					</table>
				
				<xsl:variable name="dow" select="/out/locale//c[@id='dow']"/>
				<xsl:if test="$periods/period/week/cat[@id=$catid and day>0] or //object/@viewmode='admin'">
					<div class="pricetable">
					
						<form class="sendprice" action="/prg/editobj.php?mode=saveprices&amp;objid={$objid}">

						<xsl:if test="//object/@viewmode = 'admin' or //object/@viewmode = 'subadmin' or //object/@viewmode = 'user'">
							<div class="ui-widget-header ui-corner-top headerpanel">
								<button class="open" ico="ui-icon-pencil" ico2="ui-icon-triangle-1-s" type="button"><xsl:value-of select="//c[@id='standarts.edit']"/></button>
								<button class="save" ico="ui-icon-disk" style="display:none"><xsl:value-of select="//c[@id='standarts.save']"/></button>
								
								<div class="ajax_loader send">Sending</div>
								<div class="ajax_loader refresh">Refreshing</div>
							</div>						
						</xsl:if>

						<div class="content">

							<xsl:call-template name="pricetable">
								<xsl:with-param name="dow" 		select="$dow"/>
								<xsl:with-param name="periods" 	select="$periods"/>
								<xsl:with-param name="catid" 	select="$catid"/>
							</xsl:call-template>
						</div>

						</form>
						
						<form class="refreshpricetable" target="parent_element" action="/prg/editobj.php?mode=refreshpricetable">
							<input type="hidden" name="objid" value="{$objid}" />
							<input type="hidden" name="catid" value="{$catid}" />
							<input type="hidden" name="temp" value="hotcat/prices-alone.xslt" />
							<!--<button>Refresh</button>-->
						</form>
						
					</div>
				</xsl:if>
				
				</div>
				
				</div>
			</xsl:for-each>
			
		
		</xsl:for-each>
		</div>
	</xsl:template>
	
	

	
	

	
	
	
	
	
	<xsl:template name="dropdownperiods" match="periods" mode="dropdown">
		<xsl:param name="obj"/>
		<xsl:param name="per" select="$obj/periods"/>
			<xsl:if test="$obj/@viewmode = 'admin' or $obj/@viewmode = 'subadmin' or //object/@viewmode = 'user'">
				<ul class="icons ui-widget ui-helper-clearfix" style="float:right">
					<li class="ui-state-default ui-corner-all" onclick="win('addperiod')" title="{//c[@id='hotcat.object.pricetable.periods.add']}"><span class="ui-icon ui-icon-circle-plus"></span></li>
					<li class="ui-state-default ui-corner-all" onclick="delPer()" title="{//c[@id='hotcat.object.pricetable.periods.del']}"><span class="ui-icon ui-icon-trash"></span></li>
				</ul>
				
			<div id="addperiod" class="win" style="display:none; text-align:center;" title="{//c[@id='hotcat.object.pricetable.periods.add.dialog']}">
				<form class="addperiod" action="/prg/editobj.php?mode=addper" datatype="json">
					<input type="hidden" name="objid" value="{$obj/@id}" />
					<h3 style="text-align:center"><xsl:value-of select="//c[@id='hotcat.object.pricetable.periods.add.dialog']"/></h3>
					<label for="addPerFrom">From</label>
					<input type="text" alt="addPerFrom_alt" id="addPerFrom"/>
					<input type="hidden" id="addPerFrom_alt" name="from"/>
					<label for="addPerTo">to</label>
					<input type="text" id="addPerTo" alt="addPerTo_alt"/>
					<input type="hidden" id="addPerTo_alt" name="to"/>
					<p><button ico="ui-icon-disk"><xsl:value-of select="//c[@id='standarts.save']"/></button></p>
				</form>
			</div>
				
			</xsl:if>
			
			<select class="dropdownperiods">
				<xsl:for-each select="$per/period">	
				<option value="{@id}"><xsl:value-of select="//c[@id='standarts.from']"/>&amp;nbsp;<xsl:apply-templates select="date[@id='begin']" mode="with-month"/>&amp;ndash;<xsl:value-of select="//c[@id='standarts.to']"/>&amp;nbsp;<xsl:apply-templates select="date[@id='end']" mode="with-month"/></option>
				</xsl:for-each>
			</select>
			

			
	</xsl:template>
	
	<xsl:template match="date" mode="with-month">
		<xsl:value-of select="d"/>&amp;nbsp;<xsl:value-of select="//c[@id='of-month']/m[@id=current()/m]"/>&amp;nbsp;<xsl:value-of select="y"/>
	</xsl:template>
	


</xsl:stylesheet>