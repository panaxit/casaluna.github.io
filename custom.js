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