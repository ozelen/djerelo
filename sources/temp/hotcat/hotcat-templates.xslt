<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="mini-gallery.xslt"/>
	<xsl:import href="gallery-controls.xslt"/>
	<xsl:key name="clas" match="class" use="concat(key/@id, @ownerid)"/>
	
    <xsl:template match="/">

	</xsl:template>


	<xsl:template match="settlements">
		<xsl:variable name="st" select="."/>
		<div class="ui-widget-header ui-corner-all widget-header">
			<h1><xsl:value-of select="//c[@id='hotcat.cities.settlements']"/></h1>
		</div>
		<div style="margin-bottom:20px; padding:10px 0;" class="ui-widget-content ui-corner-all">
			<xsl:for-each select="regions/region">
				<xsl:variable name="regid" select="@id"/>
				<div style="width:145px; float:left; padding:0 5px">
					<h4 style="margin-top:0; height:20px"><xsl:value-of select="."/>: </h4>
					<ul style="padding:0; list-style:none">
					<xsl:for-each select="$st/settlement[region/@id=$regid]">
						<li style="margin-bottom:0.3em">
							<a href="/{/out/@lang}/goto/{ident}/"><xsl:value-of select="name"/></a>
						</li>
					</xsl:for-each>
					</ul>
				</div>
				<!--<xsl:if test="(position() mod 2) = 0"><div style="clear:both;"></div></xsl:if>-->
			</xsl:for-each>
			<div style="clear:both; padding:2px"></div>
		</div>
	</xsl:template>

	<xsl:template match="settlements" mode="vertical">
		<xsl:variable name="st" select="."/>
		<div class="ui-widget-header ui-corner-all widget-header">
			<h1><xsl:value-of select="//c[@id='hotcat.cities.settlements']"/></h1>
		</div>
		<ul style="margin:0; list-style:none; padding:0 10px">
			<li>
				<inject id="adsense-200x90"></inject>
			</li>
			<xsl:for-each select="regions/region">
				<xsl:variable name="regid" select="@id"/>
				<li>
					<h3 style="margin-bottom:5px"><xsl:value-of select="."/>: </h3>
					<ul style="padding:0 20px">
					<xsl:for-each select="$st/settlement[region/@id=$regid]">
						<li style="margin-bottom:0.3em">
							<a href="/{/out/@lang}/goto/{ident}/"><xsl:value-of select="name"/></a>
						</li>
					</xsl:for-each>
					</ul>
				</li>
				<!--<xsl:if test="(position() mod 2) = 0"><div style="clear:both;"></div></xsl:if>-->
			</xsl:for-each>
			<div style="clear:both; padding:2px"></div>
		</ul>
	</xsl:template>

	<xsl:template match="fastobjlist" mode="rating">

		<table class="objlist rating zeb" width="100%" cellspacing="0">

			<xsl:for-each select="obj">
				<tr>
					<td class="ui-corner-left">
							<a class="zoom" title="{name}" href="http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/album/{image/name}/big.{image/ext}">
								<div class="ui-corner-left" style="width:50; height:50; background:url(http://pic.djerelo.info/crop/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}) center no-repeat;"></div>
							</a>
					</td>
					<td>
						<a href="/{//presets/lang}/goto/{@id}/"><xsl:value-of select="name"/></a>
						&amp;nbsp;
						<em style="font-size:10px">(<xsl:value-of select="settlement"/>)</em>
						<div style="clear:both">
							<xsl:apply-templates select="classify" mode="icons" />
						</div>
					</td>
					<td class="ui-corner-right value">
					<xsl:if test="price">
						<div style="width:100px; text-align:center">
							<span style="font-size:12px"><xsl:value-of select="//c[@id='standarts.from']"/>&amp;nbsp;</span>
							<span style="font-size:18px;  color:#03c;"><xsl:value-of select="price"/></span>
							<span style="font-size:12px">&amp;nbsp;<xsl:value-of select="//c[@id='currency']/cur[@id=current()/currency]/@short"/>&amp;nbsp;</span>
							<br/>
							<span style="font-size:10px">(<xsl:value-of select="pricecat"/>)</span>
						</div>
					</xsl:if>
					</td>
				</tr>
			</xsl:for-each>
		</table>

	</xsl:template>

	<xsl:template match="fastobjlist">
	
		<xsl:param name="sitemap" select="//sitemap"/>
		<div class="objlist">
			<xsl:variable name="expired_count" select="count(obj[leave&lt;0])"/>
			<xsl:variable name="active_count" select="count(obj[leave&gt;=0])"/>
			
			<xsl:choose>
				<xsl:when test="$active_count>0 and $expired_count>0">
					<div class="ui-widget-content ui-corner-all" style="margin:10px 0; clear:both">
						<xsl:apply-templates select="obj[leave>=0]" mode="objlistblock"/>
						<div style="clear:both; padding:2px"></div>
					</div>
					<div class="accordion-closed">
						<h4 style="padding:3px 30px"> <xsl:value-of select="//c[@id='standarts.hotcat.objects.others']"/> (<xsl:value-of select="$expired_count"/>) </h4>
						<div>
								<div class="ui-state-highlight ui-corner-all" style="padding: 5px; margin:5px"> 
									<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
									<xsl:copy-of select="/out/locale/c[@id='standarts.hotcat.objects.responsibility']"/>
								</div>
							<xsl:apply-templates select="obj[leave&lt;0]" mode="objlistblock"/>
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="obj" mode="objlistblock"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--
				<script type="text/javascript">
					$(".vk_like").each(function(){
						$(this).html('...');
						VK.Widgets.Like($(this).attr('id'), {type: "mini"}, $(this).attr('objid'));
					});
				</script>
			-->
		</div>
	</xsl:template>
	
	<xsl:template match="obj" mode="objlistblock">
		<div class="element">

			<table width="100%">
				<tr>
					<td width="150">
							<a class="zoom ui-corner-all" title="{name}" href="http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/album/{image/name}/big.{image/ext}">
								<div class="img" style="background:url(http://pic.djerelo.info/title/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}) center no-repeat;"></div>
							</a>
					</td>
					<td class="name">
						<xsl:if test="not(price)"><xsl:attribute name="colspan">2</xsl:attribute></xsl:if>
						<a href="/{//presets/lang}/goto/{@id}/"><xsl:value-of select="name"/></a>

						<div style="clear:both"><xsl:apply-templates select="classify" mode="icons"/></div>
<!--
						<xsl:call-template name="social-likes">
							<xsl:with-param name="login" select="login" />
							<xsl:with-param name="id" select="@id" />
						</xsl:call-template>
-->
						<div class="path" style="clear:both">
							<a href="/{/out/@lang}/goto/{settlement/@ident}/"><xsl:value-of select="settlement"/></a> 
							<xsl:if test="classify/class[@profile='Objects']">
								&amp;gt; <a href="/{/out/@lang}/goto/{settlement/@ident}/infrastructure/{classify/class[@profile='Objects']/val/@id}"><xsl:value-of select="classify/class[@profile='Objects']/val"/></a>
							</xsl:if>
							<xsl:if test="classify/class[@typeof='Objects']">
								&amp;gt; <a href="/{/out/@lang}/goto/{settlement/@ident}/infrastructure/{classify/class[@typeof='Objects']/val/@id}"><xsl:value-of select="classify/class[@typeof='Objects']/val"/></a>
							</xsl:if>
						</div>
						<div style="float:left;"><xsl:call-template name="RRate" /></div>
						<div style="float:left; margin:0 2px"><xsl:call-template name="SocRateMini"/></div>
					</td>
					<xsl:if test="price">
					<td class="content" width="150">
						<div class="price" style="width:150px; text-align:center">
							<span style="font-size:12px"><xsl:value-of select="//c[@id='standarts.from']"/>&amp;nbsp;</span>
							<xsl:value-of select="price"/>
							<span style="font-size:12px">&amp;nbsp;<xsl:value-of select="//c[@id='currency']/cur[@id=current()/currency]/@short"/>&amp;nbsp;</span>
							<br/>
							<span style="font-size:10px">(<xsl:value-of select="pricecat"/>)</span>
						</div>
					</td>
					</xsl:if>
				</tr>
			</table>

		</div>
		<div style="clear:both; border-bottom:1px solid #ccc; margin-bottom:10px"></div>
	</xsl:template>
	
	
	<xsl:template match="obj" mode="objlistblock_">
		<!--
		<xsl:param name="expired_count"/>
		<xsl:param name="active_count"/>
		<xsl:variable name="prev" select="position()-1"/>
		<xsl:if test="($active_count>0) and ($expired_count>0) and (leave&lt;0) and (../obj[$prev]/leave>=0)">
			<div style="clear:both" class="ui-state-default widget-header ui-corner-all"><h3> See More (<xsl:value-of select="$expired_count"/>) </h3></div>
			<div style="clear:both; margin:10px 0"></div>
		</xsl:if>
		-->
		
		<div class="element">
			<div class="inner">
				<div class="header">
					<xsl:if test="price"><xsl:attribute name="style">margin-right:75px</xsl:attribute></xsl:if>
					<div class="name">
						<div style="float:left">
							<a class="zoom ui-corner-all" title="{name}" href="http://pic.djerelo.info/img/hotcat/objects/{@id}/albums/album/{image/name}/big.{image/ext}">
								<div class="img" style="background:url(http://pic.djerelo.info/title/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}) center no-repeat;"></div>
							</a>
							<span style="color:#aaa; font-size:10px">
								R:
								<xsl:choose>
									<xsl:when test="leave&lt;0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="leave"/></xsl:otherwise>
								</xsl:choose>
							</span>

						</div>
						<a href="/{//presets/lang}/goto/{@id}/"><xsl:value-of select="name"/></a>

						<div><xsl:apply-templates select="classify" mode="icons"/></div>
						
						
						<div id="vk_like_{@id}" objid="{@id}" class="vk_like"></div>
						
						<div class="path">
							<a href="/{/out/@lang}/goto/{settlement/@ident}/"><xsl:value-of select="settlement"/></a> 
							<xsl:if test="classify/class[@profile='Objects']">
								&amp;gt; <a href="/{/out/@lang}/goto/{settlement/@ident}/infrastructure/{classify/class[@profile='Objects']/val/@id}"><xsl:value-of select="classify/class[@profile='Objects']/val"/></a>
							</xsl:if>
							<xsl:if test="classify/class[@typeof='Objects']">
								&amp;gt; <a href="/{/out/@lang}/goto/{settlement/@ident}/infrastructure/{classify/class[@typeof='Objects']/val/@id}"><xsl:value-of select="classify/class[@typeof='Objects']/val"/></a>
							</xsl:if>
						</div>
						
					</div>
				</div>
				<div class="content" style="margin-left:55px">
					<xsl:if test="price">
						<div class="price" style="width:200px; text-align:center">
							<span style="font-size:12px"><xsl:value-of select="//c[@id='standarts.from']"/>&amp;nbsp;</span>
							<xsl:value-of select="price"/>
							<span style="font-size:12px">&amp;nbsp;<xsl:value-of select="//c[@id='currency']/cur[@id=current()/currency]/@short"/>&amp;nbsp;</span>
							<br/>
							<span style="font-size:10px">(<xsl:value-of select="pricecat"/>)</span>
						</div>
					</xsl:if>
					<div>
						<xsl:if test="price"><xsl:attribute name="style">margin-right:75px</xsl:attribute></xsl:if>
						<!--
						<script type="text/javascript">VK.Widgets.Like("vk_like_<xsl:value-of select="@id"/>", {type: "mini"}, <xsl:value-of select="@id"/>);</script>
						-->
					</div>
				</div>
				
				
				
	
	
				<!--<textarea><xsl:copy-of select="classify"/></textarea>-->
			</div>
		</div>
		
		<div style="clear:both; border-bottom:1px solid #ccc; margin-bottom:10px"></div>
	</xsl:template>
	

	<xsl:template match="classify" mode="icons">
		<xsl:param name="objid" select="../@id"/>

		<div style="margin:5px">
			<!--<textarea><xsl:copy-of select="key('clas', concat(key/@id, @ownerid))" /></textarea>-->

			<xsl:for-each select="class[generate-id(.) = generate-id(key('clas', concat(key/@id, @ownerid)))]">
				
				<xsl:variable name="key" select="current()/key/@id" />
				<ul style="float:left; margin:0; padding:0">
					<xsl:for-each select="../class[key/@id=$key and val/@img]">
						<li title="{val}" style="margin: 0 0 1px 1px; float:left; list-style:none">
							<div style="background:url(/img/icons/classes/{val/@id}.png) no-repeat center white; width:18px; height:18px; border:solid 1px #ccc;" class="ui-corner-all"></div>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:for-each>
		
		</div>
		<div style="clear:both"></div>
	</xsl:template>
	
	<xsl:template match="classify" mode="icons-descr">
		<xsl:param name="objid" select="../@id"/>
		<xsl:param name="cityident" select="../city/@ident" />
		<xsl:param name="cityname" select="../city" />
		<div style="margin:5px">
		
			<xsl:for-each select="class[generate-id(.) = generate-id(key('clas', concat(key/@id, @ownerid)))]">
				
				<xsl:variable name="key" select="current()/key/@id"/>
					<ul style="margin:0; padding:0">
						<xsl:for-each select="../class[key/@id=$key and val/@img]">
							<li title="{val}" style="margin: 0 0 1px 1px; list-style:none; clear:both">
								
								<div style="background:url(/img/icons/classes/{val/@id}.png) no-repeat center white; width:18px; height:18px; border:solid 1px #ccc; margin:1px; float:left" class="ui-corner-all"></div>
								<div style="padding:3px">
									<a href="/{/out/@lang}/{$cityident}/infrastructure/{val/@id}/" title="{$cityname}, {val}">
										<xsl:value-of select="val" />
									</a>
								</div>
								
								
							</li>
						</xsl:for-each>
					</ul>
			</xsl:for-each>
		
		</div>
		<div style="clear:both"></div>
	</xsl:template>
	
	<xsl:template match="classify" mode="tree">
		<xsl:param name="nameof"/>
		<ul>
			<xsl:for-each select="class[generate-id(.) = generate-id(key('clas', key/@id))]">
				<xsl:variable name="key" select="current()/key/@id"/>
				<li title="{key}" style="clear:both">
					<xsl:value-of select="key"/>:
					<ul>
						<xsl:for-each select="../class[key/@id=$key]">
							<li title="{val}" style="list-style-image:url(/img/icons/classes/{val/@id}.png)">
								<xsl:value-of select="val"/>
							</li>
						</xsl:for-each>
					</ul>
					
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="block[name='hotcat.gallery.list']">
		<xsl:apply-templates select="content/albumlist"/>
	</xsl:template>

	<xsl:template match="infrastructure" mode="accordion">
		<xsl:param name="city" select="//uri-vars/identcity"/>
		<xsl:variable name="uid" select="generate-id()"/>
		<xsl:variable name="id" select="../@id"/>
		<xsl:variable name="ident" select="../@ident"/>
		<xsl:variable name="name" select="../name"/>
		<xsl:variable name="img" select="../img"/>

		<!--<h1>[<xsl:value-of select="//uri-vars/identcity"/>]</h1>-->
		
			<div class="categories">

				<xsl:for-each select="class[@node=0]">
					<h2><xsl:value-of select="name"/>:</h2>
						<ul>
						<xsl:for-each select="types/type">
							<li><a href="http://{/out/fulldom}/{//presets/lang}/goto/{//uri-vars/identcity}/objects/{@id}/"><xsl:value-of select="name"/></a></li>
						</xsl:for-each>
						</ul>
				</xsl:for-each>
			</div>
	</xsl:template>
	
	<xsl:template match="objects" mode="objlist">
		<xsl:for-each select="object">
			<div style="clear:both; height:50px; margin:10px 0px">
				<div style="float:left; background:url(http://pic.djerelo.info/crop/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}) #fff no-repeat; center; border:solid 1px #ccc; width:50px; height:50px"></div>
				<div style="margin-left:60px">
					<!--<a href="http://{account}.{/out/fulldom}/">-->
					<a href="http://{/out/fulldom}/{/out/@lang}/{account}">
					<!--<textarea><xsl:copy-of select="."/></textarea>-->
						<xsl:value-of select="name"/>
					</a>
					<p>
						(<xsl:value-of select="type"/>, <xsl:apply-templates select="city"/>)
					</p>
				</div>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="block[name='hotcat.cities.list']">
		<xsl:apply-templates select="content/regions/cities"/>
	</xsl:template>
	
	<xsl:template match="cities">
		<xsl:for-each select="city">
			<h3><a href="/{/out/@lang}/goto/{ident}/"><xsl:value-of select="name"/></a></h3>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="cities[/out/user/level=1]">
		<table class="zebra" width="100%">
			<tr>
				<td>City</td>
				<td>GPS</td>
				<td>Pics</td>
				<td>Bookit</td>
			</tr>
			<xsl:for-each select="city">
			<tr>
				<td><a href="/{/out/@lang}/goto/{ident}/"><xsl:value-of select="name"/></a></td>
				<td><img src="/img/icons/modules/globe.png" title="{@lat}:{@lng}"/></td>
				<td><img src="/img/icons/modules/photo.png" /></td>
				<td><img src="/img/icons/modules/bookit.png" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template name="social-likes">
		<xsl:param name="login" />
		<xsl:param name="id" />
		<div class="likes" style="margin:3px 6px; width:200px; overflow:visible">
			<div style="margin-left:auto; width:65px" class="ui-helper-clearfix">
				<!-- G+ -->
				<![CDATA[<g:plusone size="medium" href="http://djerelo.info/]]><xsl:value-of select="$login"/><![CDATA[/"></g:plusone>]]>
			</div>
			<div style="margin-left:auto; width:140px; overflow:hidden">
				<!-- Facebook -->			
				<div id="fb-root"></div>
				<![CDATA[<fb:like href="]]>http://<xsl:value-of select="/out/@domain"/>/<xsl:value-of select="$login"/>/<![CDATA[" send="true" width="450" show_faces="false"  data-layout="button_count" font=""></fb:like>]]>
			</div>
			<div style="margin-left:auto">
				<div id="vk_like_{$id}" objid="{$id}" class="vk_like"></div> 
			</div>
		</div>
	</xsl:template>


	<xsl:template name="SocRate">
		<table class="ui-helper-clearfix" style="clear:both" cellspacing="0">
			<tr>
				<td>
					<div class="ui-state-active ui-corner-left" style="width:130px; height:15px; padding:5px; margin-right:1px">
						<xsl:value-of select="//locale/c[@id='socials.rate']"/>
					</div>
				</td>
				<td class="ui-state-default ui-corner-right SocRate_{@id}" style="width:30px; height:15px; padding:5px; text-align:center">
					<xsl:choose>
						<xsl:when test="rate=''">
							<a href="javascript:$.post('http://skiworld.org.ua/plugins/socials/soc.php?objid={@id}', function(data){{$('.SocRate_{@id}').html(data)}})">
								<span style="font-size:12px">Get</span>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="rate" />	
						</xsl:otherwise>
					</xsl:choose>
					
				</td>
			</tr>
		</table>	
	</xsl:template>
	
	
	<xsl:template name="SocRateMini">
		<table class="ui-helper-clearfix" style="clear:both" cellspacing="0" title="{//locale/c[@id='socials.rate']}">
			<tr>
				<td>
					<div class="ui-widget-header ui-corner-left" style="width:15px; height:15px; padding:5px; margin-right:1px; text-align:center">
						S
					</div>
				</td>
				<td class="ui-state-default ui-corner-right SocRate_{@id}" style="width:30px; height:15px; padding:5px; text-align:center">
					<xsl:choose>
						<xsl:when test="rate=''">
							<a style="font-size:12px" href="javascript:$.post('http://skiworld.org.ua/plugins/socials/soc.php?objid={@id}', function(data){{$('.SocRate_{@id}').html(data)}})">
								Get
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="rate" />	
						</xsl:otherwise>
					</xsl:choose>
					
				</td>
			</tr>
		</table>	
	</xsl:template>
	
	<xsl:template name="RRate">
		<table class="ui-helper-clearfix" style="clear:both" cellspacing="0" title="{//locale/c[@id='hotcat.rrate']}">
			<tr>
				<td>
					<div class="ui-widget-header ui-corner-left" style="width:15px; height:15px; padding:5px; margin-right:1px; text-align:center">
						R
					</div>
				</td>
				<td class="ui-state-default ui-corner-right" style="width:30px; height:15px; padding:5px; text-align:center">
				
								<xsl:choose>
									<xsl:when test="leave&lt;0">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="leave"/></xsl:otherwise>
								</xsl:choose>
				</td>
			</tr>
		</table>	
	</xsl:template>
</xsl:stylesheet>