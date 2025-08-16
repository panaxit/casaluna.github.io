<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:xo="http://panax.io/xover"
>
	<xsl:key name="item" match="sitemap:menu" use="'#any'"/>
	<xsl:key name="item" match="sitemap:catalog" use="'#any'"/>
	<xsl:key name="menu-item" match="sitemap:menu" use="@xo:id"/>

	<xsl:include href="panax/widgets/sitemap.xslt"/>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template mode="sitemap:target-href" match="*[@catalogName]">
		<xsl:attribute name="href">
			<xsl:value-of select="concat('#',translate(substring-before(@catalogName,'].['),'[]',''),'/',translate(substring-after(@catalogName,'].['),'[]',''))"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template mode="sitemap:img-attributes" match="@*">
		<span class="sidebar-brand mt-1 d-flex">
			<a href="javascript:void(0)" onclick="toggleSidebar()">
				<img src="assets/logotype-alpha-white.png" width="190px"/>
			</a>
		</span>
	</xsl:template>

</xsl:stylesheet>
