<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:js="http://panax.io/xover/javascript"
  xmlns:state="http://panax.io/state"
  xmlns:meta="http://panax.io/metadata"
  xmlns:data="http://panax.io/source"
  xmlns:source="http://panax.io/source"
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

	<xsl:key name="data" match="@xsl:domicilio" use="'domicilio'"/>
	<xsl:key name="data" match="@xsl:colonia" use="'colonia'"/>
	<xsl:key name="data" match="@xsl:cel" use="'cel'"/>
	<xsl:key name="data" match="@Folio" use="'Folio'"/>
	<xsl:key name="data" match="@Cliente" use="'Cliente'"/>
	<xsl:key name="data" match="/px:Entity/@xo:id" use="'FechaImpresion'"/>
	<xsl:key name="data" match="@FechaCita" use="'FechaPrueba'"/>
	<xsl:key name="data" match="@Domicilio" use="'DomicilioCliente'"/>
	<xsl:key name="data" match="@FechaFoto" use="'FechaFoto'"/>
	<xsl:key name="data" match="@FechaEvento" use="'FechaEvento'"/>
	<xsl:key name="data" match="@Telefono" use="'Telefono'"/>
	<xsl:key name="data" match="@meta:FK_VentaDetalle_Articulos" use="'codigo'"/>
	<xsl:key name="data" match="@IdArticuloInventario" use="'descripcion'"/>
	<xsl:key name="data" match="@PrecioTotal" use="'monto'"/>
	<xsl:key name="data" match="@xsl:descuento" use="'descuento'"/>
	<xsl:key name="data" match="@PrecioTotal" use="'subtotal'"/>
	<xsl:key name="data" match="*[@Schema='Ventas' and @Name='Venta']/data:rows/xo:r/@Monto" use="'suma_subtotal'"/>
	<xsl:key name="data" match="@Descuento" use="'descuento_extra'"/>
	<xsl:key name="data" match="@meta:FK_MensajeReciboVenta_MensajeRecibo" use="'mensaje'"/>
	<xsl:key name="data" match="@MontoTotal" use="'total'"/>
	<xsl:key name="data" match="@Anticipos" use="'anticipos'"/>
	<xsl:key name="data" match="*[@Schema='Ingresos' and @Name='Cobros']/data:rows/xo:r/@Monto" use="'anticipo'"/>
	<xsl:key name="data" match="*[@Schema='Ingresos' and @Name='Cobros']/data:rows/xo:r/@FechaMovimiento" use="'fecha_anticipo'"/>
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
      }]]>
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

	<xsl:template match="@MontoTotal|@PrecioTotal|@Descuento|@Monto|@Anticipos|@MontoRestante">
		<xsl:value-of select="format-number(., '$###,##0.00', 'money')"/>
	</xsl:template>

	<xsl:template match="@FechaCaptura|@FechaMovimiento">
		<xsl:value-of select="substring(., 1, 10)"/>
	</xsl:template>

	<xsl:template match="@meta:FK_VentaDetalle_Articulos">
		<xsl:value-of select="substring-before(., '-')"/>
	</xsl:template>

	<xsl:template match="@IdArticuloInventario">
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