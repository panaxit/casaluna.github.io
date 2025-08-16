<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xo="http://panax.io/xover"
>

	<xsl:template match="xo:message">
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="@type='exception'">danger_message</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@type"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="modal" tabindex="-1" role="alertdialog">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content message-error">
					<div class="modal-header">
						<h2 class="modal-title font-weight-bold ms-3">¡Aviso!</h2>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<h4 class="ms-3">
							<xsl:value-of select="text()"/>
						</h4>
					</div>
					<!--<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
						<button type="button" class="btn btn-primary">Save changes</button>
					</div>-->
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
