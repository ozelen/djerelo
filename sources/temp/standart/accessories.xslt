<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
	

	</xsl:template>

	<xsl:template name="head-includes">
		<xsl:param name="add"/>
		<link href="/css/ui/default/uistyle.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="/css/uni/main.css" />
		<link rel="stylesheet" href="/css/sites/{/out/@domain}/iface.css" />
		
		<script type="text/javascript" src="/js/langs/{//presets/lang}.js"></script>

		<script type="text/javascript" src="/js/jquery/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui-1.8.10.custom.min.js"></script>

		<!-- Menu -->

		<link type="text/css" href="/plugins/menu/menu.css" rel="stylesheet" />
		<script type="text/javascript" src="plugins/menu/menu.js"></script>

		<xsl:if test="/out/user/@id">
			<input type="hidden" id="sessid" value="{/out/session/@id}" />
			<script type="text/javascript" src="/js/wymeditor/jquery.wymeditor.pack.js"></script>
			<link href="/js/swfupload/lib/css/default.css" rel="stylesheet" type="text/css" />
			<script type="text/javascript" src="/js/swfupload/lib/swfupload/swfupload.js"></script>
			<script type="text/javascript" src="/js/swfupload/lib/swfupload/swfupload.queue.js"></script>
			<script type="text/javascript" src="/js/swfupload/lib/files/js/fileprogress.js"></script>
			<script type="text/javascript" src="/js/swfupload/lib/files/js/handlers.js"></script>
			<script type="text/javascript" src="/js/swfupload/lib/files/definitions.js"></script>
		</xsl:if>

		<![CDATA[<meta name="description" content="]]><inject id="descr-{/out/@lang}"></inject><![CDATA[" />]]> 
		
		<script type="text/javascript" src="/js/slidemenu/settings.js"></script>

		<script src="/js/jquery.forms.js"></script>
		<script src="/js/main.js"></script>



		<xsl:value-of select="$add"/>		

		<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script>-->
		
		
		<link rel="stylesheet" type="text/css" href="/js/fancybox/1.3.1/jquery.fancybox-1.3.1.css" media="screen" />
		<script type="text/javascript" src="/js/fancybox/1.3.1/jquery.fancybox-1.3.1.js"></script>
		<script type="text/javascript" src="/js/fancybox/1.3.1/jquery.mousewheel-3.0.2.pack.js"></script>

		<div id="loading" style="position:absolute; display:none;">Loading!</div>
		
		
		<!-- social networks -->
		<!-- Google Plus -->
		<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
		<!-- vkontakte -->
		<script type="text/javascript" src="http://userapi.com/js/api/openapi.js?34"></script>
		<script type="text/javascript">
		  VK.init({apiId: 2420113, onlyWidgets: true});
		</script>
		<script src="http://connect.facebook.net/en_US/all.js#appId=254414357904369&amp;xfbml=1"></script>
		
	</xsl:template>



	
	<xsl:template match="block[name='pages.menu']">
		<xsl:call-template name="menu">
			<xsl:with-param name="page" select="content/menu/@page"/>
		</xsl:call-template>
	</xsl:template>
	

	
	<xsl:template match="block/content/menu" name="menu">
		<xsl:param name="page" select="@page"/>
		<div class="ui-corner-all widget-header"><xsl:value-of select="//page[@id=$page]/title"/></div>


		<xsl:for-each select="//sitemap//page[@parent=$page]">
			<xsl:sort data-type="text" select="title"/>
				<ul><a href="/{/out/@lang}{uri}" style="text-decoration:none"><xsl:value-of select="title"/></a>
					<!--<xsl:if test="pages/page"></xsl:if>-->
					<ul>
						<xsl:for-each select="pages/page">
							<li><a href="/{/out/@lang}{uri}"><xsl:value-of select="title"/></a></li>
						</xsl:for-each>
					</ul>
				</ul>
			<!--<h3></h3>-->
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template name="header">
		<xsl:param name="navigation"/>
				<div style=" position:absolute; margin-left:474px; margin-top:35px; z-index:11; width:160px">
				
				</div>
		
				<div class="ddMenuDiv">
				
				<!--	
				<div class="rounded-box-main_menu" style=" position:absolute; margin-left:644px; margin-top:35px; z-index:11; width:160px">
					<b class="r3"></b><b class="r1"></b><b class="r1"></b>
					<div class="inner-box">
						<xsl:if test="/out/user/name">
							<xsl:value-of select="/out/user/name"/>
							<div style="display:none" class="dropdown">
								<xsl:apply-templates select="/out/sitemap//page[@id=335]/pages" mode="listmenu"/>
							</div>
						</xsl:if>
						<xsl:if test="not(/out/user/name)">
							Log In
							<div style="display:none" class="dropdown">
								<xsl:apply-templates select="/out/sitemap//page[@id=341]/pages" mode="listmenu"/>
							</div>
						</xsl:if>
					</div>
					<b class="r1"></b><b class="r1"></b><b class="r3"></b>
				</div>
				-->
				
			</div>
					
		
		<div id="header" style="overflow:hidden;" class="ui-corner-all">
			<a href="http://{/out/@domain}/">
			<div id="head_left">
				<div id="logo"></div>
			</div>
			</a>
			
			<div id="head_right">
            	<xsl:call-template name="langs"/>
            </div>
			<div id="head_mid"></div>
		
			<div style="position:absolute; top:80px; left:200px; width:755px; height:30px">

				<!--<div style="background:url(/img/iface/skiworld/gold_button.png); width:139px; height:22px; float:left;"></div>-->
			</div>
		</div>

		<xsl:apply-templates select="/out/sitemap/pages" mode="mainmenu" />

		<inject id="descr-{/out/@lang}"></inject>
		
		<xsl:if test="$navigation">
			<div id="navigationString">
				<b class="r3"></b><b class="r1"></b><b class="r1"></b>
				<div class="inner-box">
					<xsl:copy-of select="$navigation"/>
					<div style="clear:both"></div>
				</div>
				<b class="r1"></b><b class="r1"></b><b class="r3"></b>
			</div>
		</xsl:if>
		<xsl:if test="not($navigation)">
			<div style="height:10px"></div>
		</xsl:if>
		
	</xsl:template>
	
    <xsl:template name="langs">
    	<div style="float:right; margin-top:30px; margin-right:10px">
            <xsl:if test="/out/@lang='ru'">
                <a href="{/out/home}/ua/{/out/presets/uri}" style="color:#FFF">Українською</a>
            </xsl:if>
            <xsl:if test="/out/@lang='ua'">
                <a href="{/out/home}/ru/{/out/presets/uri}" style="color:#FFF">Русская версия сайта</a>
            </xsl:if>
            
        </div>
    </xsl:template>
    
	<xsl:template name="footer">
			<br />
			<div id="footer">
				<div style="height:40px">
				</div>
				<div style="height:40px">
					<div style="float:right; position:absolute; margin:10px" class="sl1;">
						<inject id="sape"></inject>
						<!-- <xsl:apply-templates select="//sape/link[@id=1]"/> &amp;nbsp; <xsl:apply-templates select="//sape/link[@id=2]"/> -->
					</div>
				</div>
				<div class="rounded-box-3">
					<b class="r3"></b><b class="r1"></b><b class="r1"></b>
					<div class="inner-box">
						<div>
							
							<div style="margin-left:650px; height:70px">
								&amp;copy; Zelenyuk Brothers<br />
								Djerelo.Info, tourist Webprojects
							</div>
							<div class="sl1" style="position:absolute">
								
								<!--
								<xsl:apply-templates select="//sape/link[@id=3]"/>, 
								<xsl:apply-templates select="//sape/link[@id=4]"/>
								-->
							</div>
						</div>
					</div>
					<b class="r1"></b><b class="r1"></b><b class="r3"></b>
				</div>
			</div>
			
			<div style="display:none">
                    <!-- Counters -->
                    <table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td style="padding-left:20" valign="top" width="88" height="31">
								<div style="position:absolute">
								
								<!-- MyCounter v.2.0 
								<script type="text/javascript" src="/js/test.js"></script>
								<script type="text/javascript" src="http://scripts.mycounter.com.ua/counter2.0.js"></script>
								<noscript><a rel="nofollow" target="_blank" href="http://mycounter.com.ua/"><img src="http://get.mycounter.com.ua/counter.php?id=10892" title="MyCounter - Ваш счётчик" alt="MyCounter - Ваш счётчик" width="88" height="41" border="0" /></a></noscript>
								 MyCounter -->
								</div>
							</td>
						</tr>
					</table>
			</div>
			
	</xsl:template>
	
	
	<xsl:template match="pages" mode="listmenu">
		<ul>
			<xsl:for-each select="page[not(title='')]">
				<li><a href="/{/out/@lang}{uri}"><xsl:value-of select="title"/></a></li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	
	<xsl:template match="pages" mode="multilevel_listmenu">
		<ul>
			<xsl:apply-templates select="page" mode="multilevel_listmenu"/>
		</ul>
	</xsl:template>
	<xsl:template match="page" mode="multilevel_listmenu">
		<xsl:if test="title">
		<li>
			<a href="/{/out/@lang}{uri}"><xsl:value-of select="title"/></a>
			<xsl:if test="pages/page">
				<ul>
					<xsl:apply-templates select="pages/page" mode="multilevel_listmenu"/>
				</ul>
			</xsl:if>
		</li>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="blk">
		<xsl:param name="header"/>
		<xsl:param name="content"/>
		<div class="rounded-box-3">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
			<div class="inner-box">
				<h3><xsl:value-of select="$header"/></h3>
				<xsl:if test="$content">
					<p>
						<xsl:copy-of select="$content"/>
					</p>
				</xsl:if>
			</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
	</xsl:template>
	
	
	<xsl:template name="submenu">
		<xsl:apply-templates select="/out/sitemap//page[@id=/out/current/page/@id]/pages" mode="listmenu"/>
	</xsl:template>





	<xsl:template name="sysmsg" match="sysmsg/message">
		<xsl:param name="header"/>
		<xsl:param name="type" select="@type"/>
		<xsl:param name="id" select="@id"/>
		<xsl:param name="content" select="."/>
		<div class="sysmsg_{$type}" style="margin:5px 0;;">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
			<div class="inner-box">
				<xsl:copy-of select="$content"/>
				<xsl:value-of select="//locale/c[@id=$id]" />
			</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
	</xsl:template>
	
	<xsl:template match="location">
		<xsl:param name="zoom" select="14"/>
		<xsl:param name="height" select="320"/>
		<div id="viewport" style="height: {$height}px;">
		  <a id="visicom_copyright_link" href="http://maps.visicom.ua/">карта крыма</a>
		  	<input type="hidden" id="lat" value="{@lat}"/>
			<input type="hidden" id="lng" value="{@lng}"/>
			<input type="hidden" id="zoom" value="{$zoom}"/>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/map/world_ru.js"></script>
			<script type="text/javascript" src="http://maps.visicom.ua/api/2.0.0/services/address.js"></script> 
			<script type="text/javascript" src="/js/visicom/settings.js"></script>
		</div>
		<!--<div id="searchWidget" style="height: 200px;"></div>-->
	</xsl:template>
	
	<xsl:template match="sape/link">
		<xsl:value-of select="."/>
	</xsl:template>
	
	
	<!-- *** Display modes for standart elements *** -->
	
	<xsl:template match="page" mode="display">
		<xsl:param name="viewmode"/>
		<xsl:param name="objid"/>
		<xsl:param name="field"/>
		<xsl:param name="content"/>
		<xsl:param name="lang" select="/out/@lang"/>
		<xsl:param name="db" select="'hotelbase'"/>
		<xsl:param name="tbl" select="'Objects'"/>
		
		<xsl:variable name="uid" select="generate-id()"/>
		
		<xsl:if test="$viewmode = 'admin' or $viewmode = 'subadmin'">

			<xsl:if test="$field='title'">
				<ul class="icons ui-widget ui-helper-clearfix" style="float:right">
					<li class="ui-widget-header ui-corner-all" onclick="winPageEdit('{$uid}', {@id})" title="Edit"><span class="ui-icon ui-icon-pencil"></span></li>
				</ul>
			</xsl:if>
			<xsl:if test="$field='source'">
				<div class=" ui-widget-header ui-corner-top" style="margin:5 0">
					<ul class="icons ui-widget ui-helper-clearfix">
						<li class="ui-state-default ui-corner-all" onclick="winPageEdit('{$uid}', {@id})" title="Edit"><span class="ui-icon ui-icon-pencil"></span></li>
					</ul>
				</div>
			</xsl:if>
			
				<div id="win_{$uid}" title="{title}" style="display:none">
				
					<form class="pageform" id="form_{$uid}" target="editform_{$uid}" action="/prg/editpage.php?lang={$lang}&amp;mode=postdata&amp;format=xml">
						<a class="editform" href="/prg/editpage.php?lang={$lang}&amp;multiform=true&amp;mode=view"></a>
						<a class="content" href="/prg/editpage.php?lang={$lang}&amp;mode=onefield&amp;field={$field}"></a>
						
						<a class="getfield" href="/prg/editpage.php?lang={$lang}&amp;mode=getfield"></a>
						<input type="hidden" name="uid" value="{$uid}"/>
						<input type="hidden" name="db" value="{$db}"/>
						<input type="hidden" name="tbl" value="{$tbl}"/>
						<input type="hidden" name="id" value="{$objid}"/>
						<input type="hidden" name="PageId" value="{@id}"/>
						<input type="hidden" name="temp" value="edit/editpage"/>
						<input type="hidden" name="clang" value="{$lang}"/>
						
						<div id="editform_{$uid}">
						
						</div>
					</form>
				</div>
		</xsl:if>
		<div id="content_{$uid}" class="page_{@id}_{$field}"><xsl:value-of select="$content"/></div>
	</xsl:template>
	
	<xsl:template match="page/title" mode="display">
		<xsl:param name="viewmode"/>
		<xsl:if test="$viewmode = 'admin' or $viewmode = 'subadmin'">
			<ul class="icons ui-widget ui-helper-clearfix" style="float:right">
				<li class="ui-state-default ui-corner-all" title="Edit"><span class="ui-icon ui-icon-pencil"></span></li>
			</ul>
		</xsl:if>
		<xsl:value-of select="."/>
	</xsl:template>


	<!-- Main menu -->
	<xsl:template match="pages" mode="mainmenu">
		<xsl:param name="class" select="'menu'" />
		<xsl:param name="level" select="'root'" />
		<div style="z-index:8" class="ui-helper-clearfix">
			<xsl:if test="$level='root'">
				<xsl:attribute name="id">menu</xsl:attribute>
			</xsl:if>
			<ul class="{$class}">
				<xsl:if test="$level='root'">
					<li>
						<a href="/"><span><xsl:value-of select="//locale/c[@id='standarts.homepage']"/></span></a>
					</li>
				</xsl:if>
				<xsl:apply-templates select="page[params/mainmenu]" mode="mainmenu">
					<xsl:sort select="params/mainmenu" order="ascending" data-type="number" />
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="page" mode="mainmenu">
		<li>
			<xsl:choose>
				<xsl:when test="params/linktype='alias'">
					<xsl:param name="aliasId" select="params/direct" />
					<xsl:param name="alias" select="//sitemap//page[@id=$aliasId]" />
					<a href="/{/out/@lang}{$alias/uri}/">
						<xsl:if test="pages/page[params/mainmenu]"><xsl:attribute name="class">parent</xsl:attribute></xsl:if>
						<span><xsl:value-of select="$alias/title" class="{$parent}" /></span>
					</a>
				</xsl:when>
				<xsl:when test="params/linktype='url'">
					<a href="{params/href}">
						<xsl:if test="pages/page[params/mainmenu]"><xsl:attribute name="class">parent</xsl:attribute></xsl:if>
						<xsl:if test="params/target"><xsl:attribute name="target"><xsl:value-of select="params/target"/></xsl:attribute></xsl:if>
						<span><xsl:value-of select="title" class="{$parent}" /></span>
					</a>
				</xsl:when>
				<xsl:when test="params/linktype='uri'">
					<a href="/{/out/@lang}/{params/uri}">
						<xsl:if test="pages/page[params/mainmenu]"><xsl:attribute name="class">parent</xsl:attribute></xsl:if>
						<span><xsl:value-of select="title" class="{$parent}" /></span>
					</a>
				</xsl:when>

				<xsl:otherwise>
					<xsl:param name="selfId" select="@id" />
					<xsl:param name="page" select="//sitemap//page[@id=$selfId]" />
					<a href="/{/out/@lang}{uri}/">
						<xsl:if test="pages/page[params/mainmenu]"><xsl:attribute name="class">parent</xsl:attribute></xsl:if>
						<span><xsl:value-of select="title" /></span>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="pages/page[params/mainmenu]">
				<xsl:apply-templates select="pages" mode="mainmenu" >
					<xsl:with-param name="level" select="'sub'" />
					<xsl:sort select="params/mainmenu" order="ascending" data-type="number" />
				</xsl:apply-templates>
			</xsl:if>
		</li>
	</xsl:template>

</xsl:stylesheet>