<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
	<xsl:include href="sources/temp/hotcat/mini-gallery.xslt"/>
	<xsl:include href="sources/temp/hotcat/categories.xslt"/>
	<xsl:include href="sources/temp/standart/forum.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/standart/classify.xslt"/>
    <xsl:template match="/">
	<!-- ****************** -->
		<xsl:variable name="current" select="/out/current//objects/object"/>
		<xsl:variable name="lang" select="/out/@lang"/>
		<xsl:variable name="nav">
				<ul>
					<li><a href="{/out/home}/{$lang}/"><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></a>
						<ul>
							<li><a href="{/out/home}/{$lang}/goto/{$current/city/@ident}/"><xsl:value-of select="$current/city"/></a>
								<ul>
									<li><a href="/{$lang}/goto/{$current/city/@ident}/infrastructure/{$current/profile/@id}"><xsl:value-of select="$current/profile"/></a>
										<ul>
											<li><a href="{/out/home}/{$lang}/goto/{$current/city/@ident}/infrastructure/{$current/type/@id}/"><xsl:value-of select="$current/type"/></a>
												<ul>
													<li> <b><xsl:value-of select="$current/name"/></b></li>
												</ul>
											</li>
										</ul>
									</li>
								</ul>
							</li>
						</ul>
					</li>
				</ul>	
		</xsl:variable>
		<xsl:variable name="headers">
			<meta property="og:title" content="{$current/name}"/>
			<meta property="og:type" content="hotel"/> <!-- og classification -->
			<meta property="og:url" content="http://{/out/@domain}/{$current/account}/"/>
			<meta property="og:image" content="http://pic.djerelo.info/img/hotcat/objects/{$current/@id}/albums/{$current/modules/album/name}/{$current/modules/album/title-image/img/@id}/big.jpg"/>
			<meta property="og:site_name" content="Djerelo&amp;gt;Info"/>
			<meta property="fb:admins" content="ozelenyuk"/>
			<script>$(function() {pageTracker._trackEvent('Objects','Visits','<xsl:value-of select="$current/account"/>');});</script>
		</xsl:variable>
		
		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title"><xsl:value-of select="$current/name"/> &amp;mdash; <xsl:value-of select="$current/city"/> / <xsl:value-of select="$current/profile"/> / <xsl:value-of select="$current/type"/>. [<xsl:value-of select="$current/account"/>] <xsl:value-of select="//locale/c[@id='hotcat.object.title.std']" />.  </xsl:with-param>
			<xsl:with-param name="navigation" select="$nav"/>
			<xsl:with-param name="headers" select="$headers"/>
		</xsl:call-template>
	<!-- ****************** -->	
		<xsl:apply-templates select="$current" mode="currentView"/>	
		<xsl:call-template name="DocumentFullFooter"/>
	</xsl:template>
	
	<xsl:template match="object" mode="currentView">
		<xsl:variable name="obj" select="."/>
			<xsl:if test="@viewmode='admin'">
				<div class=" ui-widget-header ui-corner-top" style="margin:5 0">
					<ul class="icons ui-widget ui-helper-clearfix">
						<li class="ui-state-default ui-corner-all" onclick="reCache('objects', {@id})" title="Save Cache"><span class="ui-icon ui-icon-disk"></span></li>
						<li class="ui-state-default ui-corner-all" onclick="winClassify('Objects', {@id})" title="Classify win"><span class="ui-icon ui-icon-tag"></span></li>
						<li class="ui-state-default ui-corner-all" onclick="win('winCallAct')" title="Documents"><span class="ui-icon ui-icon-suitcase"></span></li>
					</ul>
				</div>
			</xsl:if>
			<div id="winCallAct" title="CallAct" style="display:none">
				<div class="tabs">
					<ul>
						<li><a href="/prg/editobj.php?mode=agreements_list&amp;objid={@id}&amp;temp=hotcat%2Fagreements.xslt">Company</a></li>
					</ul>
					<div id="company">
						<xsl:value-of select="company/name"/>
					</div>
				</div>
			</div>
			<xsl:call-template name="WinClassifyObj">
				<xsl:with-param name="obj" select="."/>
			</xsl:call-template>
			<div id="wrapper">
				<div style="margin-right:320px">
					<div class="mainTextArea">
						<xsl:apply-templates select="." mode="content"/>
					</div>
				</div>
			</div>
			<div id="extra_sub">



			<div class="SocRatings" onclick="$.post('http://skiworld.org.ua/plugins/socials/soc.php?objid={@id}&amp;mode=update', function(data){{$('.SocRate_{@id}').html(data)}})">
			<div style="clear:both; height:5px"></div>
				<xsl:call-template name="SocRate" />

				<div style="float:left; width:65px">
					<!-- G+ -->
					<![CDATA[<g:plusone size="medium" href="http://djerelo.info/]]><xsl:value-of select="account"/><![CDATA[/"></g:plusone>]]>
				</div>
				<div style="float:left; width:140px; overflow:hidden">
					<!-- Facebook -->			
					<div id="fb-root"></div>
					<script src="http://connect.facebook.net/en_US/all.js#appId=254414357904369&amp;xfbml=1"></script>
					<![CDATA[<fb:like href="]]>http://<xsl:value-of select="/out/@domain"/>/<xsl:value-of select="account"/>/<![CDATA[" send="true" width="450" show_faces="false"  data-layout="button_count" font=""></fb:like>]]>
				</div>
				<div style="float:left; width:85px">
					<!-- vkontakte -->
					<div id="vk_like"></div><script type="text/javascript">VK.Widgets.Like("vk_like", {type: "mini"}, <xsl:value-of select="@id" />);</script>
				</div>
			</div>
			
				<xsl:apply-templates select="//module[handler='bookit']"/> <!-- Bookit block -->
				<!-- Banners -->
				<xsl:call-template name="subpage-bannerlist"><xsl:with-param name="inside">
						<!-- BANNER -->
						<xsl:call-template name="bn300x110"/>
						<div style="padding-top:20px"></div>
				</xsl:with-param></xsl:call-template>

				<xsl:apply-templates select="classify" mode="icons-descr"/>

				<inject id="adsense-300x250"></inject>

			</div>
			<div class="forum_tabs" style="clear:both; padding-top:30px" id="comments">
				<ul>
					<li><a href="/{/out/@lang}/forums/{topic/@id}/all/"><xsl:value-of select="//locale/c[@id='forum.folders.all']"/></a></li> <!-- All -->
					<!-- <li><a href="/{/out/@lang}/forums/{topic/@id}/book/"><xsl:value-of select="//locale/c[@id='forum.folders.booking']"/></a></li> Booking -->
				</ul>
			</div>
			<xsl:call-template name="forum-form"/>
	</xsl:template>
	
	
	
	
	<xsl:template match="object[@format='cut']" mode="content">
		<xsl:if test="not(info='')">
								<div class="ui-state-highlight ui-corner-all" style="padding: 5px; margin:5px"> 
									<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
									<xsl:copy-of select="/out/locale/c[@id='standarts.hotcat.objects.responsibility.show']"/>
								</div>
		</xsl:if>
		<div style="background:url(http://pic.djerelo.info/title/img/hotcat/objects/{@id}/albums/album/{image/name}/big.jpg) center no-repeat; width:220; float:left; margin-right:10px" class="ui-corner-all">
			<img src="http://pic.djerelo.info/title/img/hotcat/objects/{@id}/albums/album/{image/name}/big.jpg" style="visibility:hidden"/>
		</div>
		<div style="float:left; width:390px; overflow:auto">
			<h1><xsl:value-of select="name"/></h1>
			<div>
				<a href="/{/out/@lang}/goto/{city/@ident}/"><xsl:value-of select="city"/></a>
				/
				<a href="/{/out/@lang}/goto/{city/@ident}/infrastructure/{profile/@id}"><xsl:value-of select="profile"/></a>
				/
				<a href="/{/out/@lang}/goto/{city/@ident}/infrastructure/{type/@id}"><xsl:value-of select="type"/></a>
			</div>
			<xsl:apply-templates select="classify" mode="icons"/>
			<p><xsl:value-of select="contacts"/></p>
		</div>
		<div style="clear:both"><inject id="adsense-468x60"></inject></div>
		<div style="clear:both; padding:10px 0;">
			
				<xsl:if test="location">
					<div class="rounded-box-3" style="margin:10px 0">
						<b class="r3"></b><b class="r1"></b><b class="r1"></b>
						<div class="inner-box">						
							<xsl:apply-templates select="location">
								<xsl:with-param name="zoom" select="15"/>
							</xsl:apply-templates>
						</div>
						<b class="r1"></b><b class="r1"></b><b class="r3"></b>
					</div>
				</xsl:if>
		</div>
		<div>
			<xsl:apply-templates select="classify" mode="icons-descr"/>
			<xsl:value-of select="info"/>
		</div>
	</xsl:template>
	
	<xsl:template match="object[@format='full']" mode="content">
		<xsl:variable name="obj" select="."/>
		<h1 style="margin:10px 0">
			<xsl:apply-templates select="page" mode="display">
				<xsl:with-param name="objid" select="$obj/@id"/>
				<xsl:with-param name="viewmode" select="$obj/@viewmode"/>
				<xsl:with-param name="content" select="page/title"/>
				<xsl:with-param name="field">title</xsl:with-param>
			</xsl:apply-templates>
		</h1>
						
		<div style="clear:both">
	
			<!-- * Main Photo * -->
			<xsl:variable name="titimg" select="modules/album/title-image/img/@id"/>
			<div style="vertical-align:middle; text-align:center; float:left;">
				<a class="zoom ui-corner-all" title="{name}" href="http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/album/{$titimg}/big.jpg">
				<div style="background:url(http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/{modules/album/name}/{$titimg}/big.jpg) center no-repeat; width:610px;" class="ui-corner-all ui-widget-content">
				
					<img src="http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/{modules/album/name}/{$titimg}/big.jpg" style="visibility:hidden"/>
				
				</div>
				</a>
			</div>
			<!-- / Main Photo * -->
			
			<div style="clear:both; height:5px"></div>
				<xsl:if test="@viewmode = 'admin' or @viewmode = 'subadmin'">
					<!--<textarea><xsl:copy-of select="modules"/></textarea>-->
					<xsl:apply-templates select="modules/album" mode="controls"/>
				</xsl:if>
				<xsl:call-template name="album" mode="crop">
					<xsl:with-param name="element" select="//images/img"/>
					<xsl:with-param name="rel">all</xsl:with-param>
				</xsl:call-template>
			<div style="clear:both; height:10px"></div>


			<xsl:if test="not(bookit='')">
				<xsl:call-template name="BookitForm" />
				<div style="clear:both; height:10px"></div>
			</xsl:if>

			<xsl:if test="leave>0 or @viewmode='admin' ">
			<div class="tabs">
				<ul>
					<!-- <li><a href="/{/out/@lang}/booking/Objects/{@id}/"><xsl:value-of select="//c[@id='hotcat.object.free-booking']"/></a></li> -->
					<xsl:if test="@viewmode = 'admin' or leave > 0 ">
						<li><a href="#object-contacts" onclick="pageTracker._ trackPageview('/{/out/@lang}/{account}/contacts/');" ><xsl:value-of select="//locale/c[@id='hotcat.object.contacts']"/></a></li>
					</xsl:if>
				</ul>


				<div id="object-contacts">

					<table width="100%">
						<tr>
							<td class="ui-widget-content ui-corner-all" style="padding:5px" width="50%">
								<xsl:apply-templates select="page/pages/page[name='contacts']" mode="display">
									<xsl:with-param name="objid" select="$obj/@id"/>
									<xsl:with-param name="viewmode" select="$obj/@viewmode"/>
									<xsl:with-param name="content" select="page/pages/page[name='contacts']/source"/>
									<xsl:with-param name="field">source</xsl:with-param>
								</xsl:apply-templates>
								<p>
								<xsl:value-of select="//locale/c[@id='hotcat.object.contacts.link']"/>: <br/>
								<a href="http://{/out/@domain}/{account}/" rel="canonical">http://<xsl:value-of select="/out/@domain"/>/<xsl:value-of select="account"/>/</a><br/>
								
								<xsl:value-of select="//locale/c[@id='hotcat.object.contacts.category']"/>: <xsl:value-of select="type"/><br/>
								<xsl:value-of select="//locale/c[@id='hotcat.object.contacts.location']"/>: <xsl:value-of select="city"/><br/>
								</p>
							</td>
							<td class="ui-state-highlight ui-corner-all" style="padding:5px">
								<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
								<xsl:copy-of select="/out/locale/c[@id='hotcat.object.petition']"/> 
							</td>
						</tr>
					</table>
				</div>

			</div>
			</xsl:if>
								
			<!-- * Main Album * -->
			<xsl:if test="//album[images/img]">
			<div style="float:right; width:320px;"></div>
			</xsl:if>
			<!-- / Main Album * -->

		
						
			<div style="clear:both"></div>
						
						
			<!-- ****** * PRICE TABLE ****** -->
			<xsl:if test="@viewmode='admin' or //period">
				<h2>
					<xsl:value-of select="//locale/c[@id='hotcat.object.pricetable']"/> <!-- CAPTION: Price Table -->
				</h2>
			</xsl:if>
			<xsl:if test="@viewmode='admin'">
				<!--edit periods-->
				<!--<xsl:apply-templates select="periods" mode="panel"/>-->
			</xsl:if>
						
						
			<xsl:if test="periods/period or (@viewmode='admin' or @viewmode='subadmin' or @viewmode='user')">
				<div class="ui-state-highlight ui-corner-all">
					<table width="100%">
						<tr>
							<td><h3 style="margin:5px 20px;"><xsl:value-of select="//locale/c[@id='hotcat.object.pricetable.seasons']"/>:</h3></td>
							<td style="padding-top:3px">
								<xsl:call-template name="dropdownperiods" mode="dropdown">
									<xsl:with-param name="obj" select="$obj"/>
								</xsl:call-template>
							</td>
						</tr>
					</table>
				</div>
			</xsl:if>
						
			<xsl:apply-templates select="categories" mode="totalpricetable">
				<xsl:with-param name="obj" select="$obj"/>
			</xsl:apply-templates>
			<!-- ****** * PRICE TABLE ****** -->
						
						
			<!-- ****** * CATEGORIES ****** -->
			<!-- controls -->
			<xsl:if test="$obj/@viewmode = 'admin' or $obj/@viewmode = 'subadmin'">
				<xsl:apply-templates select="categories" mode="controls">
					<xsl:with-param name="obj" select="$obj"/>
				</xsl:apply-templates>
			</xsl:if>
			<!-- categories list -->
			<form id="refresh_categories" class="ajax" action="http://{/out/fulldom}/{/out/presets/lang}/goto/{@id}/categories-alone/" method="post" target="block_categories"></form>
			<div id="block_categories">
				<xsl:apply-templates select="categories" mode="collapse">
					<xsl:with-param name="obj" select="$obj"/>
				</xsl:apply-templates>
			</div>
			<!-- ****** / CATEGORIES ****** -->
						
			<!-- ****** * MAIN INFO ****** -->

			<xsl:if test="leave&lt;0">
				<inject id="adsense-468x60"></inject>
			</xsl:if>

			<div>
				<xsl:if test="not(page/pages/page[name='info']='')">
					<div style="overflow:auto; margin:20px 0">
						<xsl:apply-templates select="page/pages/page[name='info']" mode="display">
							<xsl:with-param name="objid" select="$obj/@id"/>
							<xsl:with-param name="viewmode" select="$obj/@viewmode"/>
							<xsl:with-param name="content" select="page/pages/page[name='info']/source"/>
							<xsl:with-param name="field">source</xsl:with-param>
						</xsl:apply-templates>
					</div>
				</xsl:if>
			</div>						
			<!-- ****** / MAIN INFO ****** -->
			<h2>
				<xsl:value-of select="//locale/c[@id='hotcat.object.contacts']"/>: <!-- CAPTION: Contacts -->
			</h2>
		
			<div>
				<xsl:if test="leave>0 or @viewmode='admin' ">
				<div class="rounded-box-3">
					<b class="r3"></b><b class="r1"></b><b class="r1"></b>
					<div class="inner-box">
						<xsl:apply-templates select="page/pages/page[name='contacts']" mode="display">
							<xsl:with-param name="objid" select="$obj/@id"/>
							<xsl:with-param name="viewmode" select="$obj/@viewmode"/>
							<xsl:with-param name="content" select="page/pages/page[name='contacts']/source"/>
							<xsl:with-param name="field">source</xsl:with-param>
						</xsl:apply-templates>
					</div>
					<b class="r1"></b><b class="r1"></b><b class="r3"></b>
				</div>
				</xsl:if>

				<xsl:if test="location">
					<div class="rounded-box-3" style="margin:10px 0">
						<b class="r3"></b><b class="r1"></b><b class="r1"></b>
						<div class="inner-box">						
							<xsl:apply-templates select="location">
								<xsl:with-param name="zoom" select="15"/>
							</xsl:apply-templates>
						</div>
						<b class="r1"></b><b class="r1"></b><b class="r3"></b>
					</div>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template match="module[handler='bookit']">
		<xsl:variable name="obj" select="/out/current//objects/object[@id=//presets/uri-vars/objid]"/>
		<h2>
			<xsl:value-of select="//locale/c[@id='bookit.header']"/>: <!-- CAPTION: Map -->
		</h2>
		
		<div class="attention-box" style="margin-bottom:30px">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
				<div class="inner-box" style="font-size:24px; text-align:center">
					<a href="{data/params}" target="_blank"><xsl:value-of select="//locale/c[@id='bookit.link']"/></a>
				</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>		
	</xsl:template>
	

	


	
</xsl:stylesheet>