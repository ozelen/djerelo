<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:template match="/">
		<div>
			<xsl:apply-templates select="//album[images/img]" mode="crop"/>
		</div>
		<div style="clear:both"></div>
	</xsl:template>
	
	<xsl:template match="album" mode="crop" name="album">
		<xsl:param name="element" select="images/img"/>
		<xsl:param name="rel" select="../../@id"/>
		<ul style="margin:0px; padding:0px">
			<xsl:for-each select="$element">
				<li style="padding:0; margin:1 1 0 0; float:left; list-style:none">
					<a title="{../../../../name}" class="zoom" rel="group_{$rel}" href="http://pic.djerelo.info/img/hotcat/{localpath}/{@id}/big.{@extension}"  onclick="pageTracker._ trackPageview('/img/hotcat/{localpath}/{@id}/');">
						<img alt="{../../../../name}" src="http://pic.djerelo.info/crop/img/hotcat/{localpath}/{@id}/thumb.{@extension}" style="margin:0" width="50" height="50" />
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="album[@mode='edit']" mode="crop">
		<xsl:choose>
			<xsl:when test="@viewmode='html'">
<textarea style="width:100%; height:300px;"><xsl:for-each select="images/img"><img src="http://pic.djerelo.info/img/hotcat/{localpath}/{@id}/big.{@extension}"/>
<xsl:text>
</xsl:text>
</xsl:for-each></textarea>
			</xsl:when>
			<xsl:otherwise>
				<ul class="sortableImages control-list">
					<xsl:for-each select="images/img">
						<li id="img_{@id}" title="{@id}" class="ajlink control-element" style="padding:3px; margin:1px; border: dotted 1px #ccc; float:left; list-style:none">
							<div style="width:50px; height:50px; background:url(http://pic.djerelo.info/crop/img/hotcat/{localpath}/{@id}/thumb.{@extension});"></div>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	

	
</xsl:stylesheet>