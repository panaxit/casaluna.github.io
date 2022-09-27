<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:readonly="http://panax.io/state/readonly"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
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
  xmlns:form="http://panax.io/widgets/form"
  xmlns:container="http://panax.io/layout/container"
  exclude-result-prefixes="xo readonly container state xsl form CardView data height width data story temp px layout"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="values.xslt"/>
	<xsl:import href="cardview.xslt"/>
	<xsl:import href="datagrid.xslt"/>

	<xsl:key name="readonly" match="px:Record/px:Field[@mode='readonly']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="readonly" match="px:Record/px:Association[@mode='readonly']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="readonly" match="@readonly:*" use="concat(ancestor::px:Entity[1]/@xo:id,'::',local-name())"/>

	<xsl:key name="association" match="px:Association" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="radiogroup" match="dummy" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="combobox" match="dummy" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="dummy" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="combobox" match="px:Field[@controlType='combobox']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="combobox" match="px:Association[@Type='belongsTo']/px:Mappings/px:Mapping" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Referencer)"/>
	<xsl:key name="radiogroup" match="px:Field[@controlType='radiogroup']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="textarea" match="px:Field[starts-with(@xsi:type,'string:') and @DataLength&gt;255]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="textarea" match="px:Field[starts-with(@xsi:type,'string:') and @DataLength=-1]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="yesNo" match="px:Field[starts-with(@xsi:type,'bit:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="number" match="px:Field[starts-with(@xsi:type,'integer:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="datetime" match="px:Field[starts-with(@xsi:type,'datetime:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="date" match="px:Field[starts-with(@xsi:type,'date:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="year" match="px:Field[@controlType='year']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="formula" match="px:Record/px:Field[@formula]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="selected" match="*[@state:active]" use="''"/>
	<xsl:key name="selected" match="/*[not(//@state:active)]" use="''"/>
	<xsl:key name="verified" match="*[@verified='true']" use="@xo:id"/>
	<xsl:key name="verified" match="*[@verified='true']/item" use="@xo:id"/>
	<xsl:key name="file_type" match="attachment[contains(@metadata:value, 'application/')]" use="generate-id()"/>
	<xsl:key name="file_type" match="attachment[@type='file']" use="generate-id()"/>
	<xsl:key name="data_types" match="item[@type='data' or @type='field' or @type='indicator' or @type='formula' or @type='table' or @type='database' or @type='file' or @type='server']" use="@xo:id"/>
	<xsl:key name="data_types" match="data:rows" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='story']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='component']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='document']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='software']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='service']" use="@xo:id"/>
	<xsl:key name="user_types" match="item[@type='user']" use="@xo:id"/>
	<xsl:key name="other_types" match="item[@type='info']" use="@xo:id"/>
	<xsl:key name="ref" match="data:rows|item" use="concat(translate(@title, '_', ' '),'::',string(@type))"/>
	<xsl:key name="ref_items" match="data:rows" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_items" match="item" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_fields" match="item[@type='field'][item[@type='table']]" use="concat(translate(item[@type='table']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_fields" match="item[@type='table'][item[@type='database']]" use="concat(translate(item[@type='database']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_data" match="data:rows" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="distinct" match="data:rows" use="concat(../@title,'::',@title)"/>
	<!--<xsl:template match="/">
		<div class="container">
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css"/>
			<style>
				<![CDATA[
		.bi-filetype {
			font-size: 5rem; margin:10px auto;
		}
		
		.button {
			cursor: pointer;
		}
		
        .google-visualization-orgchart-node {
          width: 350;
        }
        .org_chart .google-visualization-orgchart-node .target {
          display: none;
        }
        .org_chart.moving .target {
          display: inline !important;
          cursor: pointer;
        }
        .org_chart:not(.moving) .google-visualization-orgchart-nodesel button.move.action {
          display: inline;
        }
        .org_chart.moving .bi-arrow-down-short {
          display: none;
        }
        
        button.action { display: none }
        button.cancel { display: none }
        .org_chart.moving button.cancel {
          display: inline;
        }

		.zoom {
		  transition: transform .2s; /* Animation */
		  max-height: 300px;
		}
		

		.zoomX1:hover {
			position: relative;
			-webkit-transform: scale(1.3);
			-ms-transform: scale(1.3);
			-o-transform: scale(1.3);
			transform: scale(1.3);
			z-index: 1000;
		}

		.zoomX2:hover {
			position: relative;
			-webkit-transform: scale(2.0);
			-ms-transform: scale(2.0);
			-o-transform: scale(2.0);
			transform: scale(2.0);
			z-index: 1000;
		}

		.zoomX3:hover {
			position: relative;
			-webkit-transform: scale(2.7);
			-ms-transform: scale(2.7);
			-o-transform: scale(2.7);
			transform: scale(2.7);
			z-index: 1000;
		}

		.zoomX4:hover {
			position: relative;
			-webkit-transform: scale(3.5);
			-ms-transform: scale(3.5);
			-o-transform: scale(3.5);
			transform: scale(3.5);
			z-index: 1000;
		}
		
		main li {
			border-bottom: 3px solid transparent;
			white-space: nowrap;
		}
		
		main li.over {
		  border-bottom: 3px dotted #666;
		}
		
		main li.tasks svg {
			margin-right:5px
		}
      ]]>
			</style>
			<xsl:choose>
				<xsl:when test="key('selected','')">
					<xsl:apply-templates select="key('selected','')[last()]"/>
				</xsl:when>
				<xsl:otherwise>
					<button onclick="xover.stores.active.$$('//@state:active').removeAll()">Reset</button>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>-->

	<xsl:key name="selected" match="data:rows/*[@state:selected]" use="@xo:id"/>
	<xsl:key name="selected" match="data:rows[not(*[2])]/*" use="@xo:id"/>

	<xsl:template mode="form:list" match="*|text()"/>

	<xsl:template mode="form:list" match="data:rows/*">
		<li class="list-group-item d-flex justify-content-between lh-sm" xo-scope="{@xo:id}">
			<div onclick="scope.parentNode.selectNodes('*/@state:selected').remove(); scope.set('state:selected',true)">
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

	<xsl:template mode="form:body" match="data:rows/*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="layout" select="dummy"/>
		<xsl:apply-templates mode="form:body" select="$layout">
			<xsl:with-param name="fields" select="$fields"/>
			<xsl:with-param name="row" select="current()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="form:body" match="layout:layout">
		<xsl:param name="row" select="../data:rows/*"/>
		<xsl:param name="fields" select="../px:Record/*"/>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<xsl:apply-templates mode="form:body">
					<xsl:with-param name="fields" select="$fields"/>
					<xsl:with-param name="row" select="$row"/>
				</xsl:apply-templates>
			</div>
		</form>
	</xsl:template>

	<xsl:template mode="control" match="px:Record/*">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="data" select="dummy"/>
		<span>
			<xsl:apply-templates mode="control" select="$data">
				<xsl:with-param name="field" select="."/>
				<xsl:with-param name="row" select="$row"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template mode="control" match="px:Record/px:Association[not(@Type='belongsTo')]">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="data" select="dummy"/>
		<!--layout: <xsl:value-of select="namespace-uri(px:Entity/*[local-name()='layout'])"/>!-->
		<span>
			<xsl:apply-templates select="px:Entity/*[local-name()='layout']">
				<xsl:with-param name="field" select="."/>
				<xsl:with-param name="row" select="$row"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template mode="headerText" match="*">
		<xsl:value-of select="@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]"/>
		<xsl:value-of select="$field/@headerText"/>
	</xsl:template>

	<xsl:template mode="headerText" match="layout:layout//container:*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Name=current()/@name]"/>
		<xsl:apply-templates mode="headerText" select="$field"/>
	</xsl:template>

	<xsl:template mode="control" match="layout:layout//*">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="field" select="$fields[@Id=current()/@id]|current()/self::container:*"/>
		<xsl:variable name="data" select="$row/@*[name()=current()/@name]"/>
		<span>
			<xsl:apply-templates mode="control" select="$field">
				<xsl:with-param name="row" select="$row"/>
				<xsl:with-param name="data" select="$data"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template mode="control" match="layout:layout//container:*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]"/>
		<div class="input-group">
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:apply-templates mode="control" select=".">
							<xsl:with-param name="fields" select="$fields"/>
							<xsl:with-param name="row" select="$row"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<div class="input-group-append">
							<xsl:apply-templates mode="control" select=".">
								<xsl:with-param name="fields" select="$fields"/>
								<xsl:with-param name="row" select="$row"/>
							</xsl:apply-templates>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="form:body" match="layout:layout/*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]|current()/self::container:*"/>
		<div class="mb-3 row">
			<label for="{@xo:id}" class="col-sm-2 col-form-label" ondblclick="this.toggle('contenteditable','')" xo-scope="{$field/@xo:id}" xo-attribute="headerText">
				<xsl:apply-templates mode="headerText" select="$field">
					<xsl:with-param name="fields" select="$fields"/>
				</xsl:apply-templates>
				<xsl:text>: </xsl:text>
			</label>
			<div class="col-sm-10">
				<xsl:apply-templates mode="control" select=".">
					<xsl:with-param name="row" select="$row"/>
					<xsl:with-param name="fields" select="$fields"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<input type="text" class="form-control" id="{$field/@id}" placeholder="" required="" xo-scope="{$current/../@xo:id}" xo-attribute="{name()}">
			<xsl:attribute name="maxLength">
				<xsl:value-of select="$field/@DataLength"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="key('number',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">number</xsl:when>
					<xsl:when test="key('year',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">number</xsl:when>
					<xsl:when test="key('datetime',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">datetime-local</xsl:when>
					<xsl:when test="key('date',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">date</xsl:when>
					<xsl:otherwise>text</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="key('year',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">
					<xsl:attribute name="minValue">1900</xsl:attribute>
					<xsl:attribute name="maxValue">2099</xsl:attribute>
					<xsl:attribute name="step">1</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!--<xsl:attribute name="pattern">
				<xsl:choose>
					<xsl:when test="key('money',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))">\${\d}{1,3}.00</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>-->
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</input>
		<!--<div class="invalid-feedback">
			Valid first name is required.
		</div>-->
	</xsl:template>

	<xsl:template mode="control" match="@*[key('textarea',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<textarea class="form-control" id="{$field/@id}" rows="3" placeholder="" required="" xo-scope="{$current/../@xo:id}" xo-attribute="{name()}">
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</textarea>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('yesNo',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<div class="btn-group" role="group" style="position:relative;">
			<button type="button" class="btn btn-outline-success" xo-scope="{../@xo:id}" xo-attribute="{name()}" onclick="scope.toggle('1')">
				<xsl:if test=".='1'">
					<xsl:attribute name="class">btn btn-success</xsl:attribute>
				</xsl:if>
				<xsl:text>Sí</xsl:text>
			</button>
			<button type="button" class="btn btn-outline-danger" xo-scope="{../@xo:id}" xo-attribute="{name()}" onclick="scope.toggle(0)">
				<xsl:if test=".='0'">
					<xsl:attribute name="class">btn btn-danger</xsl:attribute>
				</xsl:if>
				<xsl:text>No</xsl:text>
			</button>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('combobox',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="current" select="."/>
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="field" select="$fields[@Id=current()/@id]|current()/self::container:*"/>
		<xsl:param name="row" select="$current/.."/>
		<xsl:param name="data_set" select="$field/px:Entity/data:rows"/>
		<div class="input-group" xo-scope="{$row/@xo:id}" xo-attribute="{$field/@Referencer}">
			<select class="form-select" onchange="scope.parentNode.set('{$data_set/../../@Name}',this.value &amp;&amp; this[this.selectedIndex].text || '')">
				<!--<xsl:attribute name="onchange">
							<xsl:text/>scope.set('<xsl:value-of select="@Referencer"/>',this.value);<xsl:text/>-->
				<xsl:choose>
					<xsl:when test="not($data_set/xo:r)">
						<option value="">Sin opciones</option>
					</xsl:when>
					<xsl:otherwise>
						<option value="">
							Selecciona...
						</option>
						<xsl:for-each select="$data_set/xo:r">
							<xsl:sort select="@text"/>
							<xsl:variable name="option" select="."/>
							<xsl:variable name="value" select="@*[name()=$field/@Referencee]"/>
							<option value="{$value}">
								<xsl:variable name="selected">
									<xsl:if test="$current = $value">true</xsl:if>
								</xsl:variable>
								<xsl:if test="$selected = 'true'">
									<xsl:attribute name="selected"/>
								</xsl:if>
								<xsl:value-of select="@text"/>
							</option>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</select>
			<div class="input-group-append">
				<div class="input-group-append" style="color:black;" xo-scope="{$row/@xo:id}">
					<button type="button" class="btn btn-secondary btn-lg dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" tabindex="-1">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16">
							<path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
							<path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
						</svg>
					</button>
					<ul class="dropdown-menu">
						<li onclick="scope.$$('*').remove()" xo-scope="{$data_set/@xo:id}">
							<a class="dropdown-item" href="#">Actualizar</a>
						</li>
						<xsl:for-each select="$data_set/ancestor::px:Entity[1]">
							<xsl:variable name="identity" select="$row/@*[name()=ancestor::px:Entity[1]/@IdentityKey]"/>
							<xsl:variable name="reference">
								<xsl:choose>
									<xsl:when test="$identity">
										<xsl:value-of select="concat(':',$identity)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="ancestor::px:Entity[1]/px:PrimaryKeys/px:PrimaryKey/@Field_Name">
											<xsl:value-of select="concat('/',$row/@*[name()=current()])"/>
											<!--<xsl:value-of select="concat('/',current(),'/',$row/@*[name()=current()])"/>-->
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
					<!--<div class="w3-dropdown-content w3-bar-block w3-card-4 xover-popover" style="font-family: Verdana,sans-serif;     font-size: 9pt;">
						<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
							<span class="fas fa-sync-alt" style="color:blue;"></span>
							<span style="cursor:pointer;" xo-source="IdSupervisor_idp1621147060" onclick="var src = source.selectSingleNode('.//source:value'); if (!src) {{return}}; store.selectNodes('//source:value[@command=&quot;'+src.getAttribute('command')+'&quot;]'); xover.data.binding.requests[store.tag][`${{src.getAttribute('command')}}`]; src.remove();">
								Actualizar
							</span>
						</a>
						<a href="#" class="w3-bar-item w3-button" style="text-decoration:none">
							<span class="fas fa-plus-circle" style="color:green;"></span>
							<span style="cursor:pointer;" onclick="px.request('[Corporativo].[Colaborador]','add');">Crear Nuevo</span>
						</a>
					</div>-->
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('radiogroup',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="data_set" select="$field/px:Entity/data:rows"/>

		<xsl:for-each select="$data_set/xo:r">
			<xsl:variable name="option" select="."/>
			<xsl:variable name="checked">
				<xsl:if test="$current = @value">checked</xsl:if>
			</xsl:variable>
			<div class="form-check form-check-inline" xo-scope="{$current/../@xo:id}">
				<input class="form-check-input" type="radio" value="{@value}" id="{../@xo:id}_{position()}" xo-attribute="{name($current)}">
					<xsl:for-each select="$field/px:Mappings/px:Mapping">
						<xsl:attribute name="onclick">
							<xsl:text/>scope.parentNode.set('<xsl:value-of select="@Referencer"/>','<xsl:value-of select="$option/@*[name()=current()/@Referencee]"/>');<xsl:text/>
						</xsl:attribute>
					</xsl:for-each>
					<xsl:if test="$current = @value">
						<xsl:attribute name="checked"/>
					</xsl:if>
				</input>
				<label class="form-check-label" for="{../@xo:id}_{position()}">
					<xsl:value-of select="@text"/>
				</label>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('association',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<div class="input-group" xo-scope="{$field/@xo:id}">
			<xsl:for-each select="$field/px:Mappings/px:Mapping">
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:apply-templates mode="control" select="$row/@*[name()=current()/@Referencer]">
							<xsl:with-param name="data_set" select="$field/px:Entity/data:rows"/>
							<xsl:with-param name="field" select="current()"/>
							<xsl:with-param name="row" select="$row"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<div class="input-group-append">
							<xsl:apply-templates mode="control" select="$row/@*[name()=current()/@Referencer]">
								<xsl:with-param name="data_set" select="$field/px:Entity/data:rows"/>
								<xsl:with-param name="field" select="current()"/>
								<xsl:with-param name="row" select="$row"/>
							</xsl:apply-templates>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('readonly',concat(ancestor::px:Entity[1]/@xo:id,'::',name()))]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<label for="{../@xo:id}" class="form-input">
			<xsl:apply-templates select="."/>
		</label>
	</xsl:template>

</xsl:stylesheet>