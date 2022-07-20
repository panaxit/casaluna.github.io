<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:js="http://panax.io/xover/javascript"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:x="http://panax.io/xover"
exclude-result-prefixes="#default session sitemap shell"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:key name="menu" match="/menu/*" use="'#any'"/>
	<xsl:key name="menu" match="/*[not(self::menu)]" use="'#any'"/>

	<xsl:template match="/">
		<li class="btn-group">
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="*" mode="icon.badge"/>

	<xsl:template match="*[item]" mode="icon.badge">
		<span class="position-absolute top-0 translate-middle badge rounded-pill bg-danger">
			<xsl:value-of select="count(item)"/>
			<span class="visually-hidden">unread items</span>
		</span>
	</xsl:template>

	<xsl:template match="*" mode="icon"/>

	<xsl:template match="messages" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chat" viewBox="0 0 16 16">
			<path d="M2.678 11.894a1 1 0 0 1 .287.801 10.97 10.97 0 0 1-.398 2c1.395-.323 2.247-.697 2.634-.893a1 1 0 0 1 .71-.074A8.06 8.06 0 0 0 8 14c3.996 0 7-2.807 7-6 0-3.192-3.004-6-7-6S1 4.808 1 8c0 1.468.617 2.83 1.678 3.894zm-.493 3.905a21.682 21.682 0 0 1-.713.129c-.2.032-.352-.176-.273-.362a9.68 9.68 0 0 0 .244-.637l.003-.01c.248-.72.45-1.548.524-2.319C.743 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7-3.582 7-8 7a9.06 9.06 0 0 1-2.347-.306c-.52.263-1.639.742-3.468 1.105z"/>
		</svg>
	</xsl:template>

	<xsl:template match="edit" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
			<path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
		</svg>
	</xsl:template>

	<xsl:template match="view" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-columns-gap" viewBox="0 0 16 16">
			<path d="M6 1v3H1V1h5zM1 0a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1H1zm14 12v3h-5v-3h5zm-5-1a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-5zM6 8v7H1V8h5zM1 7a1 1 0 0 0-1 1v7a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1V8a1 1 0 0 0-1-1H1zm14-6v7h-5V1h5zm-5-1a1 1 0 0 0-1 1v7a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1V1a1 1 0 0 0-1-1h-5z"/>
		</svg>
	</xsl:template>

	<xsl:template match="search" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
			<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
		</svg>
	</xsl:template>

	<xsl:template match="idioms" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-globe" viewBox="0 0 16 16">
			<path d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm7.5-6.923c-.67.204-1.335.82-1.887 1.855A7.97 7.97 0 0 0 5.145 4H7.5V1.077zM4.09 4a9.267 9.267 0 0 1 .64-1.539 6.7 6.7 0 0 1 .597-.933A7.025 7.025 0 0 0 2.255 4H4.09zm-.582 3.5c.03-.877.138-1.718.312-2.5H1.674a6.958 6.958 0 0 0-.656 2.5h2.49zM4.847 5a12.5 12.5 0 0 0-.338 2.5H7.5V5H4.847zM8.5 5v2.5h2.99a12.495 12.495 0 0 0-.337-2.5H8.5zM4.51 8.5a12.5 12.5 0 0 0 .337 2.5H7.5V8.5H4.51zm3.99 0V11h2.653c.187-.765.306-1.608.338-2.5H8.5zM5.145 12c.138.386.295.744.468 1.068.552 1.035 1.218 1.65 1.887 1.855V12H5.145zm.182 2.472a6.696 6.696 0 0 1-.597-.933A9.268 9.268 0 0 1 4.09 12H2.255a7.024 7.024 0 0 0 3.072 2.472zM3.82 11a13.652 13.652 0 0 1-.312-2.5h-2.49c.062.89.291 1.733.656 2.5H3.82zm6.853 3.472A7.024 7.024 0 0 0 13.745 12H11.91a9.27 9.27 0 0 1-.64 1.539 6.688 6.688 0 0 1-.597.933zM8.5 12v2.923c.67-.204 1.335-.82 1.887-1.855.173-.324.33-.682.468-1.068H8.5zm3.68-1h2.146c.365-.767.594-1.61.656-2.5h-2.49a13.65 13.65 0 0 1-.312 2.5zm2.802-3.5a6.959 6.959 0 0 0-.656-2.5H12.18c.174.782.282 1.623.312 2.5h2.49zM11.27 2.461c.247.464.462.98.64 1.539h1.835a7.024 7.024 0 0 0-3.072-2.472c.218.284.418.598.597.933zM10.855 4a7.966 7.966 0 0 0-.468-1.068C9.835 1.897 9.17 1.282 8.5 1.077V4h2.355z"/>
		</svg>
	</xsl:template>

	<xsl:template match="notifications" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bell" viewBox="0 0 16 16">
			<path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2zM8 1.918l-.797.161A4.002 4.002 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4.002 4.002 0 0 0-3.203-3.92L8 1.917zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5.002 5.002 0 0 1 13 6c0 .88.32 4.2 1.22 6z"/>
		</svg>
	</xsl:template>

	<xsl:template match="cart" mode="icon">
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cart3" viewBox="0 0 16 16">
			<path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .49.598l-1 5a.5.5 0 0 1-.465.401l-9.397.472L4.415 11H13a.5.5 0 0 1 0 1H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l.84 4.479 9.144-.459L13.89 4H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
		</svg>
	</xsl:template>

	<xsl:template match="*" mode="menu">
		<xsl:apply-templates/>
		<!--<a class="dropdown-item text-center small text-gray-500" href="#">No default <xsl:value-of select="name()"/>: <xsl:value-of select="count(item)"/>
	</a>-->
	</xsl:template>

	<xsl:template match="messages" mode="menu">
		<h6 class="dropdown-header">
			Mensajes
		</h6>
		<hr class="dropdown-divider"/>
		<xsl:apply-templates/>
		<hr class="dropdown-divider"/>
		<a class="dropdown-item text-center small text-gray-500" href="#">Leer más mensajes</a>
	</xsl:template>

	<xsl:template match="idioms" mode="menu">
		<h6 class="dropdown-header">
			Idiomas
		</h6>
		<hr class="dropdown-divider"/>
		<a class="dropdown-item d-flex align-items-center" href="#">
			<div class="mr-3">
				<div>
					<img src="./custom/images/me.png" width="20" height="20"/>
				</div>
			</div>
			<div>
				<span class="font-weight-bold">Español (México)</span>
			</div>
		</a>

		<a class="dropdown-item d-flex align-items-center" href="#">
			<div class="mr-3">
				<div>
					<img src="./custom/images/Eua.png" width="20" height="20"/>
				</div>
			</div>
			<div>
				<span class="font-weight-bold">English (US)</span>
			</div>
		</a>
	</xsl:template>

	<xsl:template match="search" mode="menu">
		<form class="form-inline mr-auto w-100 navbar-search">
			<div class="input-group">
				<input type="text" class="form-control bg-light border-0 small" placeholder="search for..." aria-label="search" aria-describedby="basic-addon2"/>
				<div class="input-group-append">
					<button class="btn btn-primary" type="button">
						<i class="fas fa-search fa-sm"></i>
					</button>
				</div>
			</div>
		</form>
	</xsl:template>

	<xsl:template match="key('menu','#any')">
		<xsl:variable name="disabled">
			<xsl:if test="@state:disabled">disabled</xsl:if>
		</xsl:variable>
		<a class="nav-link dropdown-toggle {$disabled}" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<xsl:apply-templates mode="icon" select="."/>
			<xsl:apply-templates mode="icon.badge" select="."/>
		</a>

		<xsl:variable name="items" select="item"/>
		<div class="dropdown-menu dropdown-menu-end p-3 shadow animated--grow-in" aria-labelledby="searchdropdown">
			<xsl:apply-templates mode="menu" select="."/>
		</div>
	</xsl:template>

	<xsl:template match="item">
		<a class="dropdown-item" href="#" xo-scope="{@x:id}" onclick="scope.remove()">
			<xsl:value-of select="text()"/>
		</a>
	</xsl:template>

	<xsl:template match="cart/item">
		<a class="dropdown-item cart d-flex align-items-center" href="#" style="" xo-scope="{@x:id}">
			<div class="mr-3">
				<div>
					<img src="images/product.jpg" width="40" height="40"/>
				</div>
			</div>
			<div class="cart-popup-item__description">
				<div>
					<span class="cart-popup-item__title">
						<xsl:value-of select="text()"/>
					</span>
					<ul class="product_prd_details" aria-label="Detalles del producto" data-cart-popup-product-details="">
						<li class="product_prd_details__item product-details__item--variant-option">
							<xsl:text> $</xsl:text>
							<xsl:value-of select="Precio/text()"/>
						</li>
					</ul>
					<!--<span>
            <xsl:text> $</xsl:text>
            <xsl:value-of select="Precio/text()"/>
          </span>-->
				</div>
				<div class="cart-popup-item__quantity">
					<span onclick="scope.remove()">
						<i class="fas fa-trash-alt" ></i>
					</span>
				</div>
			</div>
			<!--<div class="delete_prod">
        <span onclick="cart.remove({Id})">
          <i class="fas fa-trash-alt" ></i>
        </span>
      </div>-->
		</a>
	</xsl:template>
</xsl:stylesheet>
