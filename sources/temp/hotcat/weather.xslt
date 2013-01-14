<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">

	<xsl:apply-templates select="//forecast"/>

</xsl:template>

<xsl:template match="forecast">
	<table class="tblWeather" cellspacing="0" width="100%">
    	<tr class="hdr">
        	<td><xsl:value-of select="//c[@id='hotcat.weather.period']"/></td>
            <td><xsl:value-of select="//c[@id='hotcat.weather.cloudiness']"/></td>
            <td><xsl:value-of select="//c[@id='hotcat.weather.temperature']"/></td>
            <td><xsl:value-of select="//c[@id='hotcat.weather.wind']"/></td>
            <td><xsl:value-of select="//c[@id='hotcat.weather.humidity']"/></td>
            <td><xsl:value-of select="//c[@id='hotcat.weather.probability']"/></td>
        </tr>
		<xsl:apply-templates select="//day[@date]"/>
    </table>
</xsl:template>

<xsl:template match="day">
	<tr class="tr">
    	<td class="date" width="50" align="center">
        	<xsl:element name="newdate">
				<xsl:call-template name="FormatDate"><xsl:with-param name="DateTime" select="@date"/></xsl:call-template>
            </xsl:element>,
			<xsl:value-of select="//c[@id='hotcat.weather.daytime.']"/>
        	<xsl:if test="@hour=9"><xsl:value-of select="//c[@id='hotcat.weather.daytime.morning']"/></xsl:if>
        	<xsl:if test="@hour=15"><xsl:value-of select="//c[@id='hotcat.weather.daytime.afternoon']"/></xsl:if>
            <xsl:if test="@hour=21"><xsl:value-of select="//c[@id='hotcat.weather.daytime.eveneng']"/></xsl:if>
            <xsl:if test="@hour=3"><xsl:value-of select="//c[@id='hotcat.weather.daytime.night']"/></xsl:if>
        </td>
    	<td width="44">
            <img>
                <xsl:attribute name="src">/img/icons/weather/<xsl:value-of select="pict"/></xsl:attribute>
                <xsl:attribute name="alt">
                    <xsl:if test="cloud &gt; 9 and cloud &lt; 20"><xsl:value-of select="//c[@id='hotcat.weather.wtype.1']"/></xsl:if>
                    <xsl:if test="cloud &gt; 19 and cloud &lt; 30"><xsl:value-of select="//c[@id='hotcat.weather.wtype.2']"/></xsl:if>
                    <xsl:if test="cloud &gt; 29 and cloud &lt; 40"><xsl:value-of select="//c[@id='hotcat.weather.wtype.3']"/></xsl:if>
                    <xsl:if test="cloud &gt; 39 and cloud &lt; 50"><xsl:value-of select="//c[@id='hotcat.weather.wtype.4']"/></xsl:if>
                    <xsl:if test="cloud &gt; 49 and cloud &lt; 60"><xsl:value-of select="//c[@id='hotcat.weather.wtype.5']"/></xsl:if>
                    <xsl:if test="cloud &gt; 59 and cloud &lt; 70"><xsl:value-of select="//c[@id='hotcat.weather.wtype.6']"/></xsl:if>
                    <xsl:if test="cloud &gt; 69 and cloud &lt; 80"><xsl:value-of select="//c[@id='hotcat.weather.wtype.7']"/></xsl:if>
                    <xsl:if test="cloud &gt; 79 and cloud &lt; 90"><xsl:value-of select="//c[@id='hotcat.weather.wtype.8']"/></xsl:if>
                    <xsl:if test="cloud &gt; 89 and cloud &lt; 100"><xsl:value-of select="//c[@id='hotcat.weather.wtype.9']"/></xsl:if>
                    <xsl:if test="cloud &gt; 109 and cloud &lt; 110"><xsl:value-of select="//c[@id='hotcat.weather.wtype.10']"/></xsl:if>
                </xsl:attribute>
            </img>
        </td>
        <td>
        	<xsl:value-of select="t/min"/>&amp;deg; &amp;mdash; <xsl:value-of select="t/max"/>&amp;deg;
        </td>
        <td><xsl:value-of select="wind/min"/> &amp;mdash; <xsl:value-of select="wind/max"/> м/с</td>
        <td><xsl:value-of select="hmid/min"/> &amp;mdash; <xsl:value-of select="hmid/max"/>%</td>
        <td><xsl:value-of select="wpi"/>%</td>
	</tr>
</xsl:template>

<xsl:template name="FormatDate">    
    <xsl:param name="DateTime" />    
    <!-- 2007-12-27T00:00:00+01:00-->    
    <!--dd.MM.yyyy-->    
    <xsl:variable name="year"><xsl:value-of select="substring($DateTime,1,4)"/></xsl:variable>    
    <xsl:variable name="mo"><xsl:value-of select="substring($DateTime,6,2)"/></xsl:variable>    
    <xsl:variable name="day"><xsl:value-of select="substring($DateTime,9,2)"/></xsl:variable>    
    <xsl:value-of select="$day"/><xsl:value-of select="'.'"/><xsl:value-of select="$mo"/><xsl:value-of select="'.'"/><xsl:value-of select="$year"/>
</xsl:template>
</xsl:stylesheet>