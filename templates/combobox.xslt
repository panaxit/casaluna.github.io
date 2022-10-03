<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:combobox="http://panax.io/widgets/combobox"
  xmlns:px="http://panax.io/entity"
  exclude-result-prefixes="xo xsl combobox data px"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="values.xslt"/>
	<xsl:import href="headers.xslt"/>

	<xsl:key name="combobox:widget" match="dummy" use="@xo:id"/>

	<xsl:template match="/">
		<div class="container-fluid" style="margin-top:0px;">
			<xsl:variable name="entity" select="px:Entity"/>
			<xsl:apply-templates mode="widget" select="$entity/@xo:id"/>
		</div>
	</xsl:template>

	<xsl:template mode="widget" match="@*[key('combobox:widget',concat(ancestor::px:Entity[1]/@xo:id,'.',name()))]">
		<xsl:param name="dataset" select="key('dataset',concat(ancestor::px:Entity[1]/@xo:id,'.',name()))"/>
		<xsl:param name="selection" select="."/>
		<xsl:param name="target" select="."/>
		<xsl:variable name="current" select="."/>
		<div class="input-group" xo-scope="{$target/@xo:id|$target[not(self::*)]/../@xo:id}" xo-attribute="{name($target)}">
			<xsl:attribute name="xo-attribute">
				<xsl:for-each select="$dataset/ancestor::px:Association[1]/px:Mappings/px:Mapping/@Referencer">
					<xsl:if test="position()&gt;1">/</xsl:if>
					<xsl:value-of select="current()"/>
				</xsl:for-each>
			</xsl:attribute>
			<select class="form-select" onchange="scope.parentNode.set('{name($target)}',this.value &amp;&amp; this[this.selectedIndex].text || '')">
				<xsl:choose>
					<xsl:when test="not($dataset|$selection[not($dataset)])">
						<option value="">Sin opciones</option>
					</xsl:when>
					<xsl:otherwise>
						<option value="">
							Selecciona...
						</option>
						<xsl:for-each select="$dataset|$selection[not($dataset)]">
							<xsl:sort select="@meta:text"/>
							<xsl:variable name="option" select="."/>
							<xsl:variable name="value" select="@meta:id|@meta:value"/>
							<option value="{$value}">
								<xsl:variable name="selected">
									<xsl:choose>
										<xsl:when test="@xo:id = $selection/@xo:id">true</xsl:when>
										<xsl:when test="@meta:text = $selection[namespace-uri()='http://panax.io/metadata']">true</xsl:when>
										<xsl:when test="@meta:value = $selection">true</xsl:when>
										<xsl:when test="not($dataset)">true</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="$selected = 'true'">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="@meta:text|current()[not(self::*)]"/>
							</option>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</select>
			<div class="input-group-append">
				<div class="input-group-append" style="color:black;" xo-scope="{$dataset/../@xo:id}">
					<button type="button" class="btn btn-secondary btn-lg dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" tabindex="-1">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16">
							<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
							<path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
						</svg>
					</button>
					<ul class="dropdown-menu">
						<li onclick="scope.$$('*').remove()" xo-scope="{$dataset/../@xo:id}">
							<a class="dropdown-item" href="#">Actualizar</a>
						</li>
						<xsl:for-each select="$dataset/ancestor::px:Entity[1]">
							<xsl:variable name="identity" select="$dataset/@*[name()=ancestor::px:Entity[1]/@IdentityKey]"/>
							<xsl:variable name="reference">
								<xsl:choose>
									<xsl:when test="$identity">
										<xsl:value-of select="concat(':',$identity)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="ancestor::px:Entity[1]/px:PrimaryKeys/px:PrimaryKey/@Field_Name">
											<xsl:value-of select="concat('/',$dataset/@*[name()=current()])"/>
											<!--<xsl:value-of select="concat('/',current(),'/',$dataset/@*[name()=current()])"/>-->
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<li>
								<a class="dropdown-item" href="#{@Schema}/{@Name}~add">Crear Nuevo</a>
							</li>
							<xsl:if test="string($reference)!=''">
								<li>
									<a class="dropdown-item" href="#{@Schema}/{@Name}~edit{$reference}">Editar registro</a>
								</li>
								<li>
									<a class="dropdown-item" href="#{@Schema}/{@Name}~remove{$reference}">Eliminar registro</a>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>