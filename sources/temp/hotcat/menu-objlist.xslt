<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		<div class="hotel_list">
		<xsl:apply-templates select="//object"/>
		</div>
	</xsl:template>


	<xsl:template match="object">
		<xsl:variable name="block_id" select="@id"/>

			<xsl:variable name="objid" select="@id"/>
			<div style="padding:5px 0" class="header" id="objMenuHeader_{@id}">

				<table>
					<tr>
						<td>
							<div style="background:url(http://pic.djerelo.info/crop/img/hotcat/objects/{@id}/albums/album/{image/name}/thumb.{image/ext}) #fff; center; border:solid 1px #ccc; width:50px; height:50px"></div>
						</td>
						<td style="vertical-align:middle; padding-left:10px">
							<h3>
								<a href="/{//presets/lang}/goto/{@id}/"><xsl:value-of select="name"/></a>
							</h3>
							<br />
							(<xsl:value-of select="type"/>, <xsl:value-of select="city"/>)
							<input type="hidden" name="mod_name" value="objmenu" />
							<input type="hidden" name="mod_temp" value="standart/modules.xslt" />
							<input type="hidden" name="mod_param" value="{@id}" />
						</td>
					</tr>
				</table>

			</div>
			<div id="objMenuContent_{@id}"></div>
					
	</xsl:template>

</xsl:stylesheet>