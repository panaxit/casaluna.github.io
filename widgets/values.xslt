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
	<xsl:key name="value" match="xo:r/@*" use="concat(../@xo:id,'::',name())"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="time" match="px:Field[@DataType='time']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="password" match="dummy" use="''"/>
	<xsl:key name="combobox" match="dummy" use="''"/>

	<xsl:key name="combobox_text" match="px:Association/px:Entity/data:rows/xo:r/@text" use="concat(ancestor::px:Entity[2]/@xo:id,'::',ancestor::px:Association/px:Mappings/px:Mapping/@Referencer,'::',../@Id)"/>

	<xsl:template name="format">
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="mask">'$#,##0.00###;-$#,##0.00###'</xsl:param>
		<xsl:param name="value_for_invalid"></xsl:param>
		<xsl:choose>
			<xsl:when test="number($value)=$value">
		<xsl:value-of select="format-number($value,$mask)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value_for_invalid"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*[key('money',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:value-of select="format-number(translate(.,'$,',''),'$#,##0.00###;-$#,##0.00###')"/>
	</xsl:template>

	<xsl:template match="@*[key('password',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:text>**********</xsl:text>
	</xsl:template>

	<xsl:template match="@*[key('time',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:value-of select="substring(.,1,5)"/>
	</xsl:template>

	<xsl:template match="@*[key('combobox',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:value-of select="key('combobox_text',concat(ancestor::px:Entity[1]/@xo:id,'::',name(),'::',.))[1]"/>
	</xsl:template>

	<xsl:template match="@*[.='']">
		<xsl:value-of select="."/>
	</xsl:template>
</xsl:stylesheet>