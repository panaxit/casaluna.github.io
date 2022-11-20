xo.listener.on(`change::px:Entity/data:rows/xo:r/@*`, function ({ element:row, attribute, old, value }) {
    let entity = attribute.$('ancestor::px:Entity[1]')
    switch (entity.get("Schema") + '.' + entity.get("Name")) {
        case "Egresos.Gastos":
            if (['Total', 'TotalPagado'].includes(attribute.name)) {
                row.set("Saldo", row.get("Total") - row.get("TotalPagado"))
            }
            break;
        case "Egresos.Compras":
            let Cantidad = row.get("Cantidad");
            let TotalCompraPesos = row.get("TotalCompraPesos");
            let TotalCompraDolares = row.get("TotalCompraDolares");
            row.set("PrecioUnitarioPesos", TotalCompraPesos / Cantidad)
            row.set("PrecioUnitarioDolares", TotalCompraDolares / Cantidad)
            break;
        case "Ingresos.Venta":
            let TotalArticulos = row.get("Monto");
            let Descuento = row.get("Descuento");
            row.set("MontoTotal", TotalArticulos - Descuento)
            break;
        default:
            break;
    }
})

xo.listener.on(`beforeChange::xo:r/@meta:FK_VentaDetalle_Articulos`, function ({ node, element, attribute, old, value }) {
    let src_element = event.srcEvent.srcElement;
    let selected_record = src_element[src_element.selectedIndex].scope.filter("self::xo:r")
    element.set("PrecioTotal", selected_record.get("PrecioVenta"));
})

xo.listener.on('appendTo::px:Entity[@Schema="Ventas" and @Name="Venta"]/px:Record/px:Association[@AssociationName="FK_OrdenDetalle_Orden"]/px:Entity/data:rows', function () {
    let data_row = this;
    data_row.select(`ancestor::px:Entity[2]/data:rows[not(xo:r[2])]/xo:r`).forEach(target => {
        target.set("Monto", data_row.$$("xo:r/@PrecioTotal").reduce((total, item) => { total += Number.parseFloat(item.value); return total }, 0))
    })
})

xo.listener.on('appendTo::px:Entity[@Schema="Ventas" and @Name="Venta"]/px:Record/px:Association[@AssociationName="FK_Cobros_Venta"]/px:Entity/data:rows', function () {
    let data_row = this;
    data_row.select(`ancestor::px:Entity[2]/data:rows[not(xo:r[2])]/xo:r`).forEach(target => {
        target.set("Cobros", data_row.$$("xo:r/@Monto").reduce((total, item) => { total += Number.parseFloat(item.value); return total }, 0))
    })
})

xo.listener.on('beforeSubmit::px:Entity[@Schema="Ventas" and @Name="Venta"]/data:rows/xo:r', function ({ post }) {
    let row = this
    let comprobacion_actual = post.selectFirst(`self::post:batch/post:dataTable/*/post:field[@name="Comprobacion"]`);
    let comprobacion = xo.xml.createNode('<field xmlns="http://panax.io/persistence" name="Comprobacion"><Comprobacion xmlns=""/></field>');
    if (comprobacion_actual) {
        comprobacion_actual.replaceWith(comprobacion);
    } else {
        post.selectFirst("self::post:batch/post:dataTable/*").insertFirst(comprobacion);
    }
    let rows = row.select(`ancestor::px:Entity[1]/px:Record/px:Association[not(@Type="belongsTo")]/px:Entity/data:rows/xo:r`)
    rows.reduce((entities, row) => {
        let entity = row.$('ancestor-or-self::px:Entity[1]');
        !entities.includes(entity) && entities.push(entity);
        return entities;
    }, []).forEach(entity => {
        let dataTable = xo.xml.createNode(`<dataTable Schema="${entity.get("Schema")}" Name="${entity.get("Name")}"/>`)
        return comprobacion.firstElementChild.insertFirst(dataTable)
    });
    rows.forEach(row => {
        let entity = row.$('ancestor-or-self::px:Entity[1]');
        let dataTable = comprobacion.firstElementChild.selectFirst(`*[@Schema="${entity.get("Schema")}" and @Name="${entity.get("Name")}"]`);
        dataTable.append(row.cloneNode());
        post.selectFirst("self::post:batch/post:dataTable/*").insertFirst(comprobacion)
    })
    if (comprobacion) comprobacion.textContent = `'${comprobacion.firstElementChild.toString().replace("'","''")}'`    
})