<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
	</xsl:template>


	<xsl:template match="albumlist">


				<form class="ajax prepend" action="/prg/editalbum.php?mode=newalbum" target="albumlist">
				<input type="hidden" name="tbl" value="{owner}"/>
				<input type="hidden" name="id"  value="{owner/@id}"/>
				<input type="hidden" name="temp" value="hotcat/gallery-alone.xslt" />
				<table width="100%">
					<tr>
						<td style="padding:2px" width="50">Add</td>
						<td><input name="name" style="width:100%"/></td>
						<td width="20">
							<div class="icon ui-state-default ui-corner-all" style="padding:1px" onclick="$(this).submit()" title="Edit Album"><span class="ui-icon ui-icon-plus"></span></div>
						</td>
					</tr>
				</table>
				</form>
				
				<div id="albumlist">
					<xsl:apply-templates select="album" mode="controls"/>
				</div>
				
	</xsl:template>

	<xsl:template match="album" mode="controls">
		<xsl:param name="hat">true</xsl:param>
		<xsl:param name="owner_id" select="url-params/owner/@id"/>
		
		<xsl:if test="$hat='true'">
			<ul id="gallery_toolbar_{@id}" class="catgroup control-list" style="padding:10px; margin:2px">
			<li class="ui-state-default ui-corner-all control-element" style="list-style:none; height:30px; padding:0 5px;">
				
			
				<ul class="icons" style="float:right;" id="">
					<li class="ui-state-default ui-corner-all icon" onclick="if(confirm('Delete Album?'))delAlbum('gallery_toolbar_{@id}', {@id})" title="Delete Album" style="float:right"><span class="ui-icon ui-icon-trash"></span></li>
					<li class="ui-state-default ui-corner-all icon" onclick="makeSwfUpload('*.jpg;*.gif;*.png', '{@id}', '{session/@id}')" title="Edit Album" style="float:right"><span class="ui-icon ui-icon-image"></span></li>
				</ul>
				
						<xsl:apply-templates select="page" mode="display">
							<!--<xsl:with-param name="objid" select="$obj/@id"/>-->
							<xsl:with-param name="viewmode">admin</xsl:with-param>
							<xsl:with-param name="content"><xsl:value-of select="page/title"/> [<xsl:value-of select="name"/>]</xsl:with-param>
							<xsl:with-param name="field">title</xsl:with-param>
						</xsl:apply-templates>
						
						
				
			</li>
			</ul>
		</xsl:if>
		
		<div id="gallery_win_{@id}" style="clear:both; margin:10px 0; display:none" title="Edit Gallery" class="control-area">
			<table width="100%">
				<td width="270">
					<form class="toolbar-form">
						<input type="hidden" name="mod_name" value="hotcat.gallery.show(album={@id}&amp;table=Categories&amp;id={$owner_id}&amp;mode=edit)"/>
						<input type="hidden" name="mod_temp" value="hotcat/mini-gallery.xslt"/>
						<input type="hidden" name="mod_param" value="{@id}"/>
						<input type="hidden" name="viewmode" value="default"/>
						<input type="hidden" name="owner_id" value="{url-params/owner/@id}"/>
						<input type="hidden" name="owner_tbl" value="{url-params/owner}"/>
						<input type="hidden" name="album_id" value="{@id}"/>
					</form>
					<div id="gallery_input_{@id}" style="clear:both; margin:10px 0"></div>
				</td>
				<td>
					
					<table width="100%"><tr><td>
					<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-top gallery-tools toolbar" uid="{@id}">
						<li class="ui-state-default ui-corner-all" setting="selectable" title="Select Images"><span class="ui-icon ui-icon-arrow-1-nw"></span></li>
						<li class="ui-state-default ui-corner-all" setting="sortable" title="Sort Images"><span class="ui-icon ui-icon-shuffle"></span></li>
					</ul>
					</td><td width="50">
					<input class="button" type="checkbox" id="htmlview_{@id}" onclick="albumSource(this, 'gallery_win_{@id}', {@id})" /><label for="htmlview_{@id}"><span class="ui-icon ui-icon-carat-2-e-w"></span></label>
					</td></tr></table>
					
					<div style="height:30px; padding:2px 0" id="gallery_actmenu_{@id}" class="submenu">
						<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-bottom selectable" style="display:none">
							<li class="ui-state-default ui-corner-all" title="Set Title Image" onclick="setTitleImage('gallery_win_{@id}', {@id})"><span class="ui-icon ui-icon-star"></span></li>
							<li class="ui-state-default ui-corner-all" title="Delete Images" onclick="delSelectedImages('gallery_win_{@id}', {@id})"><span class="ui-icon ui-icon-trash"></span></li>
						</ul>
						<ul class="icons ui-widget ui-helper-clearfix ui-state-default ui-corner-bottom sortable" style="display:none">
							<li class="ui-state-default ui-corner-all" title="Save changes" onclick="saveSortImages('gallery_win_{@id}', {@id})"><span class="ui-icon ui-icon-disk"></span></li>
							<li class="ui-state-default ui-corner-all" title="Cancel changes" onclick="cancelSortImages('gallery_win_{@id}', {@id})"><span class="ui-icon ui-icon-cancel"></span></li>
						</ul>
					</div>
					
					<div id="gallery_output_{@id}" style="padding:10px 0" class="actzone">
						
					</div>
				</td>
			</table>
		</div>
	</xsl:template>


</xsl:stylesheet>