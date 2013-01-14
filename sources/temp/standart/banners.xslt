<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
	</xsl:template>
	
	<xsl:template match="banner[@type='300x250']">
<!--
		<xsl:param name="url" select="/img/iface/skiworld/bn-300x250.png"/>		
		<div class="rounded-box-3">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
			<div class="inner-box">						
				<h3 style="color:#999"><xsl:value-of select="//locale/c[@id='hotcat.adv']"/></h3>
				
				<div style="width:300px; height:250px; margin:0px; border:none">
					<iframe src="http://skiworld.org.ua/img/bn/izki/izki.php" style="width:300px; height:250px; border:none" scrolling="no"></iframe>
				</div>
				
			</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
-->
 <inject id="--adsense-300x250"></inject>



 <a href="http://zdravtour.net/truskavets/" title="Трускавец, Отдых и лечение в Трускавце" target="_blank" border="0">
 	<img src="/img/bn/trusk.png" alt="Отдых и лечение в Трускавце" width="300" height="250" />
 	<div style="text-align:center">Трускавец, Отдых и лечение в Трускавце</div>
 </a>

	</xsl:template>
	
	<xsl:template name="bn300x110">
		<div style="width:300px; height:110px; margin:0px; border:none">
			<iframe src="http://skiworld.org.ua/img/bn/dor/dor.php" style="width:300px; height:123px; border:none" scrolling="no"></iframe>
		</div>
	</xsl:template>
	
	<xsl:template match="banner[@type='300x70']">
		<iframe src="{url}"  style="width:300px; height:80px; border:0; padding:0; margin-bottom:20px" scrolling="no"></iframe>
	</xsl:template>

	<xsl:template name="xdrive">
		<iframe src="/img/bn/xdrive/bn.php"  style="width:300px; height:123px; border:0; padding:0; margin-bottom:20px" scrolling="no"></iframe>
	</xsl:template>
	
	<xsl:template name="adsense-vertical" mode="vertical">
		<script type="text/javascript" src="/js/ganalytics.js"></script>
        <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
	</xsl:template>
	
	
	<xsl:template name="subpage-bannerlist">
		<xsl:param name="inside"/>
---
		<div style="padding-top:50px"></div>
		
		<xsl:call-template name="blk">
			<xsl:with-param name="header" select="//locale/c[@id='standarts.adv']"/>
		</xsl:call-template>
		
		<xsl:copy-of select="$inside"/>
		
		<xsl:apply-templates select="//current/page/banners/banner[@id=3]"/>
		
		<div style="padding-top:10px"></div>
		<xsl:apply-templates select="//current/page/banners/banner[@type='300x250']"/>


		<xsl:call-template name="xdrive" />


	</xsl:template>
	
</xsl:stylesheet>