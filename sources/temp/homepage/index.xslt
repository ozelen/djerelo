<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
	<xsl:include href="sources/temp/standart/modules.xslt"/>
	<xsl:include href="sources/temp/standart/blankpage.xslt"/>
	<xsl:include href="sources/temp/standart/news.xslt"/>
	<xsl:include href="sources/temp/standart/banners.xslt"/>
	<xsl:include href="sources/temp/hotcat/hotcat-templates.xslt"/>
    <xsl:template match="/">

		<xsl:call-template name="DocumentFullHeader">
			<xsl:with-param name="title">
				Карпаты, отдых в Карпатах, погода в Карпатах. Горные лыжи. Горнолыжные курорты Карпаты
			</xsl:with-param>
		</xsl:call-template>




			<div style="height:123px">

			<div style="float:left; width:650px;">
				<xsl:call-template name="BookitForm" />
			</div>
			<div style="float:right">
				<xsl:call-template name="bn300x110"/>
			</div>



			</div>
			<div id="wrapper" style="padding:10px 0">
				<div id="content" style="width:650px;">


					<table width="100%" class="mainPageMarkupTable">
						<tr>
							<td width="200">
								<xsl:apply-templates select="//settlements" mode="vertical"/>
							</td>
							<td style="padding-left:2px">
								<div class="widget-header ui-widget-header ui-corner-all">
									<h1><xsl:value-of select="//locale/c[@id='skiworld.hotels-toplist']"/></h1>
								</div>
								<div style="height:510px; overflow:auto">
									<xsl:apply-templates select="//fastobjlist[name='avgRate']" mode="rating" />
								</div>

					<!-- TPL: NEWSBLOCK -->
					<div class="ui-corner-all widget-header"><h1><xsl:value-of select="//locale/c[@id='standarts.news']"/></h1></div>

					<xsl:apply-templates select="//items[@type='news']" mode="list"/>

					<a href="/{/out/@lang}/news/archive/{//items/@skip + 20}">&lt;&lt; <xsl:value-of select="//locale/c[@id='standarts.previous']"/> 20</a>
					<br />

					<inject id="seotext"></inject>


							</td>
						</tr>
					</table>








				</div>
			</div>
			<div id="extra">
				<!-- <xsl:apply-templates select="//block[name='objlist']" mode="accordion"/> -->
				<div>
<div style="padding: 20px 0">
	<inject id="adsense-300x250"></inject>
</div>
<xsl:call-template name="xdrive" />

								<div style="margin-top:5px">
									<xsl:apply-templates select="//banners/banner[@id=3]"/>
								</div>
                    
					<!-- <xsl:call-template name="adsense-vertical"/> -->
				


				<!-- TPL: PAPERSBLOCK -->
				<div class="ui-corner-all widget-header"><xsl:value-of select="//locale/c[@id='standarts.papers']"/></div>
				<xsl:apply-templates select="//items[@type='papers']" mode="list"/>
				
				
				<div class="ui-corner-all widget-header"><xsl:value-of select="//locale/c[@id='standarts.papers.sections']"/></div>
				<xsl:apply-templates select="//sections"/>
				
				
				</div>
					<div id="adv_links">
						Украина Полиграфическая - <a href="http://www.ukr-print.net">полиграфия</a> в Украине<p/>
						<a href="http://www.exdriver.com.ua/">Магазин екстримального спорядження. м. Київ</a><p/>
            		</div>


				</div>
			
		<xsl:call-template name="DocumentFullFooter"/>
				
	</xsl:template>
	
	<xsl:template match="sections">
		<ul class="ul_accord">
			<xsl:apply-templates select="section[article]"/>
		</ul>
	</xsl:template>
	<xsl:template match="section">
		<li class="li_accord">
			<div class="hdr" style="padding:5px 0"><a href="/{//presets/lang}/papers/{@id}/" class="dropdown"><xsl:value-of select="name"/></a></div>
			<div style="display:none" class="hdzone">
				<ul>
					<xsl:for-each select="article">
						<li><a href="/{//presets/lang}/papers/show/{@id}/"><xsl:value-of select="name"/></a></li>
					</xsl:for-each>
				</ul>
			</div>
		</li>
	</xsl:template>
	
</xsl:stylesheet>