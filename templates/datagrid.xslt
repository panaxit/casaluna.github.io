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
  xmlns:layout="http://panax.io/layout"
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
			<style></style>/style>
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
		<xsl:variable name="rows" select=".//data:item/*"/>
		<div class="row g-5">
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<xsl:apply-templates mode="datagrid.header" select="layout:layout">
							<xsl:with-param name="fields" select="px:Record"/>
							<xsl:with-param name="rows" select="$rows"/>
						</xsl:apply-templates>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<xsl:apply-templates mode="datagrid.body" select="$rows">
						<xsl:with-param name="fields" select="px:Record"/>
						<xsl:with-param name="layout" select="layout:layout"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="data:item/*">
		<xsl:param name="layout"/>
		<xsl:apply-templates mode="datagrid.body" select="$layout">
			<xsl:with-param name="row" select="current()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="datagrid.header" match="layout:layout">
		<xsl:param name="fields" select="dummy"/>
		<tr>
			<th scope="row">
				#
			</th>
			<xsl:apply-templates mode="datagrid.header">
				<xsl:with-param name="fields" select="$fields"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid.header" match="layout:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<th scope="col">
			<xsl:value-of select="$fields/*[@Id=current()/@id]/@headerText"/>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="layout:layout">
		<xsl:param name="row" select="dummy"/>
		<tr>
			<th scope="row">
				<xsl:value-of select="count($row/preceding-sibling::*)+1"/>
			</th>
			<xsl:apply-templates mode="datagrid.body">
				<xsl:with-param name="row" select="$row"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="layout:layout//*">
		<xsl:param name="row" select="dummy"/>
		<td>
			<xsl:value-of select="$row/@*[name()=current()/@name]"/>
		</td>
	</xsl:template>

	<xsl:key name="selected" match="*[@state:selected]" use="@xo:id"/>

	<xsl:template mode="datagrid.list" match="*|text()"/>

	<xsl:template mode="datagrid.list" match="data:item/*">
		<li class="list-group-item d-flex justify-content-between lh-sm" xo-scope="{@xo:id}">
			<div onclick="scope.parentNode.selectNodes('*/@state:selected').remove(); scope.set('state:selected',true)">
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

	<xsl:template mode="datagrid.item" match="data:item/*">
		<h4 class="mb-3">Billing address</h4>
		<datagrid class="needs-validation" novalidate="">
			<div class="row g-3">
				<div class="col-sm-6">
					<label for="firstName" class="datagrid-label">First name</label>
					<input type="text" class="datagrid-control" id="firstName" placeholder="" value="{@text}" required=""/>
					<div class="invalid-feedback">
						Valid first name is required.
					</div>
				</div>

				<div class="col-sm-6">
					<label for="lastName" class="datagrid-label">Last name</label>
					<input type="text" class="datagrid-control" id="lastName" placeholder="" value="" required=""/>
					<div class="invalid-feedback">
						Valid last name is required.
					</div>
				</div>

				<div class="col-12">
					<label for="username" class="datagrid-label">Username</label>
					<div class="input-group has-validation">
						<span class="input-group-text">@</span>
						<input type="text" class="datagrid-control" id="username" placeholder="Username" required=""/>
						<div class="invalid-feedback">
							Your username is required.
						</div>
					</div>
				</div>

				<div class="col-12">
					<label for="email" class="datagrid-label">
						Email <span class="text-muted">(Optional)</span>
					</label>
					<input type="email" class="datagrid-control" id="email" placeholder="you@example.com"/>
					<div class="invalid-feedback">
						Please enter a valid email address for shipping updates.
					</div>
				</div>

				<div class="col-12">
					<label for="address" class="datagrid-label">Address</label>
					<input type="text" class="datagrid-control" id="address" placeholder="1234 Main St" required=""/>
					<div class="invalid-feedback">
						Please enter your shipping address.
					</div>
				</div>

				<div class="col-12">
					<label for="address2" class="datagrid-label">
						Address 2 <span class="text-muted">(Optional)</span>
					</label>
					<input type="text" class="datagrid-control" id="address2" placeholder="Apartment or suite"/>
				</div>

				<div class="col-md-5">
					<label for="country" class="datagrid-label">Country</label>
					<select class="datagrid-select" id="country" required="">
						<option value="">Choose...</option>
						<option>United States</option>
					</select>
					<div class="invalid-feedback">
						Please select a valid country.
					</div>
				</div>

				<div class="col-md-4">
					<label for="state" class="datagrid-label">State</label>
					<select class="datagrid-select" id="state" required="">
						<option value="">Choose...</option>
						<option>California</option>
					</select>
					<div class="invalid-feedback">
						Please provide a valid state.
					</div>
				</div>

				<div class="col-md-3">
					<label for="zip" class="datagrid-label">Zip</label>
					<input type="text" class="datagrid-control" id="zip" placeholder="" required=""/>
					<div class="invalid-feedback">
						Zip code required.
					</div>
				</div>
			</div>

			<hr class="my-4"/>

			<div class="datagrid-check">
				<input type="checkbox" class="datagrid-check-input" id="same-address"/>
				<label class="datagrid-check-label" for="same-address">Shipping address is the same as my billing address</label>
			</div>

			<div class="datagrid-check">
				<input type="checkbox" class="datagrid-check-input" id="save-info"/>
				<label class="datagrid-check-label" for="save-info">Save this information for next time</label>
			</div>

			<hr class="my-4"/>

			<h4 class="mb-3">Payment</h4>

			<div class="my-3">
				<div class="datagrid-check">
					<input id="credit" name="paymentMethod" type="radio" class="datagrid-check-input" checked="" required=""/>
					<label class="datagrid-check-label" for="credit">Credit card</label>
				</div>
				<div class="datagrid-check">
					<input id="debit" name="paymentMethod" type="radio" class="datagrid-check-input" required=""/>
					<label class="datagrid-check-label" for="debit">Debit card</label>
				</div>
				<div class="datagrid-check">
					<input id="paypal" name="paymentMethod" type="radio" class="datagrid-check-input" required=""/>
					<label class="datagrid-check-label" for="paypal">PayPal</label>
				</div>
			</div>

			<div class="row gy-3">
				<div class="col-md-6">
					<label for="cc-name" class="datagrid-label">Name on card</label>
					<input type="text" class="datagrid-control" id="cc-name" placeholder="" required=""/>
					<small class="text-muted">Full name as displayed on card</small>
					<div class="invalid-feedback">
						Name on card is required
					</div>
				</div>

				<div class="col-md-6">
					<label for="cc-number" class="datagrid-label">Credit card number</label>
					<input type="text" class="datagrid-control" id="cc-number" placeholder="" required=""/>
					<div class="invalid-feedback">
						Credit card number is required
					</div>
				</div>

				<div class="col-md-3">
					<label for="cc-expiration" class="datagrid-label">Expiration</label>
					<input type="text" class="datagrid-control" id="cc-expiration" placeholder="" required=""/>
					<div class="invalid-feedback">
						Expiration date required
					</div>
				</div>

				<div class="col-md-3">
					<label for="cc-cvv" class="datagrid-label">CVV</label>
					<input type="text" class="datagrid-control" id="cc-cvv" placeholder="" required=""/>
					<div class="invalid-feedback">
						Security code required
					</div>
				</div>
			</div>

		</datagrid>
	</xsl:template>

	<xsl:template mode="datagrid.item" match="data:item/*">
		<h4 class="mb-3">Billing address</h4>
		<datagrid class="needs-validation" novalidate="">
			<div class="row g-3">
				<div class="col-sm-6">
					<label for="firstName" class="datagrid-label">First name</label>
					<input type="text" class="datagrid-control" id="firstName" placeholder="" value="{@text}" required=""/>
					<div class="invalid-feedback">
						Valid first name is required.
					</div>
				</div>

				<div class="col-sm-6">
					<label for="lastName" class="datagrid-label">Last name</label>
					<input type="text" class="datagrid-control" id="lastName" placeholder="" value="" required=""/>
					<div class="invalid-feedback">
						Valid last name is required.
					</div>
				</div>

				<div class="col-12">
					<label for="username" class="datagrid-label">Username</label>
					<div class="input-group has-validation">
						<span class="input-group-text">@</span>
						<input type="text" class="datagrid-control" id="username" placeholder="Username" required=""/>
						<div class="invalid-feedback">
							Your username is required.
						</div>
					</div>
				</div>

				<div class="col-12">
					<label for="email" class="datagrid-label">
						Email <span class="text-muted">(Optional)</span>
					</label>
					<input type="email" class="datagrid-control" id="email" placeholder="you@example.com"/>
					<div class="invalid-feedback">
						Please enter a valid email address for shipping updates.
					</div>
				</div>

				<div class="col-12">
					<label for="address" class="datagrid-label">Address</label>
					<input type="text" class="datagrid-control" id="address" placeholder="1234 Main St" required=""/>
					<div class="invalid-feedback">
						Please enter your shipping address.
					</div>
				</div>

				<div class="col-12">
					<label for="address2" class="datagrid-label">
						Address 2 <span class="text-muted">(Optional)</span>
					</label>
					<input type="text" class="datagrid-control" id="address2" placeholder="Apartment or suite"/>
				</div>

				<div class="col-md-5">
					<label for="country" class="datagrid-label">Country</label>
					<select class="datagrid-select" id="country" required="">
						<option value="">Choose...</option>
						<option>United States</option>
					</select>
					<div class="invalid-feedback">
						Please select a valid country.
					</div>
				</div>

				<div class="col-md-4">
					<label for="state" class="datagrid-label">State</label>
					<select class="datagrid-select" id="state" required="">
						<option value="">Choose...</option>
						<option>California</option>
					</select>
					<div class="invalid-feedback">
						Please provide a valid state.
					</div>
				</div>

				<div class="col-md-3">
					<label for="zip" class="datagrid-label">Zip</label>
					<input type="text" class="datagrid-control" id="zip" placeholder="" required=""/>
					<div class="invalid-feedback">
						Zip code required.
					</div>
				</div>
			</div>

			<hr class="my-4"/>

			<div class="datagrid-check">
				<input type="checkbox" class="datagrid-check-input" id="same-address"/>
				<label class="datagrid-check-label" for="same-address">Shipping address is the same as my billing address</label>
			</div>

			<div class="datagrid-check">
				<input type="checkbox" class="datagrid-check-input" id="save-info"/>
				<label class="datagrid-check-label" for="save-info">Save this information for next time</label>
			</div>

			<hr class="my-4"/>

			<h4 class="mb-3">Payment</h4>

			<div class="my-3">
				<div class="datagrid-check">
					<input id="credit" name="paymentMethod" type="radio" class="datagrid-check-input" checked="" required=""/>
					<label class="datagrid-check-label" for="credit">Credit card</label>
				</div>
				<div class="datagrid-check">
					<input id="debit" name="paymentMethod" type="radio" class="datagrid-check-input" required=""/>
					<label class="datagrid-check-label" for="debit">Debit card</label>
				</div>
				<div class="datagrid-check">
					<input id="paypal" name="paymentMethod" type="radio" class="datagrid-check-input" required=""/>
					<label class="datagrid-check-label" for="paypal">PayPal</label>
				</div>
			</div>

			<div class="row gy-3">
				<div class="col-md-6">
					<label for="cc-name" class="datagrid-label">Name on card</label>
					<input type="text" class="datagrid-control" id="cc-name" placeholder="" required=""/>
					<small class="text-muted">Full name as displayed on card</small>
					<div class="invalid-feedback">
						Name on card is required
					</div>
				</div>

				<div class="col-md-6">
					<label for="cc-number" class="datagrid-label">Credit card number</label>
					<input type="text" class="datagrid-control" id="cc-number" placeholder="" required=""/>
					<div class="invalid-feedback">
						Credit card number is required
					</div>
				</div>

				<div class="col-md-3">
					<label for="cc-expiration" class="datagrid-label">Expiration</label>
					<input type="text" class="datagrid-control" id="cc-expiration" placeholder="" required=""/>
					<div class="invalid-feedback">
						Expiration date required
					</div>
				</div>

				<div class="col-md-3">
					<label for="cc-cvv" class="datagrid-label">CVV</label>
					<input type="text" class="datagrid-control" id="cc-cvv" placeholder="" required=""/>
					<div class="invalid-feedback">
						Security code required
					</div>
				</div>
			</div>

		</datagrid>
	</xsl:template>

	<xsl:template mode="datagrid.item" match="data:item/*[not(key('selected', @xo:id))]"/>

</xsl:stylesheet>