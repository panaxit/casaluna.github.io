<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:px="http://panax.io/entity"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="#default xsl px xsi xo"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="/">
		<div id="page_controls">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='datagrid:control']">
		<nav aria-label="Page navigation" xo-scope="{@xo:id}">
			<ul class="pagination justify-content-center">
				<li class="page-item disabled">
					<a class="page-link">Previous</a>
				</li>
				<li class="page-item">
					<a class="page-link" href="#" onclick="store.$('//px:Entity/@data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:=1/10'))">1</a>
				</li>
				<li class="page-item">
					<a class="page-link" href="#" onclick="store.$('//px:Entity/@data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:=2/10'))">2</a>
				</li>
				<li class="page-item">
					<a class="page-link" href="#" onclick="store.$('//px:Entity/@data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:=3/10'))">3</a>
				</li>
				<li class="page-item">
					<a class="page-link" href="#">Next</a>
				</li>
			</ul>
		</nav>
	</xsl:template>
</xsl:stylesheet>
