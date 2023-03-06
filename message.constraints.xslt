<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xsl xo"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes" standalone="no"/>

	<xsl:template match="response">
		<div class="messages {@type}" role="alertdialog">
			<div>
				<div class="modal-dialog" role="document" style="padding-top: 160px;">
					<div class="modal-content message-error w-100">
						<div class="modal-header alert">
							<h2 class="modal-title font-weight-bold mt-2" style="margin-left: 4rem !important;">¡Aviso!</h2>
							<div type="button" class="btn close" data-dismiss="modal" aria-label="Close" onclick="closest('.messages').remove()">
								<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" class="bi bi-x-circle x-circle-icon" viewBox="0 0 24 24">
									<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
									<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
								</svg>
							</div>
						</div>
						<div class="modal-body ">
							<xsl:apply-templates mode="message-body" select="results/result/@statusMessage"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template mode="message-body" match="@*">
		<h4>
			<xsl:value-of select="."/>
		</h4>
	</xsl:template>

	<xsl:template mode="message-body" match="result[@status='error'][@table_name][@reference]/@*">
		<h4 style="margin-left: 3rem !important;">
			<xsl:apply-templates select="current()"/>
			<br/>
			<br/>
			<a href="#" class="btn btn-primary btn-lg" role="button" aria-disabled="true" onclick="closest('.messages').remove()">
				<xsl:attribute name="href">
					<xsl:text/>#<xsl:text/>
					<xsl:value-of select="translate(../@schema,'.','/')"/>
					<xsl:text/>/<xsl:text/>
					<xsl:value-of select="translate(../@table_name,'.','/')"/>
					<xsl:text/>?<xsl:value-of select="../@column"/>=<xsl:text/>
					<xsl:value-of select="../@reference"/>
				</xsl:attribute>
				<xsl:text/>Ver referencias...<xsl:text/>
			</a>
		</h4>
	</xsl:template>
</xsl:stylesheet>