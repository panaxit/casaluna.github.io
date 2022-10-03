<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:px="http://panax.io/entity"
  xmlns:form="http://panax.io/widgets/form"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo state xsl form data px meta container"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="headers.xslt"/>
	<xsl:import href="datagrid.xslt"/>
	<xsl:import href="widgets.xslt"/>
	<xsl:import href="templates/form.xslt"/>
	<xsl:import href="templates/combobox.xslt"/>

	<xsl:key name="layout" match="*[local-name()='layout']" use="'#any'"/>
	<xsl:key name="layout" match="*[local-name()='layout']" use="@xo:id"/>

	<!-- layout -->
	<xsl:template mode="widget" match="@*[key('form:widget',concat(ancestor::*[@meta:type='entity'][1]/@xo:id,'.',name()))]">
		<xsl:param name="dataset" select="../data:rows/xo:r/@xo:id"/>
		<xsl:param name="layout" select="../*[local-name()='layout']/*/@Name"/>
		<xsl:param name="selection" select="dummy"/>
		<xsl:variable name="current" select="."/>
		<div class="row g-5" style="margin-top:0px;">
			<div class="col-md-9 col-lg-11">
				<xsl:apply-templates mode="form:widget" select="current()">
					<xsl:with-param name="dataset" select="$dataset"/>
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template mode="form:header" match="@*">
		<xsl:attribute name="scope">col</xsl:attribute>
		<xsl:attribute name="ondblclick">this.toggle('contenteditable','')</xsl:attribute>
		<xsl:attribute name="xo_scope"><xsl:value-of select="../@xo:id"/></xsl:attribute>
		<xsl:attribute name="xo-attribute">headerText</xsl:attribute>
		<xsl:apply-templates mode="headerText" select="key('reference',concat(ancestor::*[@meta:type='entity'][1]/@xo:id,'::header::',name(..),'::',../@Name))"/>
	</xsl:template>

	<!--<xsl:template mode="widget" match="px:Record/*">
		<xsl:param name="dataset" select="dummy"/>
		<span>
			<xsl:apply-templates mode="widget" select="$dataset"/>
		</span>
	</xsl:template>

	<xsl:template mode="widget" match="px:Record/px:Association[not(@Type='belongsTo')]">
		<xsl:param name="dataset" select="dummy"/>
		<span>
			<xsl:apply-templates select="px:Entity" mode="widget">
				<xsl:with-param name="reference" select="."/>
			</xsl:apply-templates>
		</span>
	</xsl:template>-->

	<xsl:template mode="widget" match="key('layout','#any')//*">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="schema" select="dummy"/>
		<xsl:variable name="value" select="$dataset/@*[name()=current()/@Name]"/>
		<span>
			<xsl:apply-templates mode="widget" select="$value">
				<xsl:with-param name="dataset" select="$dataset"/>
				<xsl:with-param name="schema" select="$schema[@Id=current()/@Id]|current()/self::container:*"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template mode="widget" match="key('layout','#any')//container:*">
		<xsl:param name="schema" select="dummy"/>
		<xsl:param name="dataset" select="dummy"/>
		<div class="input-group">
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:apply-templates mode="widget" select=".">
							<xsl:with-param name="schema" select="$schema[@Id=current()/@Id]|current()/self::container:*"/>
							<xsl:with-param name="dataset" select="$dataset"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<div class="input-group-append">
							<xsl:apply-templates mode="widget" select=".">
								<xsl:with-param name="schema" select="$schema[@Id=current()/@Id]|current()/self::container:*"/>
								<xsl:with-param name="dataset" select="$dataset"/>
							</xsl:apply-templates>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','Egresos.Compras.PrecioUnitario')" priority="5">
		<xsl:param name="dataset" select="dummy"/>
		<xsl:param name="schema" select="dummy"/>
		<xsl:param name="value" select="dummy"/>
		<xsl:variable name="current" select="."/>

		<xsl:variable name="TotalCompra">
			<xsl:choose>
				<xsl:when test="number(../@TotalCompra)=../@TotalCompra">
					<xsl:value-of select="number(../@TotalCompra)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Cantidad">
			<xsl:choose>
				<xsl:when test="number(../@Cantidad)=../@Cantidad">
					<xsl:value-of select="number(../@Cantidad)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="amount" select="$TotalCompra div $Cantidad"/>
		<xsl:variable name="class">
			<xsl:if test="$amount&lt;0">text-danger</xsl:if>
		</xsl:variable>
		<label for="{@xo:id}" class="form-input {$class}">
			<xsl:call-template name="format">
				<xsl:with-param name="value" select="$amount"/>
			</xsl:call-template>
		</label>
	</xsl:template>

	<xsl:template mode="widget" match="key('entity','Inventarios.Articulos')/data:rows/*/@PrecioVenta">
		<xsl:param name="schema" select="dummy"/>
		<xsl:param name="dataset" select="dummy"/>
		<xsl:variable name="current" select="."/>

		<xsl:variable name="PrecioPesos">
			<xsl:choose>
				<xsl:when test="number(../@PrecioPesos)=../@PrecioPesos">
					<xsl:value-of select="number(../@PrecioPesos)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="PrecioAjustes">
			<xsl:choose>
				<xsl:when test="number(../@PrecioAjustes)=../@PrecioAjustes">
					<xsl:value-of select="number(../@PrecioAjustes)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Gastos">
			<xsl:choose>
				<xsl:when test="number(../@Gastos)=../@Gastos">
					<xsl:value-of select="number(../@Gastos)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Paqueteria">
			<xsl:choose>
				<xsl:when test="number(../@Paqueteria)=../@Paqueteria">
					<xsl:value-of select="number(../@Paqueteria)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="CubreCertificado">
			<xsl:choose>
				<xsl:when test="number(../@CubreCertificado)=../@CubreCertificado">
					<xsl:value-of select="number(../@CubreCertificado)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Accesorios">
			<xsl:choose>
				<xsl:when test="number(../@Accesorios)=../@Accesorios">
					<xsl:value-of select="number(../@Accesorios)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Comision">
			<xsl:choose>
				<xsl:when test="number(../@Comision)=../@Comision">
					<xsl:value-of select="number(../@Comision)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="Utilidad">
			<xsl:choose>
				<xsl:when test="number(../@Utilidad)=../@Utilidad">
					<xsl:value-of select="number(../@Utilidad)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="PrecioVenta">
			<xsl:choose>
				<xsl:when test="number(.)=.">
					<xsl:value-of select="number(.)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="amount" select="$PrecioPesos + $PrecioAjustes + $Gastos + $Paqueteria + $CubreCertificado + $Accesorios + $Comision + $Utilidad"/>
		<xsl:variable name="class">
			<xsl:if test="$amount&lt;0">text-danger</xsl:if>
		</xsl:variable>
		<label for="{@xo:id}" class="form-input {$class}">
			<xsl:value-of select="format-number($PrecioVenta,'$#,##0.00')"/>
		</label>
		<xsl:if test="$PrecioVenta - $amount &lt; 0">
			<br/>
			<label for="{@xo:id}" class="form-input text-danger">
				<xsl:text/>El precio de venta no puede ser menor a los gatos (<xsl:text/> <xsl:value-of select="format-number($amount,'$#,##0.00')"/><xsl:text/>)<xsl:text/>
			</label>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>