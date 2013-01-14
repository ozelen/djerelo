<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
		
	</xsl:template>



	
	<xsl:template match="infrastructure" mode="accordion">
		<xsl:variable name="uid" select="generate-id()"/>
		<xsl:variable name="id" select="../@id"/>
		<xsl:variable name="ident" select="../@ident"/>
		<xsl:variable name="name" select="../name"/>
		<xsl:variable name="img" select="../img"/>

		<!--<h1>[<xsl:value-of select="//uri-vars/identcity"/>]</h1>-->
		
			<div class="categories">
				<xsl:for-each select="class[@node=0]">
					<h2><xsl:value-of select="name"/>:</h2>
						<xsl:for-each select="types/type">
							<div id="objtype_menu_in_{@id}_{$uid}" class="btn" style="margin:2px 0 0 0" onclick="do_if_empty('/prg/bexec.php', 'objtype_menu_in_{@id}_{$uid}', 'objtype_menu_out_{@id}_{$uid}', 'post')">
								<div class="left"></div>
								<div class="right"></div>
								<div class="cont">
									<xsl:value-of select="name"/>
								</div>
								<input type="hidden" name="mod_name" value="hotcat.objects.list(city={//uri-vars/identcity}&amp;type={@id})" />
								<input type="hidden" name="mod_temp" value="hotcat/menu-objlist.xslt" />
								<input type="hidden" name="mod_param" value="{@id}" />
							</div>
							<div class="rounded-box-3">
								<b class="r3"></b><b class="r1"></b><b class="r1"></b>
									<div class="inner-box">
										
										<div class="hotel_list" id="objtype_menu_out_{@id}_{$uid}">
											
										</div>
										
										
									</div>
								<b class="r1"></b><b class="r1"></b><b class="r3"></b>
							</div>
						</xsl:for-each>
				</xsl:for-each>
			</div>
	</xsl:template>

	
</xsl:stylesheet>