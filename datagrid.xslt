<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout_datagrid="http://panax.io/layout"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:CardView="http://panax.io/widgets/cardview"
  xmlns:metadata="http://panax.io/metadata"
  xmlns:temp="http://panax.io/temp"
  xmlns:data="http://panax.io/source"
  xmlns:story="urn:item:story"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:px="http://panax.io/entity"
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl datagrid container CardView data height width data story temp"
>
	<xsl:import href="templates/datagrid.xslt"/>
	<xsl:template match="/">
		<div class="container">
			<xsl:apply-templates select="px:Entity/layout_datagrid:layout"/>
		</div>
	</xsl:template>

	<xsl:template match="layout_datagrid:layout">
		<xsl:param name="rows" select="../data:rows/*"/>
		<xsl:param name="fields" select="../px:Record/*"/>
		<xsl:apply-templates mode="datagrid:widget" select=".">
			<xsl:with-param name="rows" select="$rows"/>
			<xsl:with-param name="fields" select="$fields"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="headerText" match="*[@headerText]">
		<xsl:value-of select="@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout_datagrid:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout_datagrid:layout//container:*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Name=current()/@name]"/>
		<xsl:apply-templates mode="headerText" select="$field"/>
	</xsl:template>

</xsl:stylesheet>