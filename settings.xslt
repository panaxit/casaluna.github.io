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

	<xsl:template match="text()"/>
	<xsl:param name="session:debug">false</xsl:param>
	<xsl:param name="session:autoRebuild">false</xsl:param>
	<xsl:param name="session:disableCache">true</xsl:param>
	<xsl:param name="js:cache_name">xover.session.cache_name.split('_').pop()</xsl:param>
	<xsl:key name="expanded" match="*[@state:expanded='true']" use="true()"/>

	<xsl:template match="*">
		<xsl:variable name="open">
			<xsl:if test="key('expanded',true())">open</xsl:if>
		</xsl:variable>
		<div class="settings {$open}">
			<style>
				<![CDATA[
    .settings {
        font-family: sans-serif;
        display: none;
    }
	
	.settings a {
        text-decoration: none;
        color: black;
	}

    @media (min-width:1200px) {
        .settings {
            display: block
        }
    }

    .settings-toggle {
        background: #343a40;
        color: #fff;
        position: fixed;
        top: 160px;
        right: 0;
        width: 46px;
        padding: .75rem;
        border-top-left-radius: .2rem;
        border-bottom-left-radius: .2rem;
        box-shadow: -5px 0 10px 0 rgba(0,0,0,.1);
        -webkit-transition: all .1s ease-in-out;
        transition: all .1s ease-in-out;
        cursor: pointer
    }

    .settings-toggle:hover {
        width: 52px
    }

    .settings-toggle svg {
        width: 22px;
        height: 22px;
        -webkit-animation-name: spin;
        animation-name: spin;
        -webkit-animation-duration: 4s;
        animation-duration: 4s;
        -webkit-animation-iteration-count: infinite;
        animation-iteration-count: infinite;
        -webkit-animation-timing-function: linear;
        animation-timing-function: linear
    }

    .settings-panel {
        background: #fff;
        border-left: 1px solid #e5e9f2;
        box-shadow: -5px 0 10px 0 rgba(0,0,0,.1);
        display: block;
        height: 100%;
        position: fixed;
        width: 240px;
        z-index: 100;
        top: 0;
        bottom: 0;
        right: -240px;
        -webkit-transition: right .2s ease-in-out;
        transition: right .2s ease-in-out
    }

    .settings.open .settings-panel:before {
        content: "";
        background: rgba(0,0,0,.2);
        position: fixed;
        left: 0;
        top: 0;
        height: 100%;
        width: 100%;
        z-index: -1;
        pointer-events: none
    }

    .settings.open .settings-panel {
        right: 0
    }

    .settings-content {
        height: 100%;
        position: relative;
        background: #fff
    }

    .settings-content .ps__thumb-y, .settings-content .simplebar-scrollbar:before {
        background: rgba(0,0,0,.5)
    }

    .settings-title {
        padding: 1.35rem 1.5rem;
        font-size: .875rem
    }

    .settings-title h4 {
        margin-bottom: 0
    }

    .settings-section {
        border-top: 1px solid #e5e9f2;
        padding: 1rem 1.5rem
    }

    .settings-layouts {
        line-height: 2;
        list-style: none;
        margin-bottom: 0;
        padding-left: 0
    }

    .settings-layouts-item .badge {
        background: #adb5bd;
        border-radius: 10rem;
        color: #fff;
        padding: .2rem .35rem
    }

    .settings-layouts-item, .settings-layouts-item:hover {
        color: #495057;
        text-decoration: none;
        cursor: pointer
    }

        .settings-layouts-item:hover .badge {
            background: #6c757d
        }

    .settings-theme {
        display: block;
        margin-bottom: 1rem;
        text-align: center;
        text-decoration: none;
        cursor: pointer
    }

    .settings-theme:last-child {
        margin-bottom: 0
    }

    .settings-theme:hover {
        text-decoration: none
    }

    .settings-theme img {
        border-radius: .2rem;
        border: 1px solid #ced4da;
        -webkit-transform: scale(1);
        transform: scale(1);
        -webkit-transition: all .1s ease-in-out;
        transition: all .1s ease-in-out
    }

    .settings-theme:hover img {
        -webkit-transform: scale(1.03);
        transform: scale(1.03)
    }
	
	.closebtn {
      position: absolute;
      top: 0;
      right: 25px;
      font-size: 36px;
      margin-left: 50px;
    }
			]]></style>
			<script>
				<![CDATA[ 
    xover.listener.on('click', function (event) {
        let settings = window.top.document.querySelector('.settings');
        if(!event.target.closest('.settings') && settings) { 
            settings.classList.remove('open'); 
        }
	}); ]]>
			</script>
			<div class="settings-toggle toggle-settings" onclick="closest('div.settings').classList.toggle('open');">
				<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-settings align-middle">
					<circle cx="12" cy="12" r="3"></circle>
					<path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
				</svg>
			</div>

			<div class="settings-panel">
				<div class="settings-content js-simplebar" data-simplebar="init">
					<div class="simplebar-wrapper" style="margin: 0px;">
						<div class="simplebar-height-auto-observer-wrapper">
							<div class="simplebar-height-auto-observer"></div>
						</div>
						<div class="simplebar-mask">
							<div class="simplebar-offset" style="right: -17px; bottom: 0px;">
								<div class="simplebar-content-wrapper" style="height: 100%; overflow-x: hidden; overflow-y: auto;">
									<div class="simplebar-content" style="padding: 0px;">
										<div class="settings-title">
											<a href="javascript:void(0)" class="closebtn" onclick="closest('div.settings').classList.toggle('open');">&#215;</a>
											<h4>Herramientas</h4>
											<xsl:if test="$js:cache_name!=''">
												<h6>
													v. <xsl:value-of select="$js:cache_name"/>
												</h6>
											</xsl:if>
										</div>

										<div class="settings-section">
											<small class="d-block text-uppercase font-weight-bold text-muted mb-2">Sesión</small>
											<div class="list-group">
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.session.saveSession();">Guardar sesión</button>
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.session.loadSession()">Restaurar sesión</button>
											</div>
										</div>

										<div class="settings-section">
											<small class="d-block text-uppercase font-weight-bold text-muted mb-2">Edición</small>
											<div class="list-group">
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.data.undo();">Deshacer</button>
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.data.redo()">Rehacer</button>
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.dom.print()">Imprimir</button>
											</div>
										</div>
										<div class="settings-section">
											<small class="d-block text-uppercase font-weight-bold text-muted mb-2">Caché</small>
											<div class="list-group">
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.dom.refresh({{forced:true}});">Actualizar módulo</button>
												<button type="button" class="list-group-item list-group-item-action" onclick="xover.library.reload(); /*window.location.reload(true);*/">Actualizar librerías</button>
												<xsl:if test="$js:cache_name!=''">
													<button type="button" class="list-group-item list-group-item-action" onclick="xover.session.clearCache();">Borrar caché</button>
												</xsl:if>
											</div>
										</div>
										<div class="settings-section">
											<small class="d-block text-uppercase font-weight-bold text-muted mb-2">Desarrollador</small>
											<div class="list-group">
												<button type="button" class="list-group-item list-group-item-action" onclick="xo.stores.active.toClipboard();">Copiar fuente</button>
												<button type="button" class="list-group-item list-group-item-action">
													<xsl:choose>
														<xsl:when test="$session:debug='true'">
															<xsl:attribute name="onclick">xover.session.debug=false</xsl:attribute>
															Deshabilitar depurar
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="onclick">xover.session.debug=true</xsl:attribute>
															Depurar
														</xsl:otherwise>
													</xsl:choose>
												</button>
												<button type="button" class="list-group-item list-group-item-action">
													<xsl:choose>
														<xsl:when test="$session:autoRebuild='true'">
															<xsl:attribute name="onclick">xover.session.autoRebuild=false</xsl:attribute>
															Deshabilitar rebuild
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="onclick">xover.session.autoRebuild=true</xsl:attribute>
															Habilitar rebuild
														</xsl:otherwise>
													</xsl:choose>
												</button>
												<button type="button" class="list-group-item list-group-item-action">
													<xsl:choose>
														<xsl:when test="$session:disableCache='true'">
															<xsl:attribute name="onclick">xover.session.disableCache=false</xsl:attribute>
															Habilitar caché
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="onclick">xover.session.disableCache=true</xsl:attribute>
															Deshabilitar caché
														</xsl:otherwise>
													</xsl:choose>
												</button>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="simplebar-placeholder" style="width: 239px; height: 854px;"></div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
