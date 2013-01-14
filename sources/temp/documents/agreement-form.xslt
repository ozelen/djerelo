<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/documents/docs.xslt"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//sysmsg/message"/>
		<xsl:apply-templates select="//docs/doc" mode="form"/>
	</xsl:template>
	<xsl:template match="docs/doc" mode="form">
		<!--<textarea><xsl:copy-of select="."/></textarea>-->
		<xsl:variable name="uid" select="generate-id()"/>
		<form method="post" class="ajax" action="/ua/admin/agreements/save/" target="opendocwin">
		<table width="100%">
			<tr>
				<td>ID</td>
				<td>
					<input readonly="readonly" name="Id" value="{field[@id='Id']}" size="5" style="margin-right:5px"/>
					<xsl:if test="not(field[@id='Id']='new')"><button type="button" ico="ui-icon-copy" onclick="winHref('opendocwin', '/ua/admin/agreements/{@id}/prolong/')">Prolong with a new Contract</button></xsl:if>
				</td>
			</tr>
			<tr>
				<td><label for="object">Object</label></td>
				<td>
					<input readonly="readonly" name="ObjId" value="{field[@id='ObjId']}" size="5" id="object" style="margin-right:5px"/>
					<input value="{field[@id='ObjName']}" size="50" /> (Name will not indexing, ID only)
				</td>
			</tr>
		
			<tr>
				<td><label for="series">Series / Number</label></td>
				<td>
					<input maxlength="3" size="5" name="Ser" value="{field[@id='Ser']}" id="series" style="float:left; margin-right:5px" />
					<input maxlength="20" size="20" name="Number" value="{field[@id='Number']}" id="number" />
				</td>
			</tr>
			<tr>
				<td><label for="name">FIO</label></td>
				<td>

						<input name="LastName" value="{field[@id='LastName']}" id="name"  maxlength="20" size="30" style="float:left; margin-right:5px"/>
						<input name="FirstName" value="{field[@id='FirstName']}"  maxlength="20" size="30" style="float:left; margin-right:5px"/>
						<input name="Patronymic" value="{field[@id='Patronymic']}"  maxlength="20" size="30" style="float:left; margin-right:5px"/>

				</td>
			</tr>
			<tr>
				<td><label for="price">Price</label></td>
				<td><input name="Price" value="{field[@id='Price']}" id="price" maxlength="6" /></td>
			</tr>
			<tr>
				<td>Begin/Expire</td>
				<td>

							<input type="text"  name="BeginDate" size="20" value="{field[@id='BeginDate']/@pretty}"/>
					
					/
					
							<input type="text" name="Expire" size="20" value="{field[@id='Expire']/@pretty}"/>

				</td>
			</tr>

			<tr>
				<td><label for="contacts">Contacts</label></td>
				<td><textarea name="Contacts" style="width:100%" rows="10"><xsl:value-of select="field[@id='Contacts']"/></textarea></td>
			</tr>
			<tr>
				<td><label for="status"><span class="ui-icon ui-icon-flag" style="float:left"></span>Status</label></td>
				<td>
					<select name="Status">
						<option value="1"><span class="ui-icon ui-icon-flag" style="float:left"></span>Ok</option>
						<option value="0"><span class="ui-icon ui-icon-flag" style="float:left"></span>Annul</option>
					</select>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><button ico="ui-icon-disk">Save</button></td>
			</tr>
		</table>
		</form>
	</xsl:template>
	
	<xsl:template match="sysmsg/message">
		<xsl:param name="header"/>
		<xsl:param name="type" select="@type"/>
		<xsl:param name="id" select="@id"/>
		<xsl:param name="content" select="."/>
		<div class="sysmsg_{$type}" title="sysmsg_{$type}" style="margin:5px 0;">
			<b class="r3"></b><b class="r1"></b><b class="r1"></b>
			<div class="inner-box">
				<xsl:copy-of select="$content"/>
				<xsl:value-of select="//c[@id=$id]"/>
			</div>
			<b class="r1"></b><b class="r1"></b><b class="r3"></b>
		</div>
	</xsl:template>
	
</xsl:stylesheet>