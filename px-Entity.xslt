<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widget/form"
  xmlns:custom="http://panax.io/custom"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:file="http://panax.io/widget/file"
  xmlns:picture="http://panax.io/widget/picture"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl form combobox data px meta container"
  extension-element-prefixes="state"
>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="panax/manifest.xslt"/>
	<xsl:param name="data:rows"/>
	
	<xsl:key name="widget" match="@Fotos" use="concat('files:',ancestor::px:Entity[1]/@xo:id,'::',name())"/>
</xsl:stylesheet>