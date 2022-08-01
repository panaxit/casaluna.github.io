<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:CardView="http://panax.io/widgets/cardview"
  xmlns:metadata="http://panax.io/metadata"
  xmlns:temp="http://panax.io/temp"
  xmlns:data="http://panax.io/source"
  xmlns:story="urn:item:story"
  xmlns:height = "http://panax.io/state/height"
  xmlns:width = "http://panax.io/state/width"
  xmlns:px="http://panax.io/entity"
  xmlns:layout="http://panax.io/layout"
  exclude-result-prefixes="xo state xsl CardView data height width data story temp px layout"
>
	<xsl:import href="cardview.xslt"/>
	<xsl:import href="values.xslt"/>

	<xsl:key name="combobox" match="px:Association[px:Entity/@xsi:type='combobox:control']" use="@Name"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="@Name"/>

	<xsl:key name="selected" match="*[@state:active]" use="''"/>
	<xsl:key name="selected" match="/*[not(//@state:active)]" use="''"/>
	<xsl:key name="verified" match="*[@verified='true']" use="@xo:id"/>
	<xsl:key name="verified" match="*[@verified='true']/item" use="@xo:id"/>
	<xsl:key name="file_type" match="attachment[contains(@metadata:value, 'application/')]" use="generate-id()"/>
	<xsl:key name="file_type" match="attachment[@type='file']" use="generate-id()"/>
	<xsl:key name="data_types" match="item[@type='data' or @type='field' or @type='indicator' or @type='formula' or @type='table' or @type='database' or @type='file' or @type='server']" use="@xo:id"/>
	<xsl:key name="data_types" match="data:rows" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='story']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='component']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='document']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='software']" use="@xo:id"/>
	<xsl:key name="data_types" match="item[@type='service']" use="@xo:id"/>
	<xsl:key name="user_types" match="item[@type='user']" use="@xo:id"/>
	<xsl:key name="other_types" match="item[@type='info']" use="@xo:id"/>
	<xsl:key name="ref" match="data:rows|item" use="concat(translate(@title, '_', ' '),'::',string(@type))"/>
	<xsl:key name="ref_items" match="data:rows" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_items" match="item" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="ref_fields" match="item[@type='field'][item[@type='table']]" use="concat(translate(item[@type='table']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_fields" match="item[@type='table'][item[@type='database']]" use="concat(translate(item[@type='database']/@title, '_', ' '),'::',@type)"/>
	<xsl:key name="ref_data" match="data:rows" use="concat(translate(../@title, '_', ' '),'::',string(../@type))"/>
	<xsl:key name="distinct" match="data:rows" use="concat(../@title,'::',@title)"/>
	<xsl:template match="/">
		<div class="container">
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css"/>
			<style></style>/style>
			<xsl:choose>
				<xsl:when test="key('selected','')">
					<xsl:apply-templates select="key('selected','')[last()]"/>
				</xsl:when>
				<xsl:otherwise>
					<button onclick="xover.stores.active.$$('//@state:active').removeAll()">Reset</button>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="px:Entity">
		<xsl:variable name="rows" select=".//data:rows/*"/>
		<div class="row g-5">
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<xsl:apply-templates mode="datagrid.header" select="layout:layout">
							<xsl:with-param name="fields" select="px:Record"/>
							<xsl:with-param name="rows" select="$rows"/>
						</xsl:apply-templates>
					</tr>
				</thead>
				<tbody class="table-group-divider">
					<xsl:apply-templates mode="datagrid.body" select="$rows">
						<xsl:with-param name="fields" select="px:Record"/>
						<xsl:with-param name="layout" select="layout:layout"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="data:rows/*">
		<xsl:param name="layout" select="dummy"/>
		<xsl:apply-templates mode="datagrid.body" select="$layout">
			<xsl:with-param name="row" select="current()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="datagrid.header" match="layout:layout">
		<xsl:param name="fields" select="dummy"/>
		<tr>
			<th scope="row">
				#
			</th>
			<xsl:apply-templates mode="datagrid.header">
				<xsl:with-param name="fields" select="$fields"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid.header" match="layout:layout//*">
		<xsl:param name="fields" select="dummy"/>
		<th scope="col">
			<xsl:value-of select="$fields/*[@Id=current()/@id]/@headerText"/>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="layout:layout">
		<xsl:param name="row" select="dummy"/>
		<tr xo-scope="{$row/@xo:id}" onclick="window.location.href='#{$row/ancestor::px:Entity[1]/@Schema}/{$row/ancestor::px:Entity[1]/@Name}~edit:{$row/@value}'" style="cursor:pointer">
			<th scope="row">
				<xsl:value-of select="$row/@state:position"/>
			</th>
			<xsl:apply-templates mode="datagrid.body">
				<xsl:with-param name="row" select="$row"/>
			</xsl:apply-templates>
		</tr>
	</xsl:template>

	<xsl:template mode="datagrid.body" match="layout:layout//*">
		<xsl:param name="row" select="dummy"/>
		<td>
			<xsl:apply-templates select="$row/@*[name()=current()/@name]"/>
		</td>
	</xsl:template>

	<xsl:key name="selected" match="*[@state:selected]" use="@xo:id"/>

	<xsl:template mode="datagrid.list" match="*|text()"/>

	<xsl:template mode="datagrid.list" match="data:rows/*">
		<li class="list-group-item d-flex justify-content-between lh-sm" xo-scope="{@xo:id}">
			<div onclick="scope.parentNode.selectNodes('*/@state:selected').remove(); scope.set('state:selected',true)">
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

</xsl:stylesheet>