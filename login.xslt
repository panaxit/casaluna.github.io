<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
xmlns:xo="http://panax.io/xover"
xmlns:session="http://panax.io/session"
xmlns:sitemap="http://panax.io/sitemap"
xmlns:shell="http://panax.io/shell"
xmlns:state="http://panax.io/state"
xmlns:source="http://panax.io/xover/binding/source"
xmlns:login="http://panax.io/widget/login"
xmlns:js="http://panax.io/languages/javascript"
>
	<xsl:output method="xml"
	   omit-xml-declaration="yes"
	   indent="yes"/>


	<xsl:include href="panax/widgets/login.xslt"/>

	<xsl:template match="/">
		<section>
			<style>
				<![CDATA[
html { 
  background: url(images/cover_1.jpg) no-repeat center center fixed; 
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
}

body {
	background-color: transparent !important;
}

.login {
	transform: translateY(-140px);
}
			]]>
			</style>
			<xsl:apply-templates mode="login:widget" select="*/@xo:id"/>
		</section>
	</xsl:template>

	<xsl:template mode="login:image-attributes" match="@*|*">
		<xsl:attribute name="src">./assets/logotype-alpha-black.png</xsl:attribute>
	</xsl:template>	
</xsl:stylesheet>
