<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:js="http://panax.io/xover/javascript"
  xmlns:state="http://panax.io/state"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:source="http://panax.io/source"
  xmlns:custom="http://panax.io/custom"
  xmlns:px="http://panax.io/entity"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0" exclude-result-prefixes="xo state px source">
	<xsl:import href="templates/Recibo.xsl"/>
	<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="js:resources-path"><![CDATA[window.location.origin + '/' + window.location.pathname + 'templates/']]></xsl:param>
	<xsl:param name="js:now"><![CDATA[new Date().toISOString()]]></xsl:param>

	<xsl:decimal-format
	  name="money"
	  grouping-separator=","
	  decimal-separator="."/>

	<xsl:key name="blocked" match="*" use="true()"/>

	<xsl:key name="data" match="*[@Schema='Catalogos' and @Name='Sucursal']/data:rows/xo:r/@Domicilio" use="'domicilio'"/>
	<xsl:key name="data" match="*[@Schema='Catalogos' and @Name='Sucursal']/data:rows/xo:r/@Colonia" use="'colonia'"/>
	<xsl:key name="data" match="*[@Schema='Catalogos' and @Name='Sucursal']/data:rows/xo:r/@Celular" use="'cel'"/>
	<xsl:key name="data" match="*[@Schema='Catalogos' and @Name='Sucursal']/data:rows/xo:r/@Telefono" use="'telefono_sucursal'"/>
	<xsl:key name="data" match="@Folio" use="'Folio'"/>
	<xsl:key name="data" match="@Cliente" use="'Cliente'"/>
  <xsl:key name="data" match="/px:Entity/@xo:id" use="'FechaImpresion'"/>
	<xsl:key name="data" match="@Festejada" use="'Festejada'"/>
	<xsl:key name="data" match="@FechaCita" use="'FechaPrueba'"/>
  <xsl:key name="data" match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@FechaCaptura" use="'FechaVenta'"/>
	<xsl:key name="data" match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Domicilio" use="'DomicilioCliente'"/>
	<xsl:key name="data" match="@FechaFoto" use="'FechaFoto'"/>
	<xsl:key name="data" match="@FechaEvento" use="'FechaEvento'"/>
	<xsl:key name="data" match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Telefono" use="'Telefono'"/>
	<xsl:key name="data" match="@meta:FK_VentaDetalle_Articulos" use="'codigo'"/>
	<xsl:key name="data" match="*[@Schema='Ventas' and @Name='VentaDetalle']/data:rows/xo:r/@Notas" use="'descripcion'"/>
  <xsl:key name="data" match="@PrecioUnitario" use="'monto'"/>
	<xsl:key name="data" match="@xsl:descuento" use="'descuento'"/>
  <xsl:key name="data" match="@PrecioUnitario" use="'subtotal'"/>
  <xsl:key name="data" match="@PrecioUnitario" use="'total'"/>
  <xsl:key name="data" match="@PrecioUnitario" use="'total_monto'"/>
  <xsl:key name="data" match="@Anticipos" use="'total_anticipo'"/>

  <xsl:key name="data" match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Monto" use="'suma_subtotal'"/>
	<xsl:key name="data" match="@Descuento" use="'descuento_extra'"/>
	<xsl:key name="data" match="@meta:FK_MensajeReciboVenta_MensajeRecibo" use="'mensaje'"/>
	<xsl:key name="data" match="@MontoTotal" use="'total'"/>
  <xsl:key name="data" match="@Anticipos" use="'anticipos'"/>
	<xsl:key name="data" match="*[@Schema='Ventas' and @Name='VentaDetalle']/data:rows/xo:r/@PrecioUnitario" use="'articulos'"/>
	<xsl:key name="data" match="*[@Schema='Ingresos' and @Name='Cobros']/data:rows/xo:r/@Monto" use="'anticipo'"/>
	<xsl:key name="data" match="*[@Schema='Ingresos' and @Name='Cobros']/data:rows/xo:r/@FechaMovimiento" use="'fecha_anticipo'"/>
	<xsl:key name="data" match="@Notas" use="'notas'"/>
	<xsl:key name="data" match="@Talla" use="'medidas'"/>
	<xsl:key name="data" match="@Busto" use="'medidas'"/>
	<xsl:key name="data" match="@Cintura" use="'medidas'"/>
	<xsl:key name="data" match="@Cadera" use="'medidas'"/>
	<xsl:key name="data" match="@Brazo" use="'medidas'"/>
	<xsl:key name="data" match="@Anticipo" use="'fecha_anticipo'"/>
	<xsl:key name="data" match="@MontoRestante" use="'restante'"/>
	<xsl:key name="data" match="@meta:FK_Venta_Colaborador" use="'Vendedor'"/>

	<xsl:template mode="html.head" match="*">
		<link rel="stylesheet" href="{$js:resources-path}../xover/css/fontawesome.all.css" />
		<link rel="stylesheet" href="{$js:resources-path}../xover/css/bootstrap.min.css" />
	</xsl:template>

	<xsl:template mode="html.body" match="*">
		<style>
			<![CDATA[
   @media print {
      footer {page-break-after: always;}
   }

   span.Servicio, span.Ubicacion {
      white-space: pre-wrap;
   }
	  
	 .placeholder.fecha_anticipo { display:inline-block }
	 .placeholder.anticipo { display:inline-block }

   .watermarked::before {
      position: fixed;
      top: -75%;
      left: -75%;

      display: block;
      width: 300%;
      height: 300%;

      transform: rotate(-45deg);
      content: attr(data-watermark);

      font-size: 30px;
      opacity: 0.15;
      line-height: 4em;
      letter-spacing: 2px;
      color: blue;
      z-index:-1;
   }
	  
	 .placeholder.domicilio {
			white-space: break-spaces;
			text-align: left;
	 }
	  
	.sin_descuento td {
		color: transparent;
	}
	
	td:has(.notas) {
		text-align: left;
		vertical-align: top;
		padding-left: 1rem;
		padding-top: .5rem;
	}	
	
	img[xo-attribute="custom:foto"] {
		max-width: 95%;
	}
	  ]]>
		</style>
		<span class="watermarked" data-watermark="  CASA LUNA  "></span>
		<script>
			<![CDATA[
    Array.from(document.querySelectorAll('.watermarked')).forEach(function(el) {
        el.dataset.watermark = (el.dataset.watermark + ' ').repeat(700);
    });]]>
		</script>
	</xsl:template>

	<xsl:template match="@*">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*" mode="resources-path">
		<xsl:value-of select="$js:resources-path"/>
	</xsl:template>

	<xsl:template mode="headerText" match="@*">
		<xsl:value-of select="name()"/>	
	</xsl:template>

	<xsl:template mode="headerText" match="@Celular|@Telefono">
		<xsl:value-of select="substring(name(),1,3)"/>	
	</xsl:template>

	<xsl:template match="@Celular|@Telefono">
		<xsl:apply-templates mode="headerText" select="."/>:
		<xsl:value-of select="concat('(', substring(., 1, 3), ') ',
            substring(., 4, 3), '-',
            substring(., 7, 4))"/>
	</xsl:template>

	<xsl:template match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Telefono">
		<xsl:value-of select="concat('(', substring(., 1, 3), ') ',
            substring(., 4, 3), '-',
            substring(., 7, 4))"/>
	</xsl:template>

	<xsl:template match="@PrecioUnitario|@Descuento|@Monto">
		<xsl:value-of select="format-number(., '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="@Anticipos">
		<xsl:value-of select="format-number(sum(key('data','anticipo')), '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Monto">
		<xsl:value-of select="format-number(sum(key('data','articulos')), '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@MontoTotal">
		<xsl:variable name="monto_total" select="sum(key('data','articulos'))"/>
		<xsl:variable name="anticipos" select="sum(key('data','anticipo'))"/>
		<xsl:variable name="descuento" select="../@Descuento"/>
		<xsl:value-of select="format-number($monto_total - $descuento, '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@MontoRestante">
		<xsl:variable name="monto_total" select="sum(key('data','articulos'))"/>
		<xsl:variable name="anticipos" select="sum(key('data','anticipo'))"/>
		<xsl:variable name="descuento" select="../@Descuento"/>
		<xsl:value-of select="format-number($monto_total - $descuento - $anticipos, '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="@FechaMovimiento">
		<xsl:value-of select="substring(., 1, 10)"/>
	</xsl:template>

	<xsl:template match="@FechaMovimiento">
		<xsl:value-of select="substring(., 1, 10)"/> - <xsl:value-of select="format-number(../@Monto, '$###,##0.##', 'money')"/>
	</xsl:template>

	<xsl:template match="@meta:FK_VentaDetalle_Articulos">
		<xsl:apply-templates select="../@custom:foto"/>
		<xsl:value-of select="substring-before(., '-')"/>
	</xsl:template>

	<xsl:template match="@custom:foto[.!='']">
		<img src="{$js:resources-path}../{.}" style="min-height:2rem; max-height:100px" xo-attribute="custom:foto"/>
		 <br/>
	</xsl:template>

	<xsl:template match="@Color[.!='']">
		Color: <xsl:value-of select="."/>.<br/>
	</xsl:template>

	<xsl:template match="@Busto[.!='']|@Cadera[.!='']|@Cintura[.!='']|@Brazo[.!='']|@Talla[.!='']">
		<xsl:value-of select="substring(name(),1,1)"/>: <xsl:value-of select="."/>.
	</xsl:template>

	<xsl:template match="*[@Schema='Ventas' and @Name='VentaDetalle']/data:rows/xo:r/@Notas">
		<xsl:apply-templates select="../@Color"/>
		<xsl:apply-templates select="key('data','medidas')"/>
		<xsl:value-of select="."/>
		<xsl:value-of select="substring-before(substring-after(../@meta:FK_VentaDetalle_Articulos, '-'), '(')"/>
	</xsl:template>

	<xsl:template match="@meta:FK_MensajeReciboVenta_MensajeRecibo">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="/px:Entity/@xo:id">
		<xsl:value-of select="substring(translate($js:now,'T',' '),1,16)"/>
		<xsl:text> Hrs.</xsl:text>
	</xsl:template>

	<xsl:template mode="html.head" match="*">
		<!--<link rel="stylesheet" href="{$js:resources-path}../xover/css/fontawesome.all.css" />
    <link rel="stylesheet" href="{$js:resources-path}../xover/css/bootstrap.min.css" />-->
	</xsl:template>

</xsl:stylesheet>