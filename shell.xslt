<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:x="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:attributes="http://panax.io/attributes"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
xmlns:xlink="http://www.w3.org/1999/xlink"
exclude-result-prefixes="#default x session sitemap shell state source"
>
	<xsl:include href="widgets/panax/shell.xslt"/>

	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template mode="shell:attributes-nav-img" match="*">
		<xsl:attribute name="src">assets/logo.png</xsl:attribute>
	</xsl:template>

	<xsl:template mode="shell:nav-title" match="*|@*">
		<header class="section_nav navbar-form hpadding0 hmargecontenidozul">
			<h1 xo-store="active" xo-stylesheet="title.xslt"></h1>
		</header>
	</xsl:template>

	<xsl:template mode="shell:extra-content" match="*|@*">
		<aside class="sidebar" xo-store="#sitemap" xo-stylesheet="sitemap.xslt" id="sitemap">
			<style><![CDATA[aside.sidebar {width:0%}]]></style>
		</aside>
		<div class="settings" xo-store="#settings" xo-stylesheet="settings.xslt"/>
	</xsl:template>

	<xsl:template mode="shell:footer-content" match="*|@*">
		<div id="page_controls" xo-store="active" xo-stylesheet="page_controls.xslt" class="col-md-8 d-flex align-items-center">
		</div>
		<ul id="shell_buttons" class="nav col-md-4 justify-content-end list-unstyled d-flex" xo-store="active" xo-stylesheet="shell_buttons.xslt"></ul>
	</xsl:template>
</xsl:stylesheet>
