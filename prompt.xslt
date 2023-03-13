<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:source="http://panax.io/fetch/request"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:session="http://panax.io/session"
  xmlns:state="http://panax.io/state"
  xmlns:px="http://panax.io"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:widget="http://panax.io/widget"
  xmlns:js="http://panax.io/xover/javascript"
  xmlns:modal="http://panax.io/widget/modal"
  xmlns:autocompleteBox="http://panax.io/widget/autocompleteBox"
  xmlns:search="http://panax.io/state/search"
  exclude-result-prefixes="xo source data meta session state px widget modal search"
>
	<xsl:import href="widgets/prompt.xslt"/>
	<xsl:param name="js:today"><![CDATA[new Date().toISOString().substring(0,10)]]></xsl:param>

	<xsl:key name="parameter" match="attr-expected" use="name()"/>

	<xsl:key name="parameter" match="parameter/@name" use="."/>
	<xsl:key name="hidden" match="parameter[starts-with(@name,'@@')]" use="generate-id()"/>
	<xsl:key name="hidden" match="parameter[text()[not(.='DEFAULT')]]" use="generate-id()"/>
	<xsl:key name="hidden" match="parameter[@isOutput='1']" use="generate-id()"/>

	<xsl:key name="widget" match="parameter[translate(@dataType,'[]','')='datetime']/@value" use="concat('datetime:',ancestor::Routine[1]/@xo:id,'::',../@name)"/>
	<xsl:key name="widget" match="parameter[translate(@dataType,'[]','')='date']/@value" use="concat('date:',ancestor::Routine[1]/@xo:id,'::',../@name)"/>

	<xsl:template mode="headerText" match="parameter/@name[starts-with(.,'@Fecha')]">
		<xsl:text>Fecha de </xsl:text><xsl:value-of select="substring(.,7)"/>
	</xsl:template>

	<xsl:template mode="headerText" match="parameter/@name[starts-with(.,'@Tipo')]">
		<xsl:text>Tipo de </xsl:text><xsl:value-of select="substring(.,6)"/>
	</xsl:template>
	
	<xsl:template match="parameter[starts-with(@name,'@Fecha')]/@value" mode="widget:attributes">
		<xsl:attribute name="min">
			<xsl:value-of select="$js:today"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template mode="autocompleteBox:following-siblings" match="parameter[@name='@Paciente']/@value">
		<li class="dropdown-item" value="{../@search:value}">
			<xsl:text/><xsl:value-of select="../@search:value"/> (Registrar paciente)<xsl:text/>
		</li>
	</xsl:template>
</xsl:stylesheet>
