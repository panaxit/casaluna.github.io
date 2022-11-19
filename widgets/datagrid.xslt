<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout_datagrid="http://panax.io/layout"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:meta="http://panax.io/metadata"
  xmlns:custom="http://panax.io/custom"
  xmlns:temp="http://panax.io/temp"
  xmlns:data="http://panax.io/source"
  xmlns:story="urn:item:story"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:px="http://panax.io/entity"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:form="http://panax.io/widget/form"
  xmlns:widget="http://panax.io/widget"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl datagrid container data height width data story temp meta custom"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="panax/datagrid.xslt"/>
	<xsl:param name="data:rows"/>

	<xsl:key name="datagrid:widget" match="node-expected" use="@xo:id"/>

	<xsl:template mode="datagrid:row-header" match="@*">
		<xsl:variable name="dataset" select="parent::xo:r"/>
		<xsl:variable name="identity" select="../@meta:id"/>
		<xsl:variable name="reference">
			<xsl:choose>
				<xsl:when test="$identity">
					<xsl:value-of select="concat(':',$identity)"/>
				</xsl:when>
				<xsl:when test="../@meta:value">
					<xsl:value-of select="concat('/',../@meta:value)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--<th scope="row">
			<xsl:value-of select="../@meta:position"/>
		</th>-->
		<th>
			<xsl:if test="$reference!=''">
				<button class="btn btn-sm btn-primary" onclick="px.navigateTo('{$dataset/ancestor::px:Entity[1]/@Schema}/{$dataset/ancestor::px:Entity[1]/@Name}{$reference}~edit','{ancestor::px:Entity[1]/data:rows/@xo:id}')">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
						<path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
					</svg>
				</button>
			</xsl:if>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:row-footer" match="@*">
		<xsl:variable name="identity" select="../@meta:id"/>
		<th style="text-align: right;">
			<xsl:if test="parent::xo:r">
				<button class="btn btn-sm btn-danger" onclick="scope.remove()">
					<!--<xsl:if test="not($identity!='')">
						<xsl:attribute name="onclick">scope.remove()</xsl:attribute>
					</xsl:if>-->
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
						<path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
						<path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
					</svg>
				</button>
			</xsl:if>
		</th>
	</xsl:template>

	<xsl:key name="no-details" match="xo:r[@meta:FK_Lotes_StatusLotes='Baja']" use="@xo:id"/>
	<xsl:template mode="datagrid:row-header" match="xo:r[key('no-details',@xo:id)]/@*">
		<xsl:variable name="identity" select="../@meta:id"/>
		<th>
			&#160;
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:row-footer" match="xo:r[key('no-details',@xo:id)]/@*">
		<xsl:variable name="identity" select="../@meta:id"/>
		<th>
			&#160;
		</th>
	</xsl:template>

	<!--<xsl:key name="reference" match="px:Association/@AssociationName" use="concat(ancestor::px:Entity[1]/data:rows/xo:r/@xo:id,'::body::association:ref::',.)"/>-->
	<!--<xsl:key name="reference" match="px:Association/px:Entity[1]/data:rows/xo:r" use="ancestor::px:Association[1]/@AssociationName"/>-->
	<xsl:key name="reference" match="px:Association/px:Entity[1]/data:rows/xo:r/@xo:id" use="concat(.,'::body::association:ref::',ancestor::px:Association[1]/@AssociationName)"/>

	<!--<xsl:template mode="datagrid:cell-content" match="@*">
		<xsl:param name="context">body</xsl:param>
		<xsl:param name="dataset" select="node-expected"/>
		-->
	<!--<xsl:apply-templates mode="widget" select="."/>-->
	<!--
		<xsl:apply-templates mode="datagrid:cell-content" select="key('reference',concat($dataset,'::',$context,'::',name(..),'::',../@Name))"/>
	</xsl:template>-->

	<xsl:template mode="datagrid:cell-content" match="*[key('datagrid:header-node',@xo:id)]/@*">
		<span>
			<xsl:attribute name="scope">col</xsl:attribute>
			<xsl:attribute name="ondblclick">this.toggle('contenteditable','')</xsl:attribute>
			<xsl:attribute name="xo-scope">
				<xsl:value-of select="../@xo:id"/>
			</xsl:attribute>
			<xsl:attribute name="xo-attribute">headerText</xsl:attribute>
			<xsl:apply-templates mode="headerText" select="."/>
		</span>
	</xsl:template>

	<xsl:template match="key('entity','CatalogosSistema.Moneda')/data:rows/xo:r/@meta:text">
		<xsl:param name="referencer" select="."/>
		<xsl:value-of select="."/> / <xsl:value-of select="$referencer/../@meta:FK_Lotes_UnidadMedidaLotes"/>
	</xsl:template>

	<!--
	<xsl:template mode="headerText" match="layout:layout//*">
		<xsl:param name="fields" select="node-expected"/>
		<xsl:param name="row" select="node-expected"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//container:*">
		<xsl:param name="fields" select="node-expected"/>
		<xsl:variable name="field" select="$fields[@Name=current()/@name]"/>
		<xsl:apply-templates mode="headerText" select="$field"/>
	</xsl:template>-->

	<xsl:template mode="datagrid:row-style" match="key('entity','datagrid:Inventarios.Lotes')/data:rows[parent::*/@state:selectRecords]/xo:r[@state:selected]/@*">
		<xsl:text>outline: var(--outline-selection);</xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:row-style" match="key('entity','datagrid:Inventarios.Lotes')/data:rows[parent::*/@state:selectRecords]/xo:r[@state:selected and @Status='Baja']/@*">
		<xsl:text>outline: var(--outline-selection-warning);</xsl:text>
	</xsl:template>

	<xsl:template mode="datagrid:row-header" match="key('entity','datagrid:Inventarios.Lotes')/data:rows[parent::*/@state:selectRecords]/xo:r/@*">
		<th xo-scope="xo_id_f079a4d1_d1e5_403e_ac01_01c11a2abad5">
			<input type="checkbox" name="select" class="form-check-input" value="{../@Id}" xo-scope="{../@xo:id}" xo-attribute="state:selected" onclick="scope.toggle(this.value, null)">
				<xsl:if test="../@state:selected">
					<xsl:attribute name="checked"/>
				</xsl:if>
			</input>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:field" match="key('entity','datagrid:Logistica.Embarques')/data:rows/xo:r/@meta:FK_Embarques_TipoEmbarque">
		<xsl:if test=".!=''">
			<img src="images/{.}.png"/>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="datagrid:field" match="key('entity','datagrid:Logistica.Embarques')/data:rows/xo:r/@PesoEntradaMT">
		<xsl:value-of select="../@custom:lotes"/>
		<br/>
		<xsl:value-of select="concat(., 'MT')"/>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:Logistica.Embarques')/data:rows/xo:r/@meta:FK_Embarques_Despacho">
		<span>
			<xsl:attribute name="style">
				<xsl:text>padding:10px;</xsl:text>
				<xsl:apply-templates mode="widget:style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:Logistica.Embarques')/data:rows/xo:r/@meta:FK_Embarques_Estado">
		<span>
			<xsl:attribute name="style">
				<xsl:text>padding:10px;</xsl:text>
				<xsl:apply-templates mode="widget:style" select="."/>
			</xsl:attribute>
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','datagrid:Inventarios.Almacen')/data:rows/xo:r/@Descripcion">
		<xsl:if test="number(../@custom:Lotes) != 0">
			<a href="#Inventarios/Lotes?Almacen={../@Id}" class="link">
				Lotes: <xsl:value-of select="../@custom:Lotes"/>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="widget:style" match="@*"/>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='ROJO' or .='PENDIENTE']|@meta:FK_Embarques_Despacho[.='ROJO' or .='PENDIENTE']">
		<xsl:text>background-color:red; color: white; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='VERDE']|@meta:FK_Embarques_Despacho[.='VERDE']">
		<xsl:text>background-color:green; color: white; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='ENTREGADO']|@meta:FK_Embarques_Despacho[.='ENTREGADO']">
		<xsl:text>background-color:#019c00; color:#fff; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='EN MOVIMIENTO']|@meta:FK_Embarques_Despacho[.='EN MOVIMIENTO']">
		<xsl:text>background-color:#ffff40; color:#000; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='ALMACENADO' or .='']|@meta:FK_Embarques_Despacho[.='ALMACENADO' or .='']">
		<xsl:text>background-color:gray; color: white; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='CANCELADO']|@meta:FK_Embarques_Despacho[.='CANCELADO']">
		<xsl:text>background-color: #999999; color: #fff; padding:10px;</xsl:text>
	</xsl:template>

	<xsl:template mode="widget:style" match="@meta:FK_Embarques_Estado[.='NUEVO' or .='']|@meta:FK_Embarques_Despacho[.='NUEVO' or .='']">
		<xsl:text>background-color:white; color: black; padding:10px;</xsl:text>
	</xsl:template>
</xsl:stylesheet>