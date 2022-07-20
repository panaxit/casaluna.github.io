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
  xmlns:data="urn:item:data"
  xmlns:story="urn:item:story"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  exclude-result-prefixes="xo state xsl CardView data height width data story temp"
>
	<xsl:import href="templates/cardview.xslt"/>
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

	<xsl:template match="*">
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
	</xsl:template>

	<xsl:template mode="CardView:Card.Image.attributes.src" match="*">
		<xsl:value-of select="@image"/>
	</xsl:template>

	<xsl:template mode="CardView:Card.Image.attributes.src" match="*">
		<xsl:value-of select="@image"/>
	</xsl:template>

	<xsl:template mode="CardView:Card.Image.attributes.class" match="attachment/@value[.!='']|@image">
		<xsl:text/>zoom<xsl:text/>
	</xsl:template>
	<xsl:template mode="CardView:Card.Image.attributes" match="attachment/@value[.!='']|@image">
		<xsl:attribute name="onmouseover">this.classList.add(`zoomX${Math.max(Math.round(300/ this.getBoundingClientRect().height),Math.round(400 / this.getBoundingClientRect().width))}`)</xsl:attribute>
	</xsl:template>

	<xsl:template mode="CardView:Card.Footer.content" match="@*">
		&nbsp;
		<xsl:variable name="style">
			<xsl:if test="../@xsi:type='mock'">visibility:hidden</xsl:if>
		</xsl:variable>
		<xsl:variable name="id" select="ancestor-or-self::*[@xo:id][1]/@xo:id"/>
		<input type="file" id="file_{$id}" hidden="" xo-scope="{$id}">
			<xsl:if test="not(self::*)">
				<xsl:attribute name="xo-attribute">
					<xsl:value-of select="name()"/>
				</xsl:attribute>
			</xsl:if>
		</input>
		<a href="{.}" style="float: left; margin:10px; {$style}" target="_blank">
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-cloud-download" viewBox="0 0 16 16">
				<path d="M4.406 1.342A5.53 5.53 0 0 1 8 0c2.69 0 4.923 2 5.166 4.579C14.758 4.804 16 6.137 16 7.773 16 9.569 14.502 11 12.687 11H10a.5.5 0 0 1 0-1h2.688C13.979 10 15 8.988 15 7.773c0-1.216-1.02-2.228-2.313-2.228h-.5v-.5C12.188 2.825 10.328 1 8 1a4.53 4.53 0 0 0-2.941 1.1c-.757.652-1.153 1.438-1.153 2.055v.448l-.445.049C2.064 4.805 1 5.952 1 7.318 1 8.785 2.23 10 3.781 10H6a.5.5 0 0 1 0 1H3.781C1.708 11 0 9.366 0 7.318c0-1.763 1.266-3.223 2.942-3.593.143-.863.698-1.723 1.464-2.383z"/>
				<path d="M7.646 15.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 14.293V5.5a.5.5 0 0 0-1 0v8.793l-2.146-2.147a.5.5 0 0 0-.708.708l3 3z"/>
			</svg>
		</a>
		<label for="file_{$id}" class="file button" style="float: right; margin:10px; ">
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="button bi bi-file-earmark-plus" viewBox="0 0 16 16">
				<path d="M8 6.5a.5.5 0 0 1 .5.5v1.5H10a.5.5 0 0 1 0 1H8.5V11a.5.5 0 0 1-1 0V9.5H6a.5.5 0 0 1 0-1h1.5V7a.5.5 0 0 1 .5-.5z"/>
				<path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z"/>
			</svg>
		</label>
		<label style="float: right; margin:10px; ">
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="button bi bi-trash" viewBox="0 0 16 16" style="{$style}" xo-scope="{../@xo:id}" onclick="scope.remove()">
				<xsl:if test="not(self::*) and ../self::item">
					<xsl:attribute name="xo-attribute">
						<xsl:value-of select="name()"/>
					</xsl:attribute>
				</xsl:if>
				<path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
				<path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
			</svg>
		</label>
	</xsl:template>

	<xsl:template mode="CardView:Card.Body.content" match="*|@*">
		<xsl:attribute name="style">padding: unset;</xsl:attribute>
	</xsl:template>

	<xsl:template mode="CardView:attributes.class" match="*|@*">
		<xsl:param name="items" select="."/>
		<xsl:text/>card-group col-<xsl:value-of select="count($items)*2"/><xsl:text/>
	</xsl:template>

	<xsl:template mode="CardView:Card.Picture" match="attachment/@*[.='']|@file">
		<svg viewBox="0 0 24 24" width="35" height="35" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1" style="margin:50px auto; color: silver">
			<path d="M21.44 11.05l-9.19 9.19a6 6 0 0 1-8.49-8.49l9.19-9.19a4 4 0 0 1 5.66 5.66l-9.2 9.19a2 2 0 0 1-2.83-2.83l8.49-8.48"></path>
		</svg>
	</xsl:template>

	<xsl:template mode="CardView:Card.Picture" match="attachment[@type='picture']/@*[.='']|@picture">
		<svg xmlns="http://www.w3.org/2000/svg" width="35" height="35" fill="currentColor" class="bi bi-camera-fill" viewBox="0 0 16 16" style="margin:50px auto; color: silver">
			<path d="M10.5 8.5a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
			<path d="M2 4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-1.172a2 2 0 0 1-1.414-.586l-.828-.828A2 2 0 0 0 9.172 2H6.828a2 2 0 0 0-1.414.586l-.828.828A2 2 0 0 1 3.172 4H2zm.5 2a.5.5 0 1 1 0-1 .5.5 0 0 1 0 1zm9 2.5a3.5 3.5 0 1 1-7 0 3.5 3.5 0 0 1 7 0z"/>
		</svg>
	</xsl:template>

	<xsl:template mode="CardView:Card.Picture" match="attachment[key('file_type',generate-id())]/@*[.!='']|@file">
		<i>
			<xsl:attribute name="class">
				<xsl:text/>`bi bi-filetype bi-filetype-${(<xsl:if test="../@metadata:value">
					<xsl:value-of select="../@metadata:value"/> ||
				</xsl:if>xover.string.getFileParts("<xsl:value-of select="."/>") )['extension']}`<xsl:text/>
			</xsl:attribute>
		</i>
	</xsl:template>

</xsl:stylesheet>