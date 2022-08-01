<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:px="http://panax.io/entity"
xmlns:data="http://panax.io/source"
xmlns:state="http://panax.io/state"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="#default xsl px xsi xo data state"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="/">
		<div id="page_controls">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='datagrid:control']/data:rows">
		<nav aria-label="Page navigation" xo-scope="{@xo:id}">
			<ul class="pagination justify-content-center">
				<xsl:variable name="pageIndex" select="@state:pageIndex"/>
				<xsl:variable name="pageSize" select="@state:pageSize"/>
				<xsl:variable name="totalRows" select="*/@state:totalCount"/>
				<xsl:if test="$totalRows &gt; $pageSize">
					<li class="page-item">
						<xsl:if test="$pageIndex = 1">
							<xsl:attribute name="class">page-item disabled</xsl:attribute>
						</xsl:if>
						<a class="page-link" href="#" onclick="scope.parentNode.getAttributeNode('data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:={$pageIndex - 1}/{$pageSize}'))">
							Anterior
						</a>
					</li>
					<xsl:for-each select="(//*)[position() &lt;= ceiling($totalRows div $pageSize)]">
						<li class="page-item">
							<a class="page-link" href="#" onclick="scope.parentNode.getAttributeNode('data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:={position()}/{$pageSize}'))">
								<xsl:value-of select="position()"/>
							</a>
						</li>
					</xsl:for-each>
					<li class="page-item">
						<xsl:if test="$pageIndex + 1 &gt; ceiling($totalRows div $pageSize)">
							<xsl:attribute name="class">page-item disabled</xsl:attribute>
						</xsl:if>
						<a class="page-link" href="#" onclick="scope.parentNode.getAttributeNode('data:rows').set(value=> value.replace(/#:=\d+\/\d+/g,'#:={$pageIndex + 1}/{$pageSize}'))">
							Siguiente
						</a>
					</li>
				</xsl:if>
			</ul>
		</nav>
	</xsl:template>
</xsl:stylesheet>
