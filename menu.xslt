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
	<xsl:import href="menu_item.xslt"/>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="text()"/>
	<xsl:param name="session:user_login"/>
	<xsl:param name="session:debug">false</xsl:param>
	<xsl:param name="js:cache_name">xover.session.cache_name.split('_').pop()</xsl:param>
	<xsl:key name="expanded" match="*[@state:expanded='true']" use="true()"/>

	<xsl:template match="*">
		<span class="menu">
			<script>
				<![CDATA[xo.listener.on('click', function(){ 
			    if (!event.srcElement.closest('.menu')) {
			        for (let dropdown of [...document.querySelectorAll(".menu .dropdown-toggle.show")]) {
						let scoped_dropdown = dropdown.scope;
						const dropdownInstance = new bootstrap.Dropdown(dropdown);
						dropdownInstance.toggle();
						scoped_dropdown.toggle(false);
					}
				}
			})]]>
			</script>
			<style>
				<![CDATA[
.avatar {
    margin-top: -15px;
    margin-bottom: -15px;
    width: 40px;
    height: 40px;
}

.menu .translate-middle {
	transform: translate(-60%,-25%)!important;
}

.menu .badge {
	font-size: .65em;
}
			]]>
			</style>
			<ul class="navbar-nav ml-auto menu">
				<xsl:apply-templates/>
				<div class="topbar-divider d-none d-sm-block"></div>
				<div class="dropdown">
					<a class="btn dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-fill" viewBox="0 0 16 16">
							<path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H3zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
						</svg>&#160;&#160;<xsl:value-of select="$session:user_login"/>
					</a>
					<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuLink">
						<li>
							<a class="dropdown-item disabled" href="#">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-badge-fill" viewBox="0 0 16 16">
									<path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm4.5 0a.5.5 0 0 0 0 1h3a.5.5 0 0 0 0-1h-3zM8 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm5 2.755C12.146 12.825 10.623 12 8 12s-4.146.826-5 1.755V14a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-.245z"/>
								</svg>
								<label>Perfil</label>
							</a>
						</li>
						<li>
							<hr class="dropdown-divider"/>
						</li>
						<li onclick="xo.session.logout()">
							<a class="dropdown-item" href="#">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-door-open-fill" viewBox="0 0 16 16">
									<path d="M1.5 15a.5.5 0 0 0 0 1h13a.5.5 0 0 0 0-1H13V2.5A1.5 1.5 0 0 0 11.5 1H11V.5a.5.5 0 0 0-.57-.495l-7 1A.5.5 0 0 0 3 1.5V15H1.5zM11 2h.5a.5.5 0 0 1 .5.5V15h-1V2zm-2.5 8c-.276 0-.5-.448-.5-1s.224-1 .5-1 .5.448.5 1-.224 1-.5 1z"/>
								</svg>
								<label>Salir</label>
							</a>
						</li>
					</ul>
				</div>
			</ul>
		</span>
	</xsl:template>

	<xsl:template match="/menu/*/item">
		<li>
			<a class="dropdown-item" href="#">
				<xsl:value-of select="text()"/>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="*" mode="icon.badge"/>

	<xsl:template match="messages[item]" mode="icon.badge">
		<span class="position-absolute top-0 translate-middle badge rounded-pill bg-danger">
			<xsl:value-of select="count(item)"/>
			<span class="visually-hidden">unread messages</span>
		</span>
	</xsl:template>


	<xsl:template match="*" mode="section">
	</xsl:template>

	<xsl:template match="notifications|messages|cart" mode="section">
		<xsl:attribute name="xo-store">
			<xsl:text/>#<xsl:value-of select="name()"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="/menu/*">
		<xsl:variable name="disabled">
			<xsl:if test="@state:disabled">disabled</xsl:if>
		</xsl:variable>
		<li class="nav-item dropdown no-arrow">
			<xsl:apply-templates mode="section" select="."/>
			<a class="nav-link dropdown-toggle {$disabled}" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<xsl:apply-templates mode="icon" select="."/>
				<xsl:apply-templates mode="icon.badge" select="."/>
			</a>

			<xsl:variable name="items" select="item"/>
			<div class="dropdown-menu dropdown-menu-end p-3 shadow animated--grow-in" aria-labelledby="searchdropdown">
				<xsl:apply-templates mode="menu" select="."/>
			</div>
		</li>
	</xsl:template>

</xsl:stylesheet>
