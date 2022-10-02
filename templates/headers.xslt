<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:sitemap="http://panax.io/sitemap"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io/entity"
  xmlns:data="http://panax.io/source"
  xmlns:form="http://panax.io/widgets/form"
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo xsl sitemap layout px data form"
>

	<xsl:template mode="headerText" match="*[@headerText]/@*">
		<xsl:value-of select="../@headerText"/>
	</xsl:template>

</xsl:stylesheet>