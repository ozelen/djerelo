<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//items" />
	</xsl:template>
	<xsl:template match="items">
		<table width="100%" cellspacing="0">
			<xsl:apply-templates select="item" />
		</table>
	</xsl:template>
	<xsl:template match="item">
		<tr id="{@type}-{@id}">
			<xsl:if test="@inside>0">
				<td style="width:20px; cursor:pointer">
					<a class="ajax" target="{@type}-{@id}_childs" href="/admin/bookit/cities/{@id}/objlist/" onclick="$('#{@type}-{@id}_childs'.show();">
						<xsl:value-of select="@inside"/>
					</a>
				</td>
			</xsl:if>
			<td width="200"><xsl:value-of select="name" /></td>
			<td style="min-height:30px">
				<div id="{@type}-{@id}_value" style="padding:0 10px;">
					<button ico="ui-icon-pencil" onclick="$('#{@type}-{@id}_edit').show(); $(this).hide(); $('#{@type}-{@id}-finder').focus()" style="width:100%">
						<span id="{@type}-{@id}_linkid">
							<xsl:if test="link"><xsl:value-of select="link" /></xsl:if>
							<xsl:if test="not(link)">undefined</xsl:if>
						</span>
					</button>
				</div>
				<div id="{@type}-{@id}_edit" style="display:none; padding:0 10px">
					<xsl:call-template name="finder" />
				</div>
			</td>
			<td style="width:80; text-align:center"><xsl:value-of select="insDate" /></td>
			<td style="width:80;"><xsl:value-of select="@id" /></td>
		</tr>
		<tr>
			<td> </td>
			<td id="{@type}-{@id}_childs" colspan="4"></td>
		</tr>
	</xsl:template>
	<xsl:template name="finder">
		<form
						class="ajax"
						target="{@type}-{@id}_value"
						onsubmit="$('#{@type}-{@id}_value').show(); $('#{@type}-{@id}_edit').hide(); "
				>
			<xsl:if test="@type='c'"><xsl:attribute name="action">/admin/bookit/cities/<xsl:value-of select="@id" />/editlink/</xsl:attribute></xsl:if>
			<xsl:if test="@type='o'"><xsl:attribute name="action">/admin/bookit/objects/<xsl:value-of select="@id" />/editlink/</xsl:attribute></xsl:if>
			<table width="100%">
				<tr>
					<td colspan="2">
						<xsl:if test="@type='c'">
							<input class="cityfinder" style="width:100%" name="linkname" id="{@type}-{@id}-finder" idinp="{@type}-{@id}-linkid" log="{@type}-{@id}-linkid-log" />
						</xsl:if>
						<xsl:if test="@type='o'">
							<input class="objfinder" style="width:100%" name="linkname" id="{@type}-{@id}-finder" idinp="{@type}-{@id}-linkid" log="{@type}-{@id}-linkid-log" />
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td id="{@type}-{@id}-linkid-log">Type the city/object name</td>
					<td width="100px"><button style="width:100%" ico="ui-icon-disk">Save</button></td>
				</tr>
			</table>
			<input id="{@type}-{@id}-linkid" type="hidden" name="linkid" />
		</form>
	</xsl:template>
</xsl:stylesheet>