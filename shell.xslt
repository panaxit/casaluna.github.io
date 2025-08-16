<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
>
	<xsl:import href="panax/widgets/shell.xslt"/>

	<xsl:template mode="shell:nav-img-attributes" match="@*">
		<xsl:attribute name="src">assets/logo.png</xsl:attribute>
	</xsl:template>

	<xsl:template mode="shell:nav-attributes" match="@*|*">
		<xsl:attribute name="data-bs-theme">dark</xsl:attribute>
	</xsl:template>

	<xsl:template mode="shell:nav-title" match="*|@*">
		<h1 xo-source="active" xo-stylesheet="title.xslt"></h1>
	</xsl:template>

	<xsl:template mode="shell:extra" match="*|@*">
		<menu class="settings" xo-source="#settings"/>
	</xsl:template>

	<xsl:template mode="shell:footer-content" match="*|@*">
		<nav id="page_controls" xo-source="active" xo-stylesheet="page_controls.xslt" class="col-md-8 d-flex align-items-center">
		</nav>
		<menu id="shell_buttons" xo-source="active" xo-stylesheet="shell_buttons.xslt">
			<ul class="col-12 nav justify-content-end list-unstyled d-flex">
			</ul>
		</menu>
	</xsl:template>

	<xsl:template mode="shell:nav-brand" match="@xo:id">
		<xsl:apply-templates mode="shell:nav-brand" select="../@*[name()!=name(current())][1]"/>
	</xsl:template>

	<xsl:template mode="shell:body-content" match="*|@*">
		<div class="welcome" style="flex-direction: column;">
		</div>
	</xsl:template>

	<xsl:template mode="shell:nav-brand" match="*|@*">
		<picture class="logo" id="logo" style="min-width: 60px">
			<source media="(min-width: 64em)" src="high-res.jpg"/>
			<source media="(min-width: 37.5em)" src="med-res.jpg"/>
			<source src="assets/logo.png"/>
			<img src="assets/logo.png" width="40.61px">
				<xsl:apply-templates mode="shell:nav-img-attributes" select="."/>
			</img>
		</picture>
	</xsl:template>
</xsl:stylesheet>
