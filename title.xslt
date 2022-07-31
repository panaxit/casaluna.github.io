<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:px="http://panax.io/entity"
exclude-result-prefixes="#default xsl px"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="/">
		<h1>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

	<xsl:template match="px:Entity">
		<xsl:apply-templates select="@headerText"/>
	</xsl:template>

	<xsl:template match="@headerText">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="@headerText[starts-with(.,'Tipo')]">
		<xsl:value-of select="concat(substring(.,1,5), 'de ', substring(.,6))"/>
	</xsl:template>
</xsl:stylesheet>
