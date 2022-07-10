<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:x="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
exclude-result-prefixes="#default x session sitemap shell state source"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>

	<xsl:template match="/" priority="-1">
		<section>
			<xsl:apply-templates mode="shell"/>
		</section>
	</xsl:template>

	<xsl:template match="shell:shell" mode="shell">
		<div id="shell" class="wrapper">
			<script>
					<![CDATA[
				function toggleSidebar(show) {
					let width = Number.parseInt(document.querySelector('.sidebar').style.width);
					document.querySelector('.sidebar').style.width = width || show === false ? 0 : '250px';
				}
				
				xover.listener.on('keyup', async function (event) {
					if (event.keyCode == 27) {
						toggleSidebar(false);
						event.stopPropagation();
					}
				})
				]]>
			</script>
			<style>
			</style>
			<div class="wrapper">
				<aside class="sidebar" xo-store="#sitemap" xo-stylesheet="sitemap.xslt" id="sitemap"/>
				<div class="main">
					<nav class="navbar navbar-expand navbar-light bg-white" style="padding:.6rem 1.25rem; z-index: 100; position: sticky; top: 0;">
						<span style="font-size:30px;cursor:pointer" onclick="toggleSidebar()">&#9776; <img src=""/>
						</span>
						<div class="navbar-collapse collapse">
							<div>
								<!--Logo-->
								<a href="#shell" title="Ir a la página principal">
									<img src="assets/logo.png" height="40px" style="z-index: 1002"/>
								</a>
							</div>
							<xsl:apply-templates mode="nav.search" select="."/>
							<div class="">
								<ul class="navbar-nav ml-auto">
									<li class="nav-item dropdown">
										<a class="nav-icon dropdown-toggle d-inline-block d-sm-none" href="#" data-toggle="dropdown">
											<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-settings align-middle">
												<circle cx="12" cy="12" r="3"></circle>
												<path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
											</svg>
										</a>

										<span xo-store="#menus">
										</span>

									</li>
								</ul>
							</div>
						</div>

					</nav>
					<main>
					</main>
					<div class="container-footer">
						
					</div>
				</div>
			</div>
			<div class="settings" xo-store="#settings" xo-stylesheet="settings.xslt"/>
		</div>
	</xsl:template>

	<xsl:template mode="nav.search" match="*">
		<div class="anteanter_section search">
			<section class="section_nav navbar-form navbar-left hpadding0 hmargecontenidozul" method="GET" id="frmBuscador">
				<div id="sitemap_horizontal" xo-store="#sitemap" xo-stylesheet="sitemap_horizontal.xslt"/>
			</section>
		</div>

	</xsl:template>


	<xsl:template mode="nav.search.menu" match="*">
		<div class="category_items">
			<div class="form-group col-auto my-1">
				<select class="form-control search_pandc" id="exampleFormControlSelect1">
					<option>Todas las categorías</option>
					<xsl:for-each select="//source:categorias/x:r">
						<option>
							<xsl:value-of select="@NombreCategoria"/>
						</option>
					</xsl:for-each>
				</select>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
