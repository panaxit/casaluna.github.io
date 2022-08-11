<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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
  xmlns:layout="http://panax.io/layout/view/form"
  exclude-result-prefixes="xo state xsl CardView data height width data story temp px layout"
>
	<xsl:key name="money" match="dummy" use="@Name"/>

	<xsl:template match="@*[key('money',name())]">
		<xsl:value-of select="format-number(.,'$#,##0.00###;-$#,##0.00###')"/>
	</xsl:template>

	<xsl:template match="@*[.='']">
		<xsl:value-of select="."/>
	</xsl:template>

</xsl:stylesheet>