<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout_datagrid="http://panax.io/layout"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:meta="http://panax.io/metadata"
  xmlns:temp="http://panax.io/temp"
  xmlns:data="http://panax.io/source"
  xmlns:story="urn:item:story"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:px="http://panax.io/entity"
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl datagrid container data height width data story temp"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="templates/datagrid.xslt"/>

	<xsl:key name="datagrid:widget" match="dummy" use="@xo:id"/>

	<xsl:template match="/">
		<div class="container-fluid" style="margin-top:0px;">
			<xsl:apply-templates mode="widget" select="px:Entity/@xo:id"/>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('datagrid:widget',concat(ancestor::px:Entity[1]/@xo:id,'.',name()))]">
		<xsl:param name="dataset" select="../data:rows/xo:r/@xo:id"/>
		<xsl:param name="layout" select="../*[local-name()='layout']/*/@Name"/>
		<xsl:param name="selection" select="dummy"/>
		<div class="row g-5" style="margin-top:0px;">
			<div class="col-md-9 col-lg-11">
				<xsl:apply-templates mode="datagrid:widget" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<!--<xsl:template mode="datagrid:row-attributes" match="@*">
		<xsl:attribute name="onclick">scope.set('state:selected',true)</xsl:attribute>
	</xsl:template>-->

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
		<th scope="row">
			<xsl:value-of select="../@meta:position"/>
		</th>
		<th>
			<xsl:if test="$reference!=''">
				<div class="btn btn-primary" onclick="px.navigateTo('{$dataset/ancestor::px:Entity[1]/@Schema}/{$dataset/ancestor::px:Entity[1]/@Name}~edit{$reference}','{ancestor::px:Entity[1]/data:rows/@xo:id}')">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
						<path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
						<path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
					</svg>
				</div>
			</xsl:if>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:row-footer" match="@*">
		<xsl:variable name="identity" select="../@meta:id"/>
		<th>
			<xsl:if test="parent::xo:r">
				<div class="btn btn-danger" onclick="scope.toggle('state:delete',true)">
					<xsl:if test="not($identity!='')">
						<xsl:attribute name="onclick">scope.remove()</xsl:attribute>
					</xsl:if>
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
						<path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
						<path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
					</svg>
				</div>
			</xsl:if>
		</th>
	</xsl:template>

	<!--<xsl:key name="reference" match="px:Association/@AssociationName" use="concat(ancestor::px:Entity[1]/data:rows/xo:r/@xo:id,'::body::association:ref::',.)"/>-->
	<!--<xsl:key name="reference" match="px:Association/px:Entity[1]/data:rows/xo:r" use="ancestor::px:Association[1]/@AssociationName"/>-->
	<xsl:key name="reference" match="px:Association/px:Entity[1]/data:rows/xo:r/@xo:id" use="concat(.,'::body::association:ref::',ancestor::px:Association[1]/@AssociationName)"/>

	<xsl:template mode="datagrid:cell-content" match="*[key('datagrid:nodeType',concat(@xo:id,'::header'))]/@*">
		<xsl:attribute name="scope">col</xsl:attribute>
		<xsl:attribute name="ondblclick">this.toggle('contenteditable','')</xsl:attribute>
		<xsl:attribute name="xo_scope"><xsl:value-of select="../@xo:id"/></xsl:attribute>
		<xsl:attribute name="xo-attribute">headerText</xsl:attribute>
		<xsl:apply-templates mode="headerText" select="."/>
	</xsl:template>
</xsl:stylesheet>