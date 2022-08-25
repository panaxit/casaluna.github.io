<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xo="http://panax.io/xover"
  xmlns:state="http://panax.io/state"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
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
  xmlns:datagrid="http://panax.io/widgets/datagrid"
  exclude-result-prefixes="xo state xsl datagrid CardView data height width data story temp px layout"
>
	<xsl:import href="cardview.xslt"/>
	<xsl:import href="values.xslt"/>

	<xsl:key name="password" match="px:Field[contains(@xsi:type,'password')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="combobox" match="px:Association[px:Entity/@xsi:type='combobox:control']" use="concat(../@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(../@xo:id,'::',@Name)"/>
	<xsl:key name="data_rows" match="data:rows/xo:r" use="../../@xo:id"/>
	<xsl:key name="data_row" match="data:rows/xo:r" use="@xo:id"/>

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

	<xsl:template mode="datagrid:widget" match="*">
		<xsl:param name="rows" select="../data:rows/*"/>
		<xsl:param name="fields" select="../px:Record/*"/>
		<xsl:param name="layout" select="*"/>
		<div class="row">
			<style>
				tr.deleting:after {
				background: red;
				content: '';
				left: 50%;
				position: absolute;
				transform: translateX(-50%) translateY(50%);
				width: 70%;
				height: 25px;
				vertical-align: middle;
				opacity: .5;
				}
			</style>
			<table class="table table-striped table-hover">
				<thead>
					<xsl:apply-templates mode="datagrid:header" select=".">
						<xsl:with-param name="fields" select="$fields"/>
						<xsl:with-param name="rows" select="$rows[key('data_row',@xo:id)]"/>
					</xsl:apply-templates>
				</thead>
				<tbody class="table-group-divider">
					<xsl:apply-templates mode="datagrid:body" select=".">
						<xsl:with-param name="fields" select="$fields"/>
						<xsl:with-param name="rows" select="$rows[key('data_row',@xo:id)]"/>
						<xsl:with-param name="layout" select="$layout"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template mode="datagrid:body" match="*">
		<xsl:param name="layout" select="dummy"/>
		<xsl:apply-templates mode="datagrid:body" select="$layout">
			<xsl:with-param name="row" select="current()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="datagrid:header" match="*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:param name="rows" select="dummy"/>
		<xsl:if test="$rows">
			<tr>
				<th scope="row">
					#
				</th>
				<th scope="row">
					&#160;
				</th>
				<xsl:apply-templates mode="datagrid:header.column">
					<xsl:with-param name="fields" select="$fields"/>
				</xsl:apply-templates>
				<th scope="row">
					&#160;
				</th>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="datagrid:header.column" match="*">
		<xsl:param name="fields" select="dummy"/>
		<xsl:variable name="field" select="$fields[@Id=current()/@id]"/>
		<th scope="col" ondblclick="this.toggle('contenteditable','')" xo-scope="{$field/@xo:id}" xo-attribute="headerText">
			<xsl:value-of select="$field/@headerText"/>
		</th>
	</xsl:template>

	<xsl:template mode="datagrid:body" match="*">
		<xsl:param name="rows" select="dummy"/>
		<xsl:param name="layout" select="dummy"/>
		<xsl:choose>
			<xsl:when test="not($rows)">
				<tr>
					<td colspan="{count($layout)+3}" style="text-align:center">
						Sin elementos <button type="button" class="btn btn-success" onclick="xover.dom.navigateTo('{concat(../@Schema,'/',../@Name)}~add', '{../data:rows/@xo:id}')">Agregar</button>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="datagrid:body.row" select="$rows">
					<xsl:with-param name="layout" select="$layout"/>
				</xsl:apply-templates>
				<!--<tr>
					<td colspan="{count($layout)+3}" style="text-align:center" onclick="xover.dom.navigateTo('{concat(../@Schema,'/',../@Name)}~add', '{../data:rows/@xo:id}')">
						<button type="button" class="btn btn-success" onclick="xover.dom.navigateTo('{concat(../@Schema,'/',../@Name)}~add', '{../data:rows/@xo:id}')">Agregar</button>
					</td>
				</tr>-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="datagrid:body.row" match="*">
		<xsl:param name="row" select="."/>
		<xsl:param name="layout" select="dummy"/>
		<xsl:choose>
			<xsl:when test="1=0 and $row/@state:delete">
				<tr xo-scope="{$row/@xo:id}" style="height: 15px !important;background-color: #dc3545 !important;">
					<td colspan="{count($layout)+3}" style="text-align: center;">
						<div class="" xo-attribute="state:delete">
							<span class="badge-delete p-1 badge-danger-light" onclick="scope.remove()">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-counterclockwise" viewBox="0 0 16 16">
									<path fill-rule="evenodd" d="M8 3a5 5 0 1 1-4.546 2.914.5.5 0 0 0-.908-.417A6 6 0 1 0 8 2v1z"></path>
									<path d="M8 4.466V.534a.25.25 0 0 0-.41-.192L5.23 2.308a.25.25 0 0 0 0 .384l2.36 1.966A.25.25 0 0 0 8 4.466z"></path>
								</svg>&#160;Cancelar borrar
							</span>
						</div>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="class">
					<xsl:if test="$row/@state:delete">
						<xsl:text>deleting</xsl:text>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="identity" select="$row/@value"/>
				<tr xo-scope="{$row/@xo:id}" onclick="scope.set('state:selected',true)" class="{$class}">
					<th scope="row">
						<xsl:value-of select="$row/@state:position"/>
					</th>
					<th>
						<xsl:if test="$identity!=''">
							<div class="btn btn-primary" onclick="window.location.href='#{$row/ancestor::px:Entity[1]/@Schema}/{$row/ancestor::px:Entity[1]/@Name}~edit:{$identity}'">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
									<path fill-rule="evenodd" d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"/>
									<path fill-rule="evenodd" d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
								</svg>
							</div>
						</xsl:if>
					</th>
					<xsl:apply-templates mode="datagrid:body" select="$layout">
						<xsl:with-param name="row" select="$row"/>
					</xsl:apply-templates>
					<th>
						<div class="btn btn-danger" onclick="scope.toggle('state:delete',true)">
							<xsl:if test="not($identity!='')">
								<xsl:attribute name="onclick">scope.remove()</xsl:attribute>
							</xsl:if>
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
								<path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
								<path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
							</svg>
						</div>
					</th>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="datagrid:body" match="layout:layout//*">
		<xsl:param name="row" select="dummy"/>
		<td>
			<xsl:apply-templates select="$row/@*[name()=current()/@name]"/>
		</td>
	</xsl:template>

	<xsl:key name="selected" match="*[@state:selected]" use="@xo:id"/>

	<xsl:template mode="datagrid:list" match="*|text()"/>

	<xsl:template mode="datagrid:list" match="data:rows/*">
		<li class="list-group-item d-flex justify-content-between lh-sm">
			<div>
				<h6 class="my-0">
					<xsl:value-of select="@text"/>
				</h6>
			</div>
			<!--<span class="text-muted">$12</span>-->
		</li>
	</xsl:template>

</xsl:stylesheet>