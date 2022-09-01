xo.listener.on(`change::px:Entity/data:rows/xo:r/@*`, function ({ element, attribute, old, value }) {
    let entity = attribute.$('ancestor::px:Entity[1]')
    switch (entity.get("Schema") + '.' + entity.get("Name")) {
        case "Egresos.Gastos":
            if (['Total', 'TotalPagado'].includes(attribute.name)) {
                element.set("Saldo", element.get("Total") - element.get("TotalPagado"))
            }
            break;
        case "Egresos.Compras":
            let Cantidad = element.get("Cantidad");
            let TotalCompraPesos = element.get("TotalCompraPesos");
            let TotalCompraDolares = element.get("TotalCompraDolares");
            element.set("PrecioUnitarioPesos", TotalCompraPesos / Cantidad)
            element.set("PrecioUnitarioDolares", TotalCompraDolares / Cantidad)
            break;
        case "Ingresos.Venta":
            let TotalArticulos = element.get("Monto");
            let Descuento = element.get("Descuento");
            element.set("MontoTotal", TotalArticulos - Descuento)
            break;
        default:
            break;
    }
})