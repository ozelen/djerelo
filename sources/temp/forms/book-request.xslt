<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:include href="sources/temp/standart/accessories.xslt"/>
    <xsl:template match="/">
		<xsl:apply-templates select="//booking-form" />
		<xsl:apply-templates select="//sysmsg/message"/>
	</xsl:template>
	
	<xsl:template match="booking-form[@mode='clean']">
		<div id="booking-form">
			<xsl:apply-templates select="." mode="form"/>
		</div>
	</xsl:template>
	
	<xsl:template match="booking-form[@mode='ok']">
		<table width="100%">
			<tr>
				<td width="30%"><xsl:value-of select="//c[@id='booking.form.name']" /></td>
				<td><xsl:value-of select="name"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.email']" /></td>
				<td><xsl:value-of select="email"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.phone']" /></td>
				<td><xsl:value-of select="phone"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.skype']" /></td>
				<td><xsl:value-of select="skype"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.arrival']" />/<xsl:value-of select="//c[@id='booking.form.departure']" /></td>
				<td><xsl:value-of select="arrival"/> - <xsl:value-of select="departure"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.adults']" /></td>
				<td><xsl:value-of select="adults"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.children']" /></td>
				<td><xsl:value-of select="children"/></td>
			</tr>
			<tr>
				<td><xsl:value-of select="//c[@id='booking.form.comments']" /></td>
				<td><xsl:value-of select="comments"/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="booking-form[@mode='retry']">
		<xsl:apply-templates select="." mode="form"/>
	</xsl:template>
	
	<xsl:template match="booking-form[area/table='Objects']" mode="area">
		<xsl:variable name="obj" select="objects/object"/>
		<a href="/{/out/@lang}/goto/{$obj/city/@ident}/"><xsl:value-of select="$obj/city"/></a> / 
		<a href="/{/out/@lang}/goto/{$obj/city/@ident}/infrastructure/{$obj/profile/@id}"><xsl:value-of select="$obj/profile"/></a> / 
		<a href="/{/out/@lang}/goto/{$obj/city/@ident}/infrastructure/{$obj/type/@id}"><xsl:value-of select="$obj/type"/></a> / 
		<strong><a href="/{/out/@lang}/goto/{$obj/@id}/"><xsl:value-of select="$obj/name" /></a></strong>,
		<xsl:value-of select="//c[@id='hotcat.object.free-booking']" />
	
		<input type="hidden" name="settlement" value="{$obj/city/@id}" />
		<input type="hidden" name="profile" value="{$obj/profile/@id}" />
		<input type="hidden" name="type" value="{$obj/type/@id}" />
		<input type="hidden" name="object" value="{$obj/@id}" />
		<input type="hidden" name="path" value="{$obj/city} / {$obj/profile} / {$obj/type} / {$obj/name}" />
	</xsl:template>
	
	<xsl:template match="booking-form[area/table='Settlements']" mode="area">
		<xsl:variable name="st" select="cities/city"/>
		<input name="settlement" value="{$st/@id}" type="hidden" />
		<a href="/{/out/@lang}/goto/{$st/ident}/"><xsl:value-of select="$st/name"/></a> /
		<select name="type" style="width:150px" onchange="var c = 'option.cl_'+$(this).selected().val(); $('#bookobjlist option.cl_all').hide(); $(c).show(); $('#bookobjlist option.cl_any').show().attr('selected', 'selected')">
			<option value="all"><xsl:value-of select="//c[@id='hotcat.categories.all']" /></option>
			<xsl:for-each select="$st/inf/profile">
				<option value="{@id}"><xsl:value-of select="." /></option>
				<xsl:variable name="prof" select="@id" />
				<xsl:for-each select="../type[@profile=$prof]">
					<option value="{@id}">&amp;nbsp;&amp;nbsp;<xsl:value-of select="." />  </option>
				</xsl:for-each>
			</xsl:for-each>
		</select>
		/
		<!--<textarea><xsl:copy-of select="//fastobjlist" /></textarea>-->
		<select id="bookobjlist" name="object" style="width:150px">
			<option value="all" class="cl_any"><xsl:value-of select="//c[@id='hotcat.objects.all']" /></option>
			<xsl:for-each select="//fastobjlist/obj[leave>0]">
				<xsl:variable name="prof" select="classify/class[@profile='Objects']/val/@id" />
				<xsl:variable name="type" select="classify/class[@typeof='Objects']/val/@id" />
				<option id="@id" value="{@id}" class="cl_all cl_{$prof} cl_{$type}"><xsl:value-of select="name" /></option>
			</xsl:for-each>
		</select>
	</xsl:template>
	
	<xsl:template match="booking-form" mode="form">
		<!--<textarea><xsl:copy-of select="." /></textarea>-->
		
		<form action="/booking/{//presets/uri-vars/area_name}/{area/@id}/send/" class="ajax" target="booking-form" method="post">
			<input name="name" type="hidden" value="{area/name}" />
			<input name="area_name" type="hidden" value="{//presets/uri-vars/area_name}" />
			<input name="area_id" type="hidden" value="{area/@id}" />
			<div style="margin-bottom:10px">
				<xsl:apply-templates select="." mode="area" />
			</div>
			<fieldset style="width:30%; float:left; height:200px"><legend><h4><xsl:value-of select="//c[@id='booking.form.personal-info']"/></h4></legend>
				<div>
					<xsl:value-of select="//c[@id='booking.form.name']" />
					<input name="Name" value="{name}" />
				</div>
				<div style="clear:both">
					<div>
						<xsl:value-of select="//c[@id='booking.form.email']" />
						<input name="Email" value="{email}" />
					</div>
					<div>
						<xsl:value-of select="//c[@id='booking.form.phone']" />
						<input name="Phone" value="{phone}" />
					</div>
					<div>
						Skype
						<input name="Skype" value="{skype}" />
					</div>
				</div>
			</fieldset>
			
			<fieldset style="height:200px"><legend><h4><xsl:value-of select="//c[@id='booking.form.reservation-info']"/></h4></legend>
				<div style="clear:both">
					<div style="float:left; width:49%">
								<xsl:value-of select="//c[@id='booking.form.arrival']" />
								<input type="text" class="datePare begin" id="arrival_date" link="departure_date" name="Arrival" value="{arrival}"/>
					</div>
					<div style="float:left; width:49%; margin-left:2%">
								<xsl:value-of select="//c[@id='booking.form.departure']" />
								<input type="text" class="datePare" id="departure_date" link="arrival_date" name="Departure" value="{departure}"/>
					</div>
				</div>
				
				<div style="clear:both">
					<div style="float:left; width:49%">
						<xsl:value-of select="//c[@id='booking.form.adults']" />
						<input name="Adults" value="{adults}" />
					</div>
					<div style="float:left; width:49%; margin-left:2%">
						<xsl:value-of select="//c[@id='booking.form.children']" />
						<input name="Children" value="{children}" />
					</div>
					<div>
						<xsl:value-of select="//c[@id='booking.form.comments']" />
						<textarea name="Comments" rows="5"><xsl:value-of select="comments"/></textarea>
					</div>
				</div>
			</fieldset>
			
			<div style="clear:both; padding:10px">
				<div style="width:120px; margin:auto; display:none">
					<div><xsl:value-of select="//c[@id='forms.captcha']" />:</div>
					<div><img src="/prg/kcaptcha/index.php?{/out/session}={/out/session/@id}" /></div>
					<div><input name="keystring" /></div>
					<button ico="ui-icon-mail-closed" style="width:100%"><xsl:value-of select="//c[@id='forms.submit']" /></button>
				</div>
				<div id="bookform-buttons" style="text-align:center">
					<button ico="ui-icon-check" type="button" onclick="$(this).parent().hide(); $(this).parent().siblings().show();"><xsl:value-of select="//c[@id='forms.submit']" /></button>
					<button ico="ui-icon-close" type="reset"><xsl:value-of select="//c[@id='forms.reset']" /></button>
				</div>
			</div>
		</form>
		
	</xsl:template>
	
</xsl:stylesheet>
