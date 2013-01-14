<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="pages/page" mode="classify"/>
	</xsl:template>


	<xsl:template name="WinClassifyObj">
		<xsl:param name="obj"/>
		<xsl:param name="objclasses" select="$obj/classify"/>
		<xsl:param name="objprofclass" select="$objclasses/class[@profile='Objects']/val/@id"/>
		<xsl:param name="objclasstree" select="//sitemap//page[@id=$objprofclass]"/>
		<xsl:param name="objclasstree-cat" select="//sitemap//page[@id=$objprofclass]/pages/page[name='categories']"/>
		
		<xsl:param name="uri">/classes/objects</xsl:param>
		<xsl:param name="uri-cat" select="$objclasstree-cat/uri"/>
		
		
		
		<xsl:param name="uid" select="generate-id()"/>
		<xsl:param name="fields"/>
		<xsl:param name="title" select="//sitemap//pages/page[uri=$uri]/title"/>
		<div id="winClassify_Objects_{$obj/@id}" style="display:none" title="{$title}">

			<!--[<xsl:value-of select="$uri"/>][<xsl:value-of select="$uid"/>]-->
			<form class="ajax" action="/prg/editobj.php?mode=saveclass" method="post">
				<input type="hidden" name="OwnerTable" value="Objects" />
				<input type="hidden" name="OwnerId" value="{$obj/@id}" />
				<input type="hidden" name="lang" value="{//locale/@lang}" />
				<input type="hidden" name="objid" value="{$obj/@id}" />
				
				<!--<textarea><xsl:copy-of select="//sitemap//pages/page[uri=$uri]"/></textarea>-->
				
				<div class="tabs">
				
					<ul>
						<li><a href="#objclass-main">Object Classification</a></li>
						<li><a href="#objclass-categories">Categories in Object</a></li>
						<li><a href="#objclass-location">Location</a></li>
					</ul>
				
					<div id="objclass-main">
						<xsl:apply-templates select="//sitemap//pages/page[uri=$uri]" mode="classify">
							<xsl:with-param name="owner_tbl">Objects</xsl:with-param>
							<xsl:with-param name="owner_id" select="$obj/@id"/>
							<xsl:with-param name="uid" select="$uid"/>
						</xsl:apply-templates>
					</div>
					<div id="objclass-categories">
						<xsl:for-each select="$objclasstree-cat//page[params/index='Objects']">
							<xsl:variable name="classid" select="@id"/>
							<xsl:variable name="values" select="//classify[owner='Objects' and owner/@id=$obj/@id]"/>
							<xsl:variable name="keyid" select="@id"/>
							
							<fieldset>
								<legend><xsl:value-of select="title"/></legend>
								<ul style="list-style:none">
								<xsl:for-each select=".//pages/page">
								<xsl:variable name="valid" select="current()/@id"/>
									<li>
										<input name="key_{$classid}[]" value="{@id}" type="checkbox" id="check_{$uid}_{@id}">
											<xsl:if test="$values/class[key/@id=$keyid and val/@id=$valid]">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input> 
										<label for="check_{$uid}_{@id}"><xsl:value-of select="title"/></label>
									</li>									
								</xsl:for-each>
								</ul>
							</fieldset>
						</xsl:for-each>
					</div>
				
					<div id="objclass-location">
						<table width="100%">
							<tr>
								<td width="30%"><label for="email">E-mail: </label></td>
								<td><input id="email" name="Email" value="{$obj/email}" style="width:100%" /></td>
							</tr>
							<tr>
								<td><label for="ident">Ident: </label></td>
								<td><input id="ident" name="AccountCode" value="{$obj/account}" style="width:100%" /></td>
							</tr>
							<tr>
								<td><label for="city">Settlement (rus): </label></td>
								<td>
									<table width="100%" cellpadding="0" cellspacing="0"><tr>
									<td class="ui-widget" width="50%">
										<input id="city" style="width:100%" />
										<input id="cityid" type="hidden" name="settlement" value="{$obj/city/@id}" />
									</td>
									<td>
										<div id="locLog" style="overflow: auto; padding:5px" class="ui-widget-content ui-corner-all">
											<xsl:value-of select="$obj/city"/>
											<xsl:if test="not($obj/city) or $obj/city=''">Undefined Settlement</xsl:if>
										</div>
									</td>
									</tr></table>
								</td>
							</tr>
						</table>

				
				
				
					
				
					</div>
					
				</div>
				
				
			</form>
		</div>
	</xsl:template>
	
	<xsl:template name="WinClassify">
		<xsl:param name="owner_tbl"/>
		<xsl:param name="owner_id"/>
		<xsl:param name="uri"/>
		<xsl:param name="uid" select="generate-id()"/>
		<xsl:param name="fields"/>
		<xsl:param name="title" select="//sitemap//pages/page[uri=$uri]/title"/>
		<div id="winClassify_{$owner_tbl}_{$owner_id}" style="display:none" title="{$title}">
			<!--<xsl:apply-templates select="//classify[owner=$owner_tbl and owner/@id=$owner_id]"/>-->

			<!--[<xsl:value-of select="$uri"/>][<xsl:value-of select="$uid"/>]-->
			<form class="ajax" action="/prg/editobj.php?mode=saveclass" method="post">
				<input type="hidden" name="OwnerTable" value="{$owner_tbl}" />
				<input type="hidden" name="OwnerId" value="{$owner_id}" />
				<input type="hidden" name="lang" value="{//locale/@lang}" />
				<xsl:copy-of select="$fields"/>
				
				<!--<textarea><xsl:copy-of select="//sitemap//pages/page[uri=$uri]"/></textarea>-->
				
				<xsl:apply-templates select="//sitemap//pages/page[uri=$uri]" mode="classify">
					<xsl:with-param name="owner_tbl" select="$owner_tbl"/>
					<xsl:with-param name="owner_id" select="$owner_id"/>
					<xsl:with-param name="uid" select="$uid"/>
				</xsl:apply-templates>
				
			</form>
		</div>
	</xsl:template>
	
	

	
	<xsl:template match="classify">
		<table border="1">
			<tr>
				<td colspan="2"><xsl:value-of select="owner"/>: <xsl:value-of select="owner/@id"/></td>
			</tr>
			
			<xsl:for-each select="class">
				<tr>
					<td><xsl:value-of select="key"/></td>
					<td><xsl:value-of select="val"/></td>
				</tr>
			</xsl:for-each>
			
		</table>
	</xsl:template>
	
	<xsl:template match="page[params/classtype='form']" mode="classify">
		<xsl:param name="owner_tbl"/>
		<xsl:param name="owner_id"/>
		<xsl:param name="uid" select="generate-id()"/>
		<xsl:param name="own_uid"><xsl:value-of select="$uid"/>_<xsl:value-of select="generate-id()"/></xsl:param>
		<xsl:variable name="values" select="//classify[owner=$owner_tbl and owner/@id=$owner_id]"/>
		<xsl:variable name="keyid" select="@id"/>
		<!--<input style="width:100%" value="[{$owner_tbl}][{$owner_id}][{$uid}]"/>-->
		<xsl:if test="not(params/stop=$owner_tbl)">
		<div>
			<h3><xsl:value-of select="title"/></h3>
			<xsl:apply-templates select="pages/page" mode="classify">
			
				<xsl:with-param name="owner_tbl" select="$owner_tbl"/>
				<xsl:with-param name="owner_id" select="$owner_id"/>
				<xsl:with-param name="uid" select="$uid"/>
			
			</xsl:apply-templates>
		</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page[params/classtype='radio']" mode="classify">
		<xsl:param name="owner_tbl"/>
		<xsl:param name="owner_id"/>
		<xsl:param name="uid" select="generate-id()"/>
		<xsl:param name="own_uid"><xsl:value-of select="$uid"/>_<xsl:value-of select="generate-id()"/></xsl:param>
		<xsl:variable name="values" select="//classify[owner=$owner_tbl and owner/@id=$owner_id]"/>
		<xsl:variable name="keyid" select="@id"/>
		<xsl:if test="not(params/stop=$owner_tbl)">
		<fieldset>
			<legend><xsl:value-of select="title"/></legend>
			<select name="key_{@id}" style="width:100%" onchange="openSubClass($(this).val(), '{$own_uid}', '{//locale/@lang}')">
				<option></option>
				<xsl:for-each select="pages/page">
					<xsl:variable name="valid" select="current()/@id"/>
					
					<option value="{@id}">
						<xsl:if test="$values/class[key/@id=$keyid and val/@id=$valid]">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="title"/>
					</option>
				</xsl:for-each>
			</select>
			<div id="{$own_uid}">
				
				<!--(classtype: <xsl:value-of select="pages/page[@id=$values/class/val/@id]/params/classtype"/>)-->
				
				<xsl:apply-templates select="pages/page[@id=$values/class/val/@id]" mode="classify">
					<xsl:with-param name="owner_tbl" select="$owner_tbl"/>
					<xsl:with-param name="owner_id" select="$owner_id"/>
					<xsl:with-param name="uid" select="$own_uid"/>
				</xsl:apply-templates>
				
			</div>
		</fieldset>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page[params/classtype='check']" mode="classify">
		<xsl:param name="owner_tbl"/>
		<xsl:param name="owner_id"/>
		<xsl:param name="uid" select="generate-id()"/>
		<xsl:param name="own_uid"><xsl:value-of select="$uid"/>_<xsl:value-of select="generate-id()"/></xsl:param>
		<xsl:variable name="values" select="//classify[owner=$owner_tbl and owner/@id=$owner_id]"/>
		<xsl:variable name="keyid" select="@id"/>
		<!--<xsl:apply-templates select="$values"/>-->
		<xsl:if test="not(params/stop=$owner_tbl)">
		<fieldset>
			<legend><xsl:value-of select="title"/></legend>
			<xsl:variable name="classid" select="@id"/>
			<xsl:for-each select="pages/page">
				<xsl:variable name="valid" select="current()/@id"/>
				<div>
					<input name="key_{$classid}[]" value="{@id}" type="checkbox" id="check_{$own_uid}_{@id}">
					
						<xsl:if test="$values/class[key/@id=$keyid and val/@id=$valid]">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					
					</input>
					<label for="check_{$own_uid}_{@id}"><xsl:value-of select="title"/></label>
				</div>
			</xsl:for-each>
		</fieldset>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="page" mode="classify">
	<!--
		[id:<xsl:value-of select="@id"/>]<br/>
		[params:<xsl:value-of select="params"/>]<br/>
		[name:<xsl:value-of select="name"/>]<br/>
	-->
	</xsl:template>
	
</xsl:stylesheet>