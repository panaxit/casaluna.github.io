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
  exclude-result-prefixes="xo state xsl CardView data height width data story temp px"
>
	<xsl:import href="cardview.xslt"/>
	<xsl:key name="selected" match="*[@state:active]" use="''"/>
	<xsl:key name="selected" match="/*[not(//@state:active)]" use="''"/>
	<xsl:key name="verified" match="*[@verified='true']" use="@xo:id"/>
	<xsl:key name="verified" match="*[@verified='true']/item" use="@xo:id"/>
	<xsl:key name="file_type" match="attachment[contains(@metadata:value, 'application/')]" use="generate-id()"/>
	<xsl:key name="file_type" match="attachment[@type='file']" use="generate-id()"/>
	<xsl:key name="data_types" match="item[@type='data' or @type='field' or @type='indicator' or @type='formula' or @type='table' or @type='database' or @type='file' or @type='server']" use="@xo:id"/>
	<xsl:key name="data_types" match="data:item" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='story']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='component']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='document']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='software']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='service']" use="@xo:id"/>
	<xsl:key name="user_types" match="item[@type='user']" use="@xo:id"/>
	<xsl:key name="other_types" match="item[@type='info']" use="@xo:id"/>
	<xsl:key name="ref" match="data:item|item" use="concat(translate(@title, '_', ' '),'::',string(@type))"/>
	<xsl:key name="ref_items" match="data:item" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_items" match="item" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_fields" match="item[@type='field'][item[@type='table']]" use="concat(translate(item[@type='table']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_fields" match="item[@type='table'][item[@type='database']]" use="concat(translate(item[@type='database']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_data" match="data:item" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="distinct" match="data:item" use="concat(../@title,'::',@title)"/>
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
		<xsl:variable name="catalogo" select=".//data:item/*"/>
		<div class="row g-5">
			<div class="col-md-5 col-lg-4 order-md-last">
				<h4 class="d-flex justify-content-between align-items-center mb-3">
					<span class="text-primary">Catálogo</span>
					<span class="badge bg-primary rounded-pill">
						<xsl:value-of select="count($catalogo)"/>
					</span>
				</h4>
				<ul class="list-group mb-3">
					<xsl:apply-templates mode="form.list" select="$catalogo"/>
				</ul>
				<form class="card p-2">
					<div class="input-group">
						<input type="text" class="form-control" placeholder="Promo code"/>
						<button type="submit" class="btn btn-secondary">Redeem</button>
					</div>
				</form>
			</div>
			<div class="col-md-7 col-lg-8">
				<xsl:apply-templates mode="form.item" select="$catalogo"/>
			</div>
		</div>
	</xsl:template>

	<xsl:key name="selected" match="*[@state:selected]" use="@xo:id"/>

	<xsl:template mode="form.list" match="*|text()"/>

	<xsl:template mode="form.list" match="data:item/*">
		<li class="list-group-item d-flex justify-content-between lh-sm" xo-scope="{@xo:id}">
			<div onclick="scope.parentNode.selectNodes('*/@state:selected').remove(); scope.set('state:selected',true)">
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

	<xsl:template mode="form.item" match="data:item/*">
		<h4 class="mb-3">Billing address</h4>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<div class="col-sm-6">
					<label for="firstName" class="form-label">First name</label>
					<input type="text" class="form-control" id="firstName" placeholder="" value="{@text}" required=""/>
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

		</form>
	</xsl:template>

	<xsl:template mode="form.item" match="data:item/*">
		<h4 class="mb-3">Billing address</h4>
		<form class="needs-validation" novalidate="">
			<div class="row g-3">
				<div class="col-sm-6">
					<label for="firstName" class="form-label">First name</label>
					<input type="text" class="form-control" id="firstName" placeholder="" value="{@text}" required=""/>
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

		</form>
	</xsl:template>

	<xsl:template mode="form.item" match="data:item/*[not(key('selected', @xo:id))]"/>

</xsl:stylesheet>