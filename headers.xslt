<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:container="http://panax.io/layout/container"
>

	<xsl:template mode="headerText" match="*">
		<xsl:value-of select="@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@Id]"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//container:*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Name=current()/@Name]"/>
		<xsl:apply-templates mode="headerText" select="$field"/>
	</xsl:template>

</xsl:stylesheet>