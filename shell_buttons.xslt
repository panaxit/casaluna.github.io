<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:px="http://panax.io/entity"
xmlns:xo="http://panax.io/xover"
xmlns:state="http://panax.io/state"
xmlns:site="http://panax.io/site"
xmlns:shell="http://panax.io/shell"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:initial="http://panax.io/state/initial"
xmlns:data="http://panax.io/source"
exclude-result-prefixes="#default xsl px xo xsi"
>
	<xsl:import href="widgets/keys.xslt"/>
	<xsl:import href="widgets/shell_buttons.xslt"/>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="key('entity', 'form:Ventas/Venta')/data:rows/xo:r/@xo:id" mode="shell:buttons">
		<xsl:if test="../descendant-or-self::xo:r[key('changed',@xo:id)]">
			<li class="ms-3">
				<a class="text-muted" href="#" onclick="px.submit(scope)">
					<button class="btn btn-success">Guardar</button>
				</a>
			</li>
		</xsl:if>
		<li class="ms-3">
			<a class="text-muted" href="#" onclick="ventas.toggleRecibo(scope)">
				<button class="btn btn-info">Ver/ocultar recibo</button>
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
