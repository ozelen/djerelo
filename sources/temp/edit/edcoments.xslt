<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<xsl:apply-templates select="/out/current//messages"/>
		</html>
	</xsl:template>

	<xsl:template match="messages">
		<ul>
			<xsl:apply-templates select="msg"/>
			<xsl:apply-templates select="obj"/>
		</ul>
	</xsl:template>
	<xsl:template match="obj">
		<li style="list-style-image:url(/img/icons/chat.png)">
			<h2><xsl:value-of select="name"/></h2>
			<ul>
				<xsl:apply-templates select="msg">
					<xsl:with-param name="objid" select="@id"/>
				</xsl:apply-templates>
			</ul>
		</li>
	</xsl:template>

	<xsl:template match="msg[@type='dir']">
		<xsl:param name="objid"/>
		<li style="list-style-image:url(/img/icons/dir.png)">
			<b><xsl:value-of select="header"/> </b>
				<ul>
					<xsl:apply-templates select="msg">
						<xsl:with-param name="objid" select="$objid"/>
					</xsl:apply-templates>
				</ul>
		</li>
	</xsl:template>


	<xsl:template match="msg">
		<xsl:param name="objid"/>
		<li style="list-style-image:url(/img/icons/comment.png)" class="{@id}">
			<div class="ui-widget" style="margin:2px" id="{@id}">
		
				<a href="/prg/editpage.php?mode=forum&amp;act=delmsg&amp;msg_id={@id}" class="aj once" target=".{@id}">
					<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-trash"></span></div>
				</a>
				<a href="/prg/editpage.php?mode=forum&amp;act=move&amp;msg_id={@id}" class="aj once" target=".{@id}">
					<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-extlink"></span></div>
				</a>
				
				<xsl:if test="@approved=0 or @approved=2">
					<a href="/prg/editpage.php?mode=forum&amp;act=approve&amp;msg_id={@id}" class="aj once" target=".{@id}">
						<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-check"></span></div>
					</a>
				</xsl:if>
				
				<div style="padding:5px">
					<xsl:attribute name="class">ui-corner-top ui-widget-header
					<xsl:choose>
						<xsl:when test="@approved=0">ui-state-highlight</xsl:when>
						<xsl:when test="@approved=2">ui-state-hover</xsl:when>
						<xsl:when test="@approved=3">ui-state-error</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</xsl:attribute>
					<div>
						<!--[<xsl:value-of select="@id"/>]-->
						<xsl:value-of select="user"/>: 
						<xsl:value-of select="title"/>
					</div>
					
					
				</div>
				<div class="ui-widget-content ui-corner-bottom" style="padding:5px">
					<xsl:if test="content=''">EMPTY MESSAGE</xsl:if>
					<xsl:value-of select="content"/> 
				</div>
			</div>
			<xsl:if test="msg">
				<ul>
					<xsl:apply-templates select="msg">
						<xsl:with-param name="objid" select="$objid"/>
					</xsl:apply-templates>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
</xsl:stylesheet>
