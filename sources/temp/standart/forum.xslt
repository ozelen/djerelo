<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="utf-8" indent="yes"/>
	<xsl:template match="/">
		<!--<textarea cols="100" rows="50"><xsl:copy-of select="."/></textarea>-->
		<xsl:apply-templates select="//sysmsg/message"/>
		<xsl:if test="//topic[@level=1]/@id">
			<xsl:call-template name="msglist"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="forum-form">
		<div style="display:none">
			<xsl:call-template name="add-comment">
				<xsl:with-param name="topic" select="@id"/>
			</xsl:call-template>
			
			<div id="complain">
				<h3><xsl:value-of select="/out/locale/c[@id='forum.messages.complain']/title"/></h3>
				<xsl:copy-of select="/out/locale/c[@id='forum.messages.complain']/source"/>
			</div>
			
			<div id="answer">
				<h3><xsl:value-of select="/out/locale/c[@id='forum.messages.answer']/title"/></h3>
				<xsl:copy-of select="/out/locale/c[@id='forum.messages.answer']/source"/>
			</div>
			
			<div id="add">
				<h3><xsl:value-of select="/out/locale/c[@id='forum.add-comment']"/></h3>
				<xsl:copy-of select="/out/locale/c[@id='forum.messages.answer']/source"/>
			</div>

		</div>	
	</xsl:template>

	
	<xsl:template name="msglist">
		<xsl:param name="topicid" select="//topic[@level=1]/@id"/>
		<div class="forum" id="msgArea">
			<div class="msg" folder="{//topic/@dir}" id="{$topicid}" level="0">
				<a class="forum-append-form" href="add"><xsl:value-of select="//c[@id='forum.add-comment']"/></a>
				<div class="content"></div>
				<div class="frm" id="frm_{$topicid}"></div>
			</div>
			
			<xsl:apply-templates select="//topic/pages"/>
			<div style="clear:both; height:10px"></div>
			
			<xsl:apply-templates select="//topic[@level=1]/msg"/>
			
			<xsl:apply-templates select="//topic/pages"/>
			<div style="height:50px"></div>
			
			
		</div>
	</xsl:template>



	<xsl:template match="pages">
		<div class="pages" style="padding:25px; clear:both">
			<xsl:for-each select="page">
				<div class="pagesplit ui-corner-all">
					<xsl:if test="@here">
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="not(@here)">
						<a class="forumpage_link" href="/ua/forums/{//topic/@id}/{.}"><xsl:value-of select="."/></a>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>



	<xsl:template match="msg">
		<xsl:if test="@approved=1 or @approved=2">
			<div class="msg" id="{@id}" dir="{//topic/@dir}" level="{../@level}">
				<div style="margin-left:{((../@level)-1)*30}px; clear:both">
					<div class="content">
						<span style="margin-right:20px; color:#039">
							<b><xsl:value-of select="username"/></b>
							<!--<xsl:if test="not(answers=0)">&amp;nbsp;(answers: <xsl:value-of select="answers"/>)</xsl:if>-->
						</span>
		
						<span class="title" style="margin-right:20px; clear:right; font-weight:bold">
							<xsl:value-of select="title"/>
						</span>
		
						<!--<xsl:value-of select="header"/>-->
						<div style="padding:0.3em 0">
							<xsl:value-of select="content"/>
						</div>
						<xsl:if test="/out/user/level=1"> <!-- CHECK ON ABSOLUTELY ADMIN -->
							<div>
								<a href="/prg/editpage.php?mode=forum&amp;act=delmsg&amp;msg_id={@id}" class="aj once" target="#{@id}">
									<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-trash"></span></div>
								</a>
								<a href="/prg/editpage.php?mode=forum&amp;act=move&amp;msg_id={@id}" class="aj once" target="#{@id}">
									<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-extlink"></span></div>
								</a>
								
								<xsl:if test="@approved=0 or @approved=2">
									<a href="/prg/editpage.php?mode=forum&amp;act=approve&amp;msg_id={@id}" class="aj once" target="#frm_{@id}">
										<div class="ui-state-default ui-corner-all hdr-ico icon"><span class="ui-icon ui-icon-check"></span></div>
									</a>
								</xsl:if>
							</div>
						</xsl:if>
					</div>
					
					<div class="footer">
						<span class="date"><xsl:value-of select="created"/></span>
						<span>
							<a class="forum-append-form" href="answer"><xsl:value-of select="//c[@id='forum.answer']"/></a>
						</span>
						<span>
							<a class="forum-append-form" href="complain"><xsl:value-of select="//c[@id='forum.complain']"/></a>
						</span>
						
						
						
					</div>
					<div class="frm" id="frm_{@id}"></div>
				</div>
			</div>	
			<div style="clear:both" class="childs" id="childsof_{@id}">
				<xsl:apply-templates select="thread/topic/msg">
					<xsl:sort select="answers" order="descending"/>
				</xsl:apply-templates>
			</div>
		</xsl:if>
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


	<xsl:template name="add-comment">
		<xsl:param name="title"/>
		<xsl:param name="topic" select="//topic/@id"/>
		<xsl:param name="target">comments</xsl:param>
		<div id="forum-form-place">
			<div class="ui-state-highlight ui-corner-all" id="forum-temp-form">
				<div style="cursor:pointer">
					<div class="form_title" style="padding:3px 25px; background:url(/img/icons/add.png) no-repeat;">
						<xsl:value-of select="//locale/c[@id='forum.add-comment']"/>
					</div>
				</div>
				<div class="input-form">
					<table width="100%"><tr><td>
						<form action="/prg/editpage.php?mode=forum&amp;act=post" target="{$target}">
							<input type="hidden" name="topic" value="{$topic}"/>
							<input type="hidden" name="dir" value="{//topic/@id}"/>
							<input type="hidden" name="level"/>
							<input type="hidden" name="mtype"/>
							<input type="hidden" name="lang" value="{/out/@lang}"/>
							<input type="hidden" name="temp" value="standart/forum"/>
							
							<xsl:if test="not(//user/@id)">
							<div>
								<h4><xsl:value-of select="//locale/c[@id='forum.fields.name']"/></h4>
								<input name="name" type="text" style="width:300px;"/>
							</div>
							<div>
								<h4><xsl:value-of select="//locale/c[@id='forum.fields.email']"/></h4>
								<input name="email" type="text" style="width:300px;" />
							</div>
							<div>
								<h4><xsl:value-of select="//locale/c[@id='forum.fields.phone']"/></h4>
								<input name="phone" type="text" style="width:300px;" />
							</div>
							</xsl:if>
							<xsl:if test="//user/@id">
							<h3 style="margin:1em 0"><xsl:value-of select="//user/name"/></h3>
							<input name="name" type="hidden" value="{//user/name}"/>
							</xsl:if>
							
							<div>
								<h4><xsl:value-of select="//locale/c[@id='forum.fields.header']"/></h4>
								<input name="title" type="text" style="width:100%;" />
							</div>
							
							<h4><xsl:value-of select="//locale/c[@id='forum.fields.content']"/></h4>
							<textarea name="content" title="Message"></textarea>
							
							<button><xsl:value-of select="//locale/c[@id='forum.add']"/></button>
							<div style="clear:both"></div>
						</form>
					</td>
					<td width="40%">
						<div class="instructions ui-widget-content ui-corner-all" style="padding:0 1em; margin:10px"></div>
					</td>
					</tr></table>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
