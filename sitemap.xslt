<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:x="http://panax.io/xover"
xmlns:session="http://panax.io/session"
exclude-result-prefixes="#default x session"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>
	<xsl:template match="sitemap" priority="-1">
		<aside class="sidebar">
			<script>
				<![CDATA[xo.listener.on('click', function(){ 
			    if (!event.srcElement.closest('nav')) {
			        toggleSidebar(false);
				}
			})]]>
			</script>
			<style>
				<![CDATA[
body {
  font-family: "Lato", sans-serif;
}

.sidebar {
  height: 100%;
  width: 0;
  position: fixed;
  z-index: 101;
  top: 0;
  left: 0;
  background-color: rgba(50, 62, 72, 0.9);
  overflow-x: hidden;
  transition: 0.5s;
  padding-top: 60px;
}

.sidebar::after {
    background-image: url(assets/img/background-1.jpg);
}

.sidebar a {
  padding: 8px 8px 8px 32px;
  text-decoration: none;
  font-size: 25px;
  color: #818181;
  display: block;
  transition: 0.3s;
}

.sidebar a:hover {
  color: #f1f1f1;
}

.sidebar .closebtn {
  position: absolute;
  top: 0;
  right: 25px;
  font-size: 36px;
  margin-left: 50px;
}

@media screen and (max-height: 450px) {
  .sidebar {padding-top: 15px;}
  .sidebar a {font-size: 18px;}
}
			]]>
			</style>
			<a href="javascript:void(0)" class="closebtn" onclick="toggleSidebar()">&#215;</a>
			<xsl:for-each select="*">
				<a href="#{substring(*/@target,2)}" onclick="scope.parentNode.$$('*//@state:active').remove(); scope.set('state:active','true');" xo-scope="{@x:id}">
					<xsl:value-of select="@title"/>
				</a>
			</xsl:for-each>
		</aside>
	</xsl:template></xsl:stylesheet>
