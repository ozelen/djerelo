<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">

	</xsl:template>
	
	<xsl:template match="items" mode="list">
	
		<ul class="newsblock">
			<xsl:apply-templates select="item" mode="list"/>
		</ul>
	
	</xsl:template>
	
	
	<xsl:template match="item" mode="list">
		<li><a href="{/out/home}/{//presets/lang}/news/show/{@paper}"><xsl:value-of select="title"/></a> <div class="date"><xsl:value-of select="pubDate/@pretty"/></div></li> 
	</xsl:template>

	<xsl:template match="item[../@type='papers']" mode="list">
		<li>
			<a href="/{//presets/lang}/papers/show/{@id}"><xsl:value-of select="title"/></a> 
			<div class="descr"><xsl:value-of select="description"/></div>
		</li> 
	</xsl:template>
	
	
	<xsl:template match="items" mode="blog">
	
		<ul class="newsblock">
			<xsl:apply-templates select="item" mode="blog"/>
		</ul>
	
	</xsl:template>
	
	<xsl:template match="item" mode="blog">
		<li style="border-bottom:#CCC solid 1px">
			<h2><a href="{/out/home}/{//presets/lang}/news/show/{@paper}"><xsl:value-of select="title"/></a></h2>
			<div class="date"><xsl:value-of select="pubDate/@pretty"/></div>
			<p><xsl:value-of select="content"/></p>
		</li> 
	</xsl:template>
	
</xsl:stylesheet>