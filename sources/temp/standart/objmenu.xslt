<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:template match="/">
	
	</xsl:template>

	<xsl:template match="conceptions" mode="accordion">
	
		<div class="rounded-box-3">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
				<div class="inner-box">
					<h3><xsl:value-of select="name"/></h3>
				</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
				
		<div class="basic" id="list1b">
			<xsl:for-each select="conception">
				<div class="btn" style="margin:5px 0 0 0">
					<div class="left"></div>
					<div class="right"></div>
					<div class="cont"><a><xsl:value-of select="name"/></a></div>
				</div>
				<div class="rounded-box-3">
					<b class="r3"></b><b class="r1"></b><b class="r1"></b>
						<div class="inner-box">
							<ul>
							<xsl:for-each select="city">
								<li>
									<a href="/{/out/@lang}/localities/{city-id}"><xsl:value-of select="caption"/></a>
									<ul>
										<xsl:for-each select="objects/type" mode="accordion">
											<li>
												<a href="/{/out/@lang}/localities/{../../city-id}/{ident}"><xsl:value-of select="name"/></a> (<xsl:value-of select="objs"/>)
											</li>
										</xsl:for-each>
									</ul>
								</li>
							</xsl:for-each>
							</ul>
						</div>
					<b class="r1"></b><b class="r1"></b><b class="r3"></b>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="block[name='objlist']" mode="accordion">
		<xsl:variable name="block_id" select="@id"/>
		<div class="rounded-box-3">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
				<div class="inner-box">
					<h3>title: <xsl:value-of select="title"/></h3>
				</div>
				
				<div class="hotel_list">
					<xsl:for-each select="content/objects/object">
						<xsl:variable name="objid" select="@id"/>
						<div class="header" id="objMenuHeader_{@id}" onclick="doit('/prg/bexec.php', 'objMenuHeader_{@id}', 'objMenuContent', 'post')">
							<strong><xsl:value-of select="name"/></strong>, <xsl:value-of select="city"/>
							<input type="hidden" name="mod_name" value="objmenu" />
							<input type="hidden" name="mod_temp" value="standart/objmenu.xslt" />
							<input type="hidden" name="mod_param" value="id='{@id}" />
						</div>
						<div class="content" id="objMenuContent_{@id}">
							<table>
								<tr>
									<td width="100"></td>
									<td>
										<xsl:for-each select="//cat-types/type[@id=current()/categories/category/type/@id]">
											<div style="margin:5px 0;">
												<h4><xsl:value-of select="."/></h4>
												<ul>
													<xsl:for-each select="//object[@id=$objid]/categories/category[type/@id=current()/@id]">
														<li><a href="/{/out/@lang}/{//object[@id=$objid]/account}/categories/{@id}"><xsl:value-of select="name"/></a></li>
													</xsl:for-each>
												</ul>
											</div>
										</xsl:for-each>
									</td>
								</tr>
							</table>
						</div>
					</xsl:for-each>
				</div>
				<div id="objMenuContent"></div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
	</xsl:template>

</xsl:stylesheet>