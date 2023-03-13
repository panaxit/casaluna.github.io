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
	<xsl:import href="keys.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="widgets/manifest.xslt"/>
	<xsl:param name="data:rows"/>
	<!--<xsl:param name="state:dirty"/>-->
	<xsl:key name="readonly" match="@meta:FK_Lotes_StatusLotes" use="concat(ancestor::px:Entity[1]/@xo:id,'::',name())"/>
	<xsl:key name="widget" match="@Fotos" use="concat('files:',ancestor::px:Entity[1]/@xo:id,'::',name())"/>

	<xsl:template mode="headerText" match="key('field','Compras.Orden.FechaAutorizacion')" priority="5">
		Autorización
	</xsl:template>

	<xsl:template mode="widget" match="key('field','Compras.Orden.FechaAutorizacion')" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="data" select="node-expected"/>
		<xsl:param name="field" select="node-expected"/>
		<xsl:param name="row" select="node-expected"/>
		<label for="{@xo:id}" class="col-form-label">
			<xsl:for-each select="$data">
				<xsl:choose>
					<xsl:when test="$data=''">
						<button type="button" class="btn btn-success"  xo-scope="{../@xo:id}" xo-attribute="{name()}" onclick="scope.set(new Date().toISOString())">Autorizar</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</label>
	</xsl:template>

	<xsl:template mode="widget" match="@NumeroOC[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="node-expected"/>
		<xsl:param name="row" select="node-expected"/>
		<label for="{@xo:id}" class="col-form-label">
			<xsl:value-of select="."/>
		</label>
	</xsl:template>

	<xsl:template mode="widget" match="@MontoTotal[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="node-expected"/>
		<xsl:param name="row" select="node-expected"/>
		<xsl:variable name="monto">
			<xsl:choose>
				<xsl:when test="number(../@Monto)=../@Monto">
					<xsl:value-of select="number(../@Monto)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="descuento">
			<xsl:choose>
				<xsl:when test="number(../@Descuento)=../@Descuento">
					<xsl:value-of select="number(../@Descuento)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<label for="{@xo:id}" class="col-form-label">
			<xsl:value-of select="format-number($monto - $descuento,'$#,##0.00')"/>
		</label>
	</xsl:template>

	<xsl:template mode="widget" match="@MontoRestante[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="node-expected"/>
		<xsl:param name="row" select="node-expected"/>
		<xsl:variable name="monto">
			<xsl:choose>
				<xsl:when test="number(../@Monto)=../@Monto">
					<xsl:value-of select="number(../@Monto)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="descuento">
			<xsl:choose>
				<xsl:when test="number(../@Descuento)=../@Descuento">
					<xsl:value-of select="number(../@Descuento)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="cobros">
			<xsl:choose>
				<xsl:when test="number(../@Cobros)=../@Cobros">
					<xsl:value-of select="number(../@Cobros)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="amount" select="$monto - $descuento - $cobros"/>
		<xsl:variable name="class">
			<xsl:if test="$amount&lt;0">text-danger</xsl:if>
		</xsl:variable>
		<label for="{@xo:id}" class="col-form-label {$class}">
			<xsl:value-of select="format-number($amount,'$#,##0.00')"/>
		</label>
	</xsl:template>

	<xsl:template mode="combobox:previous-options" match="@meta:FK_Lotes_Clientes1|@meta:FK_Lotes_Proveedores1">
	</xsl:template>

	<xsl:template mode="combobox:option" match="px:Association[@AssociationName='FK_Lotes_Clientes1']/px:Entity[@Name='Clientes']/data:rows/xo:r/@*">
		<xsl:param name="selected_value"/>
		<xsl:param name="referencee_entity" select="ancestor-or-self::*[@meta:type='entity'][1]"/>
		<!--<option>
			<xsl:value-of select="../@Id"/> - - <xsl:value-of select="../@xo:id"/> - - <xsl:value-of select="../@meta:text"/> - - <xsl:value-of select="$selected_value"/>
		</option>-->
		<!--<option>
			<xsl:value-of select="$selected_value"/>
		</option>-->
		<xsl:if test="contains($selected_value,concat(../@Id,'/'))">
			<option xo-scope="{../@xo:id}" value="{current()}">
				<xsl:variable name="selected">
					<xsl:choose>
						<xsl:when test="contains($selected_value,concat(../@Id,'/',../@Vendedor))">true</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$selected = 'true'">
					<xsl:attribute name="selected"/>
				</xsl:if>
				<!--<xsl:value-of select="current()/../@*[name()=$referencee_entity/@custom:displayText]|../@meta:text[not($referencee_entity/@custom:displayText)]|current()[not(../@meta:text)]"/>-->
				<xsl:value-of select="../@meta:text"/>
			</option>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="combobox:option" match="px:Association[@AssociationName='FK_Lotes_Proveedores1']/px:Entity[@Name='Proveedores']/data:rows/xo:r/@*">
		<xsl:param name="selected_value"/>
		<xsl:param name="referencee_entity" select="ancestor-or-self::*[@meta:type='entity'][1]"/>
		<!--<option>
			<xsl:value-of select="../@Id"/> - - <xsl:value-of select="../@xo:id"/> - - <xsl:value-of select="../@meta:text"/> - - <xsl:value-of select="$selected_value"/>
		</option>-->
		<!--<option>
			<xsl:value-of select="$selected_value"/>
		</option>-->
		<xsl:if test="contains($selected_value,concat(../@Id,'/'))">
			<option xo-scope="{../@xo:id}" value="{current()}">
				<xsl:variable name="selected">
					<xsl:choose>
						<xsl:when test="contains($selected_value,concat(../@Id,'/',../@Comprador))">true</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$selected = 'true'">
					<xsl:attribute name="selected"/>
				</xsl:if>
				<!--<xsl:value-of select="current()/../@*[name()=$referencee_entity/@custom:displayText]|../@meta:text[not($referencee_entity/@custom:displayText)]|current()[not(../@meta:text)]"/>-->
				<xsl:value-of select="../@meta:text"/>
			</option>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@meta:FK_Lotes_Moneda">
		<xsl:variable name="unidad_medida">
			<xsl:apply-templates select="../@meta:FK_Lotes_UnidadMedidaLotes"/>
		</xsl:variable>
		<xsl:value-of select="."/>
		<xsl:if test="$unidad_medida!=''">
			<xsl:text/> / <xsl:text/>
			<xsl:value-of select="$unidad_medida"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="key('data_rows','Compras/Lotes')/@Cantidad">
		<xsl:variable name="unidad_medida">
			<xsl:apply-templates select="../@meta:FK_Lotes_UnidadMedidaLotes"/>
		</xsl:variable>
		<xsl:value-of select="."/>
		<xsl:if test="$unidad_medida!=''">
			<xsl:value-of select="concat(' ',$unidad_medida)"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="key('data_rows','Logistica/Lotes')/@meta:FK_Embarques_Despacho" mode="widget-attributes">
		<xsl:variable name="catalog" select="key('dataset',concat(ancestor::px:Entity[1]/@xo:id,'.',name()))"/>
		<xsl:variable name="color" select="$catalog[@meta:text=current()]/@Color"/>
		<xsl:if test="string($color)!=''">
			<xsl:attribute name="style">
				color:white; background-color:<xsl:value-of select="$color"/>;
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!--<xsl:template mode="widget" match="xo:r[@Id!='']/@meta:FK_Lotes_OrdenDetalle[.='']" priority="1">
		<button type="button" id="btn-export" class="btn btn-success" xo-scope="{../@xo:id}" onclick="xo.server.request({{command:'Compras.CrearOrdenCompra', '@IdLote':'{../@Id}'}})">
			Generar orden de compra
		</button>
	</xsl:template>-->

	<xsl:template mode="widget" match="xo:r[@Id!='']/@meta:FK_Lotes_OrdenDetalle[.='']" priority="1">
		<button type="button" id="btn-export" class="btn btn-success" xo-scope="{../@xo:id}">
			<xsl:attribute name="onclick">
				<![CDATA[exportHTML({file:'contrato_'+scope.get("meta:FK_Lotes_Empresa").toLowerCase().replace(/\s+/,'_'), mappings: { numero_orden: scope.get("NumeroLote"), contacto: prompt("A quién se va a dirigir el contrato?"), comprador: scope.get("meta:FK_Lotes_Compradores"), proveedor: scope.get("meta:FK_Lotes_Proveedores"), unidad_medida: scope.get("UnidadMedida"), cantidad: scope.get("Cantidad"), precio_compra: new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(scope.get("PrecioCompra")), moneda_compra: scope.get("MonedaCompra"), fechas_de_embarque: scope.get("ETA"), material: scope.$("meta:FK_Lotes_Materiales"), referencias: scope.$("Asunto/@value"), concepto: scope.$$('//Detalle/IdArticulo/@text'), monto:  scope.$$('//Detalle/CostoTotal/@value'), fecha: new Date().toLongDateString() }})]]>
			</xsl:attribute>
			Generar formato
		</button>
	</xsl:template>

	<xsl:template mode="widget" match="xo:r/@meta:FK_Lotes_StatusLotes" priority="1">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!--<xsl:template mode="file:preceding-siblings" match="@*" priority="1">
		<xsl:apply-templates mode="picture:widget" select="."/>
	</xsl:template>-->
</xsl:stylesheet>