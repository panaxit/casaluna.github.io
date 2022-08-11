<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:px="http://panax.io/entity"
xmlns:xo="http://panax.io/xover"
xmlns:state="http://panax.io/state"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:initial="http://panax.io/xover/state/initial"
xmlns:data="http://panax.io/source"
exclude-result-prefixes="#default xsl px xo xsi"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:key name="changed" match="@initial:*" use="concat(../@xo:id,'::',local-name())"/>

	<xsl:template match="/">
		<ul id="shell_buttons" class="nav col-md-4 justify-content-end list-unstyled d-flex">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<!--<xsl:template match="*">
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-info">Button</button>
			</a>
		</li>
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-secondary">Cancelar</button>
			</a>
		</li>
		<li class="ms-3">
			<a class="text-muted" href="#">
				<button class="btn btn-success">Continuar</button>
			</a>
		</li>
	</xsl:template>-->

	<xsl:template match="px:Entity[@xsi:type='form:control']">
		<xsl:if test="data:rows/*/@*[not(namespace-uri()='http://panax.io/xover/state/initial')][key('changed',concat(../@xo:id,'::',local-name()))]">
			<li class="ms-3" xo-scope="{@xo:id}">
				<a class="text-muted" href="#" onclick="submit(scope.$$('data:rows/*'))">
					<button class="btn btn-success">Guardar</button>
				</a>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="px:Entity[@xsi:type='datagrid:control']">
		<xsl:variable name="deleting_rows" select="data:rows/*[@state:delete]"/>
		<xsl:choose>
			<xsl:when test="$deleting_rows">
				<li class="ms-3" xo-scope="{@xo:id}">
					<a class="text-muted" href="#" onclick="submit(scope.$$('data:rows/*[@state:delete]'))">
						<button class="btn btn-danger">Eliminar </button>
					</a>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li class="ms-3">
					<a class="text-muted" href="#{@Schema}/{@Name}~add">
						<button class="btn btn-success">Nuevo registro</button>
					</a>
				</li>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
</xsl:stylesheet>
