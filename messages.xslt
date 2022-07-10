<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:debug="http://panax.io/debug"
  xmlns:x="http://panax.io/xover"
  xmlns:xhr="http://panax.io/xover/xhr"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xsl msxsl x debug xhr"
>

  <xsl:template match="x:message">
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="@type='exception'">danger_message</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@type"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{@type}" role="alertdialog">
      <div class="messages">
        <!--<span onclick="this.parentElement.style.display='none'; xover.data.remove('{@x:id}')" class="w3-button w3-large w3-display-topright" >
          <img src="./custom/images/circle-x.svg" width="30" height="30" class="gwt-Image" style="cursor: pointer;"/>
        </span>-->
        <div class="modal-dialog" role="document" style="padding-top: 160px;">
          <div class="modal-content message-error w-100">
            <div class="modal-header alert">
              <h2 class="modal-title font-weight-bold mt-2" style="margin-left: 4rem !important;">¡Aviso!</h2>
              <div type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="xover.data.removeMessage('{@x:id}')">
                <!--<img class="gwt-Image mt-2 mr-2" src="./custom/images/circle-x.svg" width="30" height="30"/>-->
                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" class="bi bi-x-circle x-circle-icon" viewBox="0 0 24 24">
                  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                </svg>
              </div>
            </div>
            <div class="modal-body">
              <h4 style="margin-left: 3rem !important;">
                <xsl:value-of select="text()"/>
              </h4>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
