<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:layout="http://panax.io/layout/view/form"
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
  xmlns:form="http://panax.io/widgets/form"
  exclude-result-prefixes="xo state xsl form CardView data height width data story temp"
>
	<xsl:import href="keys.xslt"/>
	<xsl:import href="datagrid.xslt"/>
	<xsl:import href="templates/form.xslt"/>
	<xsl:template match="/">
		<div class="container-fluid">
			<xsl:variable name="entity" select="px:Entity"/>
			<xsl:for-each select="$entity/data:rows/xo:r">
				<xsl:apply-templates select="$entity/layout:layout">
					<xsl:with-param name="row" select="."/>
				</xsl:apply-templates>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="px:Entity[@control:type='form:control']/layout:layout">
		<xsl:param name="current" select="."/>
		<xsl:param name="row" select="../data:rows/*"/>
		<xsl:param name="fields" select="../px:Record/*"/>
		<xsl:for-each select="$row">
			<div class="row g-5" style="margin-top:0px;">
				<div class="col-md-9 col-lg-11">
					<xsl:apply-templates mode="form:body" select="$current">
						<xsl:with-param name="fields" select="$fields"/>
						<xsl:with-param name="row" select="$row"/>
					</xsl:apply-templates>
				</div>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template mode="control" match="key('entity','Egresos.Compras.PrecioUnitario')" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="data" select="dummy"/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>

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

	<!--<xsl:template mode="control" match="key('data_field','Egresos.Gastos.Saldo')" priority="5">
		<xsl:param name="current" select="."/>
		<xsl:param name="field" select="dummy"/>
		<xsl:param name="row" select="dummy"/>

		<xsl:variable name="Total">
			<xsl:choose>
				<xsl:when test="number(../@Total)=../@Total">
					<xsl:value-of select="number(../@Total)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="TotalPagado">
			<xsl:choose>
				<xsl:when test="number(../@TotalPagado)=../@TotalPagado">
					<xsl:value-of select="number(../@TotalPagado)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="amount" select="$Total - $TotalPagado"/>
		<xsl:variable name="class">
			<xsl:if test="$amount&lt;0">text-danger</xsl:if>
		</xsl:variable>
		<label for="{@xo:id}" class="form-input {$class}">
			<xsl:call-template name="format">
				<xsl:with-param name="value" select="$amount"/>
			</xsl:call-template>
		</label>
	</xsl:template>-->

	<xsl:template mode="control" match="key('entity','Inventarios.Articulos')/data:rows/*/@PrecioVenta">
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



	<!--<xsl:template mode="form:body" match="key('entity','Ingresos.Venta')/layout:layout">
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

	<!--<xsl:template mode="form:body" match="key('entity','Ingresos.Venta')/layout:layout">
		<xsl:param name="row" select="dummy"/>
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="articulos" select="../px:Record/px:Association[@AssociationName='FK_OrdenDetalle_Orden']/px:Entity/data:rows/*"/>
		<div class="row g-5">
			<div class="col-md-5 col-lg-4 order-md-last">
				<h4 class="d-flex justify-content-between align-items-center mb-3">
					<span class="text-primary">
						Artículos:
					</span>
					<span class="badge bg-primary rounded-pill">
						<xsl:value-of select="count($articulos)"/>
					</span>
				</h4>
				<ul class="list-group mb-3">
					<xsl:for-each select="$articulos">
						<li class="list-group-item d-flex justify-content-between lh-sm">
							<div>
								<h6 class="my-0">
									<xsl:value-of select="@FK_OrdenDetalle_Articulos"/>
								</h6>
								-->
	<!--<small class="text-muted">
									<xsl:value-of select="@FK_OrdenDetalle_Articulos"/>
								</small>-->
	<!--
							</div>
							<span class="text-muted">
								<xsl:apply-templates select="@CostoTotal"/>
							</span>
						</li>
					</xsl:for-each>
				</ul>

				<form class="card p-2">
					<div class="input-group">
						<button type="submit" class="btn btn-secondary">
							<a href="#Ingresos/VentaDetalle~add">Agregar nuevo articulo</a>
						</button>
					</div>
				</form>
			</div>
			<div class="col-md-7 col-lg-8">
				<form class="needs-validation" novalidate="">
					<div class="row g-3">
						<xsl:apply-templates mode="form:body">
							<xsl:with-param name="fields" select="$fields"/>
							<xsl:with-param name="row" select="$row"/>
						</xsl:apply-templates>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>-->
</xsl:stylesheet>