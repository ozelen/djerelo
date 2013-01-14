<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		
	</xsl:template>



	<xsl:template match="fastobjlist" mode="table">
		<!--<textarea cols="80" rows="30"><xsl:copy-of select="//fastobjlist/obj[@id=78]/classify"/></textarea>-->
		<table width="100%" cellspacing="0" class="zebra">
			<tr>
				<td width="30">ID</td>
                <td>Ident</td>
				<td>Name</td>
				<td width="120">Settlement</td>
				<td width="200">Classify</td>
				<td width="80">Added</td>
				<td width="80">Expire</td>
				<td width="80">Leave</td>
			</tr>
			<xsl:apply-templates select="obj"/>
			<div id="docswin" title="Documents"></div>
		</table>
	</xsl:template>
	
	<xsl:template match="fastobjlist/obj">
		
		

		
		<tr id="{field[@id='Id']}" class="{docs/agreements/@status}">
			<td><xsl:value-of select="@id"/></td>
            <td><a href="/ua/goto/{@id}/"><xsl:value-of select="login"/></a></td>
			<td><a href="/ua/goto/{@id}/"><xsl:value-of select="name"/></a></td>
			<td><xsl:value-of select="settlement"/></td>
			<td><xsl:value-of select="classify/class[@profile='Objects']/val"/>/<xsl:value-of select="classify/class[@typeof='Objects']/val"/></td>
			<td><xsl:value-of select="registered"/></td>
			<td>
				<a href="javascript:winHref('docswin', '/ua/admin/agreements/obj/{@id}/')">
					<!-- '/prg/callaction.php?mode=agrbyobj&amp;objid={@id}', {{'temp':'documents/docs-alone.xslt'}} -->
					<xsl:if test="status/@expire=''">not found</xsl:if>
					<xsl:value-of select="status/@expire"/>
				</a>
			</td>
			<td><xsl:value-of select="leave"/></td>
		</tr>
	</xsl:template>

	
	<xsl:template match="objects" mode="widelist">
				<table>

					<xsl:for-each select="object">
						<xsl:sort data-type="number" order="descending" select="deadline/@num"/>
							<tr>
								<td style="padding-right: 10px"><div style="border:solid 1px #ccc; width:120px; height:120px;"><img style="margin:10px" src="http://pic.djerelo.info/square/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}"/></div></td>
								<td>
									<h3><a href="/{//presets/lang}/goto/{@id}/"><xsl:value-of select="name"/></a></h3>
									(<a href="/{//presets/lang}/goto/{city/@ident}/objects/{type/@id}/"><xsl:value-of select="type"/>, <xsl:value-of select="city"/></a>)
									<p>
										<xsl:value-of select="phones"/><br />
										<xsl:value-of select="address"/>
									</p>
								</td>
							</tr>
							<tr><td height="30px"></td></tr>
					</xsl:for-each>
					
				</table>
	</xsl:template>

	
</xsl:stylesheet>