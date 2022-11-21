<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:control="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xo="http://panax.io/xover"
  xmlns:sitemap="http://panax.io/sitemap"
  xmlns:layout="http://panax.io/layout/view/form"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:px="http://panax.io/entity"
  xmlns:data="http://panax.io/source"
  xmlns:meta="http://panax.io/metadata"
  xmlns:form="http://panax.io/widget/form"
  xmlns:datagrid="http://panax.io/widget/datagrid"
  xmlns:combobox="http://panax.io/widget/combobox"
  xmlns:file="http://panax.io/widget/file"
  xmlns:field="http://panax.io/layout/fieldref"
  xmlns:container="http://panax.io/layout/container"
  xmlns:association="http://panax.io/datatypes/association"

  exclude-result-prefixes="xo xsl sitemap layout px data form control"
>
	<xsl:key name="field" match="field:ref" use="@xo:id"/>
	<xsl:key name="association" match="association:ref" use="@xo:id"/>

	<xsl:key name="form:widget" match="px:Entity[@control:type='form:control']/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="datagrid:widget" match="px:Entity/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="combobox:widget" match="px:Entity[@control:type='combobox:control']/@xo:id" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="combobox:widget" match="xo:r/@meta:*" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="file:widget" match="px:Field[@DataType='file']" use="concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'.',@Name)"/>

	<xsl:key name="datagrid:nodeType" match="node-expected" use="concat(@xo:id,'::header')"/>


	<xsl:key name="reference" match="px:Record/px:Field/@Name" use="concat(ancestor::px:Entity[1]/@xo:id,'::header::field:ref::',.)"/>
	<xsl:key name="reference" match="px:Record/px:Association/@AssociationName" use="concat(ancestor::px:Entity[1]/@xo:id,'::header::association:ref::',.)"/>
	<xsl:key name="reference" match="px:Record/*/@Name" use="concat(ancestor::px:Entity[1]/@xo:id,'::header::container:fieldContainer::',.)"/>

	<xsl:key name="reference" match="xo:r/@*" use="concat(../@xo:id,'::body::field:ref::',name())"/>
	<xsl:key name="reference" match="xo:r/@meta:*" use="concat(../@xo:id,'::body::association:ref::',local-name())"/>

	<xsl:key name="datagrid:nodeType" match="px:Entity/px:Record/px:Field" use="concat(@xo:id,'::header')"/>
	<xsl:key name="datagrid:nodeType" match="px:Entity/px:Record/px:Association" use="concat(@xo:id,'::header')"/>

	<xsl:key name="datagrid:header-node" match="px:Entity/px:Record/px:Field" use="@xo:id"/>
	<xsl:key name="datagrid:header-node" match="px:Entity/px:Record/px:Association" use="@xo:id"/>

	<xsl:key name="datagrid:node" match="px:Entity[@controlType='datagridView']/*/field:ref" use="@xo:id"/>
	<xsl:key name="datagrid:node" match="px:Entity[@controlType='datagridView']/*/association:ref" use="@xo:id"/>
	<xsl:key name="datagrid:node" match="px:Entity[@controlType='datagridView']/*/container:*" use="@xo:id"/>

	<xsl:key name="form:node" match="px:Entity[@controlType='formView']/*/field:ref" use="@xo:id"/>
	<xsl:key name="form:node" match="px:Entity[@controlType='formView']/*/association:ref" use="@xo:id"/>
	<xsl:key name="form:node" match="px:Entity[@controlType='formView']/*/container:*" use="@xo:id"/>

	<xsl:key name="dataset" match="px:Entity/data:rows/xo:r" use="concat(ancestor::px:Entity[1]/@xo:id,'.',name())"/>
	<xsl:key name="dataset" match="px:Association/px:Entity/data:rows/xo:r" use="concat(ancestor::px:Entity[2]/@xo:id,'.meta:',ancestor::px:Association[1]/@AssociationName)"/>
	
	<xsl:key name="entity" match="px:Association/px:Entity" use="concat(ancestor::px:Entity[1]/@xo:id,'.meta:',ancestor::px:Association[1]/@AssociationName)"/>

	<xsl:key name="item" match="sitemap:menu" use="'#any'"/>
	<xsl:key name="item" match="sitemap:catalog" use="'#any'"/>
	<xsl:key name="menu-item" match="sitemap:menu" use="@xo:id"/>

	<xsl:key name="entity" match="px:Entity" use="concat(@Schema,'.',@Name)"/>
	<xsl:key name="entity" match="px:Entity[@xsi:type='datagrid:control']" use="concat('datagrid:',@Schema,'.',@Name)"/>

	<xsl:key name="record" match="data:rows/xo:r" use="@xo:id"/>

	<xsl:key name="data_rows" match="px:Entity/data:rows/xo:r" use="concat(ancestor::px:Entity[1]/@Schema,'/',ancestor::px:Entity[1]/@Name)"/>
	<xsl:key name="data_field" match="px:Entity/data:rows/*/@*" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',name())"/>

	<xsl:key name="schema" match="px:Entity/px:Record/px:Field" use="concat(ancestor::px:Entity[1]/@Schema,'.',ancestor::px:Entity[1]/@Name,'.',@Name)"/>
	<xsl:key name="association" match="px:Association" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@AssociationName)"/>
	<xsl:key name="foreignTable" match="px:Association[@DataType='foreignTable']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@AssociationName)"/>

	<xsl:key name="readonly" match="px:Record/px:Field[@mode='readonly']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="readonly" match="px:Record/px:Association[@mode='readonly']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@AssociationName)"/>


	<xsl:key name="password" match="px:Field[contains(@xsi:type,'password')]" use="concat(ancestor-or-self::*[@meta:type='entity'][1]/@xo:id,'::',@Name)"/>
	<xsl:key name="combobox" match="px:Association[*[@meta:type='entity']/@xsi:type='combobox:control']" use="concat(../@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(../@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<!--<xsl:key name="radiogroup" match="node-expected" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="combobox" match="node-expected" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="node-expected" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>-->

	<xsl:key name="combobox" match="px:Field[@controlType='combobox']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="radiogroup" match="px:Field[@controlType='radiogroup']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="textarea" match="px:Field[starts-with(@xsi:type,'string:') and @DataLength&gt;255]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="textarea" match="px:Field[starts-with(@xsi:type,'string:') and @DataLength=-1]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="yesNo" match="px:Field[starts-with(@xsi:type,'bit:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="number" match="px:Field[starts-with(@xsi:type,'integer:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="datetime" match="px:Field[starts-with(@xsi:type,'datetime:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="time" match="px:Field[starts-with(@xsi:type,'time:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="date" match="px:Field[starts-with(@xsi:type,'date:')]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="money" match="px:Field[@DataType='money']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="year" match="px:Field[@controlType='year']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>
	<xsl:key name="color" match="px:Field[@DataType='color']" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="formula" match="px:Record/px:Field[@formula]" use="concat(ancestor::px:Entity[1]/@xo:id,'::',@Name)"/>

	<xsl:key name="layout" match="*[local-name()='layout']" use="'#any'"/>
	<xsl:key name="layout" match="*[local-name()='layout']" use="@xo:id"/>
	<xsl:key name="layout" match="*[local-name()='layout']" use="../@controlType"/>

</xsl:stylesheet>