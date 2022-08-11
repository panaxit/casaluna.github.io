<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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
  exclude-result-prefixes="xo state xsl CardView data height width data story temp px layout"
>
	<xsl:import href="values.xslt"/>
	<xsl:import href="cardview.xslt"/>

	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'.',@Name)"/>

	<xsl:key name="combobox" match="px:Association[px:Entity/@xsi:type='combobox:control']" use="@Name"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="@Name"/>

	<xsl:key name="readonly" match="px:Record/px:Field[@mode='readonly']" use="@Name"/>
	<xsl:key name="formula" match="px:Record/px:Field[@formula]" use="@Name"/>

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
	<xsl:template match="/">
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
	</xsl:template>

	<xsl:template match="px:Entity">
		<xsl:variable name="rows" select="data:rows/*"/>
		<div class="row g-5">
			<!--<div class="col-md-5 col-lg-4 order-md-last">
				<h4 class="d-flex justify-content-between align-items-center mb-3">
					<span class="text-primary">Catálogo</span>
					<span class="badge bg-primary rounded-pill">
						<xsl:value-of select="count($rows)"/>
					</span>
				</h4>
				<ul class="list-group mb-3">
					<xsl:apply-templates mode="form.list" select="$rows"/>
				</ul>
				<form class="card p-2">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Promo code"/>
						<button type="submit" class="btn btn-secondary">Redeem</button>
					</div>
				</form>
			</div>-->
			<div class="col-md-9 col-lg-11">
				<xsl:apply-templates mode="form.body" select="$rows">
					<xsl:with-param name="fields" select="px:Record"/>
					<xsl:with-param name="layout" select="layout:layout"/>
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:key name="selected" match="data:rows/*[@state:selected]" use="@xo:id"/>
	<xsl:key name="selected" match="data:rows[not(*[2])]/*" use="@xo:id"/>

	<xsl:template mode="form.list" match="*|text()"/>

	<xsl:template mode="form.list" match="data:rows/*">
		<li class="list-group-item d-flex justify-content-between lh-sm" xo-scope="{@xo:id}">
			<div onclick="scope.parentNode.selectNodes('*/@state:selected').remove(); scope.set('state:selected',true)">
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

	<xsl:template mode="form.body" match="data:rows/*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="layout" select="dummy"/>
		<xsl:apply-templates mode="form.body" select="$layout">
			<xsl:with-param name="fields" select="$fields"/>
			<xsl:with-param name="row" select="current()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="form.body" match="layout:layout">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="fields" select="dummy"/>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<xsl:apply-templates mode="form.body">
					<xsl:with-param name="fields" select="$fields"/>
					<xsl:with-param name="row" select="$row"/>
				</xsl:apply-templates>
			</div>
		</form>
	</xsl:template>

	<xsl:template mode="form.body" match="layout:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<xsl:variable name="field" select="$fields/*[@Id=current()/@id]"/>
		<xsl:variable name="data" select="$row/@*[name()=current()/@name]"/>
		<div class="col-sm-12">
			<label for="{@xo:id}" class="form-label">
				<xsl:value-of select="$field/@headerText"/>
				<xsl:text>: </xsl:text>
			</label>
			<xsl:apply-templates mode="control" select="$data">
				<xsl:with-param name="field" select="$field"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<!--<xsl:template mode="form.body" match="key('entity','Ingresos.Venta')/layout:layout">
		<div class="row g-5">
			<div class="col-md-5 col-lg-4 order-md-last">
				<h4 class="d-flex justify-content-between align-items-center mb-3">
					<span class="text-primary">Your cart</span>
					<span class="badge bg-primary rounded-pill">3</span>
				</h4>
				<ul class="list-group mb-3">
					<li class="list-group-item d-flex justify-content-between lh-sm">
						<div>
							<h6 class="my-0">Product name</h6>
							<small class="text-muted">Brief description</small>
						</div>
						<span class="text-muted">$12</span>
					</li>
					<li class="list-group-item d-flex justify-content-between lh-sm">
						<div>
							<h6 class="my-0">Second product</h6>
							<small class="text-muted">Brief description</small>
						</div>
						<span class="text-muted">$8</span>
					</li>
					<li class="list-group-item d-flex justify-content-between lh-sm">
						<div>
							<h6 class="my-0">Third item</h6>
							<small class="text-muted">Brief description</small>
						</div>
						<span class="text-muted">$5</span>
					</li>
					<li class="list-group-item d-flex justify-content-between bg-light">
						<div class="text-success">
							<h6 class="my-0">Promo code</h6>
							<small>EXAMPLECODE</small>
						</div>
						<span class="text-success">−$5</span>
					</li>
					<li class="list-group-item d-flex justify-content-between">
						<span>Total (USD)</span>
						<strong>$20</strong>
					</li>
				</ul>

				<form class="card p-2">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Promo code"/>
						<button type="submit" class="btn btn-secondary">Redeem</button>
					</div>
				</form>
			</div>
			<div class="col-md-7 col-lg-8">
				<h4 class="mb-3">Billing address</h4>
				<form class="needs-validation" novalidate="">
					<div class="row g-3">
						<div class="col-sm-6">
							<label for="firstName" class="form-label">First name</label>
							<input type="text" class="form-control" id="firstName" placeholder="" value="" required=""/>
							<div class="invalid-feedback">
								Valid first name is required.
							</div>
						</div>

						<div class="col-sm-6">
							<label for="lastName" class="form-label">Last name</label>
							<input type="text" class="form-control" id="lastName" placeholder="" value="" required=""/>
							<div class="invalid-feedback">
								Valid last name is required.
							</div>
						</div>

						<div class="col-12">
							<label for="username" class="form-label">Username</label>
							<div class="input-group has-validation">
								<span class="input-group-text">@</span>
								<input type="text" class="form-control" id="username" placeholder="Username" required=""/>
								<div class="invalid-feedback">
									Your username is required.
								</div>
							</div>
						</div>

						<div class="col-12">
							<label for="email" class="form-label">
								Email <span class="text-muted">(Optional)</span>
							</label>
							<input type="email" class="form-control" id="email" placeholder="you@example.com"/>
							<div class="invalid-feedback">
								Please enter a valid email address for shipping updates.
							</div>
						</div>

						<div class="col-12">
							<label for="address" class="form-label">Address</label>
							<input type="text" class="form-control" id="address" placeholder="1234 Main St" required=""/>
							<div class="invalid-feedback">
								Please enter your shipping address.
							</div>
						</div>

						<div class="col-12">
							<label for="address2" class="form-label">
								Address 2 <span class="text-muted">(Optional)</span>
							</label>
							<input type="text" class="form-control" id="address2" placeholder="Apartment or suite"/>
						</div>

						<div class="col-md-5">
							<label for="country" class="form-label">Country</label>
							<select class="form-select" id="country" required="">
								<option value="">Choose...</option>
								<option>United States</option>
							</select>
							<div class="invalid-feedback">
								Please select a valid country.
							</div>
						</div>

						<div class="col-md-4">
							<label for="state" class="form-label">State</label>
							<select class="form-select" id="state" required="">
								<option value="">Choose...</option>
								<option>California</option>
							</select>
							<div class="invalid-feedback">
								Please provide a valid state.
							</div>
						</div>

						<div class="col-md-3">
							<label for="zip" class="form-label">Zip</label>
							<input type="text" class="form-control" id="zip" placeholder="" required=""/>
							<div class="invalid-feedback">
								Zip code required.
							</div>
						</div>
					</div>

					<hr class="my-4"/>

					<div class="form-check">
						<input type="checkbox" class="form-check-input" id="same-address"/>
						<label class="form-check-label" for="same-address">Shipping address is the same as my billing address</label>
					</div>

					<div class="form-check">
						<input type="checkbox" class="form-check-input" id="save-info"/>
						<label class="form-check-label" for="save-info">Save this information for next time</label>
					</div>

					<hr class="my-4"/>

					<h4 class="mb-3">Payment</h4>

					<div class="my-3">
						<div class="form-check">
							<input id="credit" name="paymentMethod" type="radio" class="form-check-input" checked="" required=""/>
							<label class="form-check-label" for="credit">Credit card</label>
						</div>
						<div class="form-check">
							<input id="debit" name="paymentMethod" type="radio" class="form-check-input" required=""/>
							<label class="form-check-label" for="debit">Debit card</label>
						</div>
						<div class="form-check">
							<input id="paypal" name="paymentMethod" type="radio" class="form-check-input" required=""/>
							<label class="form-check-label" for="paypal">PayPal</label>
						</div>
					</div>

					<div class="row gy-3">
						<div class="col-md-6">
							<label for="cc-name" class="form-label">Name on card</label>
							<input type="text" class="form-control" id="cc-name" placeholder="" required=""/>
							<small class="text-muted">Full name as displayed on card</small>
							<div class="invalid-feedback">
								Name on card is required
							</div>
						</div>

						<div class="col-md-6">
							<label for="cc-number" class="form-label">Credit card number</label>
							<input type="text" class="form-control" id="cc-number" placeholder="" required=""/>
							<div class="invalid-feedback">
								Credit card number is required
							</div>
						</div>

						<div class="col-md-3">
							<label for="cc-expiration" class="form-label">Expiration</label>
							<input type="text" class="form-control" id="cc-expiration" placeholder="" required=""/>
							<div class="invalid-feedback">
								Expiration date required
							</div>
						</div>

						<div class="col-md-3">
							<label for="cc-cvv" class="form-label">CVV</label>
							<input type="text" class="form-control" id="cc-cvv" placeholder="" required=""/>
							<div class="invalid-feedback">
								Security code required
							</div>
						</div>
					</div>

					<hr class="my-4"/>

					<button class="w-100 btn btn-primary btn-lg" type="submit">Continue to checkout</button>
				</form>
			</div>
		</div>
	</xsl:template>-->

	<xsl:template mode="form.body" match="key('entity','Ingresos.Venta')/layout:layout">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="articulos" select="../px:Record/px:Association[@AssociationName='FK_OrdenDetalle_Orden']/px:Entity/data:rows/*"/>
		<div class="row g-5">
			<div class="col-md-5 col-lg-4 order-md-last">
				<h4 class="d-flex justify-content-between align-items-center mb-3">
					<span class="text-primary">Artículos:
				</span>
					<span class="badge bg-primary rounded-pill">
						<xsl:value-of select="count($articulos)"/>
					</span>
				</h4>
				<ul class="list-group mb-3">
					<xsl:for-each select="$articulos">
						<li class="list-group-item d-flex justify-content-between lh-sm">
							<div>
								<h6 class="my-0"><xsl:value-of select="@FK_OrdenDetalle_Articulos"/></h6>
								<!--<small class="text-muted">
									<xsl:value-of select="@FK_OrdenDetalle_Articulos"/>
								</small>-->
							</div>
							<span class="text-muted"><xsl:apply-templates select="@CostoTotal"/></span>
						</li>
					</xsl:for-each>
				</ul>

				<form class="card p-2">
					<div class="input-group">
						<button type="submit" class="btn btn-secondary"><a href="#Ingresos/VentaDetalle~add">Agregar nuevo articulo</a></button>
					</div>
				</form>
			</div>
			<div class="col-md-7 col-lg-8">
				<form class="needs-validation" novalidate="">
					<div class="row g-3">
						<xsl:apply-templates mode="form.body">
							<xsl:with-param name="fields" select="$fields"/>
							<xsl:with-param name="row" select="$row"/>
						</xsl:apply-templates>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:key name="radiogroup" match="dummy" use="@Name"/>
	<xsl:key name="combobox" match="dummy" use="@Name"/>
	<xsl:key name="money" match="dummy" use="@Name"/>

	<xsl:template mode="control" match="@*">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<input type="text" class="form-control" id="{$field/@id}" placeholder="" required="" xo-scope="{$current/../@xo:id}" xo-attribute="{name()}">
			<xsl:attribute name="value">
				<xsl:apply-templates select="."/>
			</xsl:attribute>
		</input>
		<!--<div class="invalid-feedback">
			Valid first name is required.
		</div>-->
	</xsl:template>

	<xsl:template mode="control" match="@*[key('radiogroup',name())]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<div class="input-group mb-3">
			<xsl:for-each select="$field/px:Entity/data:rows/*">
				<xsl:variable name="option" select="."/>
				<xsl:variable name="checked">
					<xsl:if test="$current = @value">checked</xsl:if>
				</xsl:variable>
				<div class="form-check form-check-inline" xo-scope="{$current/../@xo:id}">
					<input class="form-check-input" type="radio" value="{@value}" id="{$field/@xo:id}_{position()}" xo-attribute="{name($current)}">
						<xsl:for-each select="$field/px:Mappings/px:Mapping">
							<xsl:attribute name="onclick">
								<xsl:text/>scope.parentNode.set('<xsl:value-of select="@Referencer"/>','<xsl:value-of select="$option/@*[name()=current()/@Referencee]"/>');<xsl:text/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:if test="$current = @value">
							<xsl:attribute name="checked"/>
						</xsl:if>
					</input>
					<label class="form-check-label" for="{name($current)}_{$field/@xo:id}_{position()}">
						<xsl:value-of select="@text"/>
					</label>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('combobox',name())]">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="$current/.."/>
		<xsl:param name="catalog" select="$field/px:Entity/data:rows/*"/>
		<div class="input-group mb-3">
			<select class="form-select" xo-scope="{$row/@xo:id}">
				<xsl:for-each select="$field/px:Mappings/px:Mapping">
					<xsl:attribute name="onchange">
						<xsl:text/>scope.set('<xsl:value-of select="@Referencer"/>',this.value);<xsl:text/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:variable name="current_value">
					<xsl:for-each select="$field/px:Mappings/px:Mapping">
						<xsl:if test="position()&gt;1">||</xsl:if>
						<xsl:value-of select="$row/@*[name()=current()/@Referencer]"/>
					</xsl:for-each>
				</xsl:variable>
				<option>
					Selecciona una opción...<xsl:value-of select="$current_value"/>
				</option>
				<xsl:for-each select="$catalog">
					<xsl:sort select="@text"/>
					<xsl:variable name="option" select="."/>
					<xsl:variable name="selected">
						<xsl:if test="$current_value = @value">true</xsl:if>
					</xsl:variable>
					<option value="{@value}">
						<xsl:if test="$selected = 'true'">
							<xsl:attribute name="selected"/>
						</xsl:if>
						<xsl:value-of select="@text"/>
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('readonly',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<label for="{@xo:id}" class="form-input">
			<xsl:apply-templates select="."/>
		</label>
	</xsl:template>

	<xsl:template mode="control" match="@*[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
		<label for="{@xo:id}" class="form-input">
			<script xo-scope="{../@xo:id}">
				'<xsl:value-of select="$field/@formula"/>'.replace(/\[([^\]]+)\]/g,'replace($1)')
			</script>
		</label>
	</xsl:template>

	<xsl:template mode="control" match="@MontoTotal[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
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

		<label for="{@xo:id}" class="form-input">
			<xsl:value-of select="format-number($monto - $descuento,'$#,##0.00')"/>
		</label>
	</xsl:template>

	<xsl:template mode="control" match="@MontoRestante[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>
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
		<label for="{@xo:id}" class="form-input {$class}">
			<xsl:value-of select="format-number($amount,'$#,##0.00')"/>
		</label>
	</xsl:template>

	<xsl:template mode="control" match="@CantidadDisponible[key('formula',name())]" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>

		<xsl:variable name="CantidadComprada">
			<xsl:choose>
				<xsl:when test="number(../@CantidadComprada)=../@CantidadComprada">
					<xsl:value-of select="number(../@CantidadComprada)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="CantidadVendida">
			<xsl:choose>
				<xsl:when test="number(../@CantidadVendida)=../@CantidadVendida">
					<xsl:value-of select="number(../@CantidadVendida)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="CantidadMermada">
			<xsl:choose>
				<xsl:when test="number(../@CantidadMermada)=../@CantidadMermada">
					<xsl:value-of select="number(../@CantidadMermada)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="CantidadApartados">
			<xsl:choose>
				<xsl:when test="number(../@CantidadApartados)=../@CantidadApartados">
					<xsl:value-of select="number(../@CantidadApartados)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="amount" select="$CantidadComprada - $CantidadVendida - $CantidadMermada - $CantidadApartados"/>
		<xsl:variable name="class">
			<xsl:if test="$amount&lt;0">text-danger</xsl:if>
		</xsl:variable>
		<label for="{@xo:id}" class="form-input {$class}">
			<xsl:value-of select="format-number($amount,'#,##0.00')"/>
		</label>
	</xsl:template>

	<xsl:template mode="control" match="key('entity','Inventarios.Articulos')/data:rows/*/@PrecioVenta" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>

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