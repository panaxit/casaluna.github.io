<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:sitemap="http://panax.io/sitemap"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:px="http://panax.io/entity"
  xmlns:data="http://panax.io/source"
  exclude-result-prefixes="xo xsl sitemap layout px data"
>
	<xsl:key name="item" match="sitemap:menu" use="'#any'"/>
	<xsl:key name="item" match="sitemap:catalog" use="'#any'"/>
	<xsl:key name="menu-item" match="sitemap:menu" use="@xo:id"/>

	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'.',@Name)"/>
	<xsl:key name="data_field" match="px:Entity/data:rows/*/@*" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',name())"/>
	<xsl:key name="field" match="px:Entity/px:Record/px:Field" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',@Name)"/>
</xsl:stylesheet>