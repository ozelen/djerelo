<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//fastobjlist/obj"/>
	</xsl:template>
	<xsl:template match="fastobjlist/obj">
		
		<div style="margin:2px;">
			<div 
				style="padding:3px; font-size:12px; font-weight:normal; cursor:pointer"
				class="ui-state-default ui-corner-all" 
				onclick="$(this).toggleClass('ui-corner-all ui-corner-top').toggleClass('ui-state-default ui-state-active'); $(this).next().toggle().find('.tabmenu').tabs()"
			>
				<strong><xsl:value-of select="name" /></strong> (<xsl:value-of select="leave"/>) <br /> 
				<span style="font-size:10px">
					<xsl:value-of select="settlement" /> / <xsl:value-of select="classify/class[@typeof='Objects']/val" />
				</span>
				
			</div>
			
			<div class="content ui-widget-content ui-corner-bottom" style="display:none; border-top:none; font-size:10px">
				<div style="text-align:center; margin:1px;" class="tabmenu">
					<ul>
						<li><a href="#view-{@id}" title="View"><div class="ui-icon ui-icon-note"></div></a> </li>
						<li><a href="/program/gps/gps-ajax.php?objid={@id}" title="Edit"><div class="ui-icon ui-icon-pencil"></div></a></li>
						<li><a href="/{/out/@lang}/admin/mob/obj/editform/" title="Classify"><div class="ui-icon ui-icon-tag"></div></a></li>
						<li><a href="/{/out/@lang}/admin/mob/obj/docs/" title="Docs"><div class="ui-icon ui-icon-document"></div></a></li>
						<li><a href="/{/out/@lang}/admin/mob/obj/calls/" title="Calls"><div class="ui-icon ui-icon-comment"></div></a></li>
					</ul>
					<div id="view-{@id}">
						<table id="{field[@id='Id']}" class="{docs/agreements/@status}" style="font-size:10px" width="100%">
							<tr>
								<td>ID</td>
								<td><xsl:value-of select="@id"/></td>
							</tr>
							<tr>
								<td>Ident</td>
								<td><b><xsl:value-of select="login"/></b></td>
							</tr>
				            <tr>
				            	<td>Name</td>
				            	<td><a href="/ua/goto/{@id}/" target="_blank"><xsl:value-of select="name"/></a></td>
				            </tr>
							<tr>
								<td>Settlement</td>
								<td><xsl:value-of select="settlement"/></td>
							</tr>
							<tr>
								<td>Classify</td>
								<td><xsl:value-of select="classify/class[@profile='Objects']/val"/>/<xsl:value-of select="classify/class[@typeof='Objects']/val"/></td>
							</tr>
							<tr>
								<td>Registered</td>
								<td><xsl:value-of select="registered"/></td>
							</tr>
							<tr>
								<td>Expired</td>
								<td><xsl:value-of select="status/@expire"/></td>
							</tr>
							<tr>
								<td>Leave:</td>
								<td><b><xsl:value-of select="leave"/></b> days</td>
							</tr>
						</table>
					</div>

				</div>

			</div>
		</div>
		

	</xsl:template>
</xsl:stylesheet>