<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:widget="http://panax.io/widget"
  xmlns:form="http://panax.io/widget/form"
  xmlns:custom="http://panax.io/custom"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:file="http://panax.io/widget/file"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:picture="http://panax.io/widget/picture"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:container="http://panax.io/layout/container"
  xmlns:calendar="http://panax.io/widget/calendar"
  exclude-result-prefixes="xo state xsl form combobox data px meta container"
  extension-element-prefixes="state"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="widgets/manifest.xslt"/>
	<xsl:param name="data:rows"/>

	<xsl:key name="widget" match="@Fotos" use="concat('files:',ancestor::px:Entity[1]/@xo:id,'::',name())"/>

	<xsl:key name="data_row" match="data:rows/xo:r/@FechaCita" use="concat(ancestor::px:Entity[1]/@xo:id,'::',substring(../@FechaCita,1,10))"/>

	<xsl:template match="@*" mode="calendar:body-reservation-attributes">
		<xsl:variable name="id" select="../@meta:id"/>
		<xsl:attribute name="href">
			<xsl:text>#Agenda/Citas:</xsl:text>
			<xsl:value-of select="$id"/>
			<xsl:text>~edit</xsl:text>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="@CostoPesos" mode="widget:attributes">
		<xsl:attribute name="disabled"/>
	</xsl:template>

	<xsl:template match="xo:r[@meta:FK_Articulos_Articulo!='']/@PrecioVenta[.='']" priority="5">
		<xsl:variable name="selection" select="../@IdArticulo"/>
		<xsl:variable name="value" select="key('dataset', concat(ancestor::px:Entity[1]/@xo:id,'.meta:','FK_Articulos_Articulo'))[@Id=$selection]/@PrecioVenta"/>
		<xsl:call-template name="format">
			<xsl:with-param name="value">
				<xsl:value-of select="$value"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="xo:r[@meta:FK_Articulos_Articulo!='']/@Utilidad" priority="5">
		<xsl:variable name="selection" select="../@IdArticulo"/>
		<xsl:variable name="value" select="key('dataset', concat(ancestor::px:Entity[1]/@xo:id,'.meta:','FK_Articulos_Articulo'))[@Id=$selection]/@PrecioVenta"/>
		<xsl:call-template name="format">
			<xsl:with-param name="value">
				<xsl:value-of select="sum($value|.)"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="field:ref[@Name='custom:foto']/@*" mode="headerText" priority="5">Foto</xsl:template>
	<xsl:template match="field:ref[@Name='custom:FK_OrdenDetalle_Orden']/@*" mode="headerText" priority="5">Artículos</xsl:template>

	<xsl:template match="@custom:foto" mode="datagrid:field">
		<xsl:apply-templates mode="picture:widget" select="."/>
	</xsl:template>

	<xsl:template mode="calendar:text" match="@Cliente[.!='']">
		<xsl:value-of select="."/>	<br/>
	</xsl:template>

	<xsl:template mode="calendar:text" match="@HoraCita[.!='']">
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(.,1,5)"/>
	</xsl:template>

	<xsl:template mode="calendar:text" match="@TipoCita[.!='']">
		<br/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template mode="calendar:body-reservation-description" match="@*">
		<xsl:apply-templates mode="calendar:text" select="../@Cliente"/>
		<xsl:apply-templates select="."/>
		<xsl:apply-templates mode="calendar:text" select="../@HoraCita"/>
		<xsl:apply-templates mode="calendar:text" select="../@TipoCita"/>
	</xsl:template>
</xsl:stylesheet>