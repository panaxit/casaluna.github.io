<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
exclude-result-prefixes="#default xsl"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="/">
		<ul id="shell_buttons" class="nav col-md-4 justify-content-end list-unstyled d-flex">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="*">
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-info">Button</button>
			</a>
		</li>
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-secondary">Cancelar</button>
			</a>
		</li>
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-success">Continuar</button>
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
