xo.listener.on(`change::px:Entity/data:rows/xo:r/@*`, function ({ element: row, attribute, old, value }) {
    let entity = attribute.$('ancestor::px:Entity[1]')
    switch (entity.get("Schema") + '.' + entity.get("Name")) {
        case "Egresos.Gastos":
            if (['Total', 'TotalPagado'].includes(attribute.name)) {
                row.set("Saldo", row.get("Total") - row.get("TotalPagado"))
            }
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

xo.listener.on(`beforeRender::#Inventarios/Articulos`, function ({ dom }) {
    dom && dom.querySelectorAll("fieldset.container-Costos > div").forEach(el => {
        el.classList.remove("justify-content-between");
        el.classList.add("flex-wrap");
    })
})

xo.listener.on(`beforeRender::#Ventas/Venta`, function ({ dom }) {
    for (let field_name of [...new Set([...dom.querySelectorAll("table tr div.placeholder")].map(el => [...el.classList].join('.')))]) {
        [...dom.querySelectorAll(`tr td .${field_name}`)].map((mensaje, ix) => [...mensaje.querySelectorAll('span')].filter((span, i) => ix != i)).forEach(el => el.removeAll());
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
    let row = this;
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
    if (comprobacion) comprobacion.textContent = `'${comprobacion.firstElementChild.toString().replace("'", "''")}'`
})

xo.listener.on('load::#Ventas/Catalogo', function ({ store }) {
    let entity = store;
    for (let routes of entity.select(`px:Entity/px:Routes[not(px:Route)]`)) {
        routes.append(xo.xml.createNode(`<px:Route xmlns:px="${xo.spaces["px"]}" Method="addToCart"/>`))
    }
})

xo.listener.on('fetch::px:Entity[@Schema="Ventas"][@Name="Venta"]', function ({ document }) {
    document.select(`px:Entity/px:Routes/px:Route[@Method="add"]`).remove()
})

xo.listener.on(['load::x:prompt[Routine//parameter]', 'response::x:prompt[Routine//parameter]'], function () {
    let document = this;
    let schema = {
        "@TipoEvento": {
            "controlType": 'autocompleteBox',
            "entity": { Schema: "Catalogos", Name: "TiposEvento" },
            "fields": {
                "meta:id": "RTRIM(#panax.prepareString(TipoEvento))",
                "meta:text": "RTRIM(#panax.prepareString(TipoEvento))"
            }
        }
    }
    document.documentElement.setAttributeNS(xo.spaces["xmlns"], "xmlns:data", xo.spaces["data"]);
    document.$$(`/xo:prompt/Routine/parameter/@name`).filter(parameter => parameter.value in schema).map(parameter => [parameter, schema[parameter.value]["entity"], schema[parameter.value]["fields"], schema[parameter.value]["controlType"]]).forEach(([parameter, entity, fields, controlType]) => {
        controlType && parameter.parentNode.setAttribute("controlType", controlType);
        if (entity) {
            parameter.parentNode.setAttribute("data:rows",
                `${entity["Schema"]}/${entity["Name"]}#${Object.entries(fields).filter(([, value]) => value).map(([key, value]) => `[@${key}]=${value}`).join(',')}`
            )
        }
    });
})

cart = {};
cart.add = function (item) {
    let store = xo.stores["#cart"];
    store.documentElement.append(item);
}

cart.remove = function (item) {
    let store = xo.stores["#Ventas/Catalogo"];
    if (!(store && store.documentElement)) return;
    let data_rows = store.documentElement.selectSingleNode("data:rows");
    data_rows.append(item);
}

cart.checkout = function () {
    let store = xo.stores["#cart"];
    if (store.documentElement.select("xo:r")) {
        xo.server.checkout({ "@Articulos": `'${store.documentElement.select("xo:r/@IdArticuloInventario").map(item => item.value).join(',')}'` })
    }
}

xo.listener.on('appendTo::px:Entity[@Name="Catalogo"]/data:rows', function ({ addedNodes }) {
    let cart = xo.stores["#cart"];
    let selected = cart.select("*/xo:r/@IdArticuloInventario").map(el => el.value);
    [...addedNodes].filter(item => selected.includes(item.getAttribute("IdArticuloInventario"))).forEach(el => el.remove());
})

xo.listener.on(`removeFrom::cart`, function ({ removedNodes }) {
    [...removedNodes].forEach(item => cart.remove(item));
})

xo.listener.on([`success::#server:checkout`, `success::#server:request`], function ({ response }) {
    /*Mejorar este método cuando se pueda especificar que es #server:checkout */
    let id_venta = response.headers.get("x-idventa");
    if (id_venta) {
        px.navigateTo(`#Ventas/Venta:${id_venta}~edit`);
        xo.stores["#cart"].select("cart/xo:r|cart/@state:expanded").remove();
        xo.stores["#Ventas/Catalogo"].select("px:Entity/data:rows/@command").set(command => command.value);
    }
})

ventas = {};
ventas.toggleRecibo = function (scope) {
    let document = scope.ownerDocument;
    let stylesheet_recibo = document.stylesheets["recibo.xslt"];
    if (stylesheet_recibo) {
        stylesheet_recibo.remove();
    } else {
        document.addStylesheet({ href: "recibo.xslt", target: 'main' }, document.documentElement)
    }
}

/*Version 20230313_1436*/
xo.listener.on(`appendTo::px:Entity[@controlType="calendar"]/data:rows`, function ({ store, node }) {
    let fechas = this.select("x:r/@Fecha").filter(fecha => fecha.value).map(fecha => new Date(fecha.value + 'T00:00:00'));
    if (!fechas.length) return;
    var maxDate = new Date(Math.max.apply(null, fechas));
    var minDate = new Date(Math.min.apply(null, fechas));
    let month = minDate.getMonth() + 1;
    this.ownerDocument.selectFirst("//dias").setAttribute("state:current_month", minDate.getFullYear() + '-' + ('0' + month).substr(-2, 2))
})

xo.listener.on(`beforeTransform::px:Entity[@controlType="calendar"][@env:stylesheet="px-Entity.xslt"]`, function ({ store, node }) {
    let target_node = this.selectFirst("px:Entity/dias");
    let [year, month] = target_node.getAttribute("state:current_month").split('-');
    let dias = xo.xml.createNode(`<dias state:current_month="${year}-${('0' + month).substr(-2, 2)}">${dateRange(new Date(year, month - 1, 1).toJSON().substring(0, 10)).map(el => xo.xml.createNode(`<dia value="${el.toJSON().substring(0, 10)} 00:00:00" text="${el.getDate()}" week="${el.getWeek()}"/>`)).join('')}</dias>`)
    target_node.append(...dias.childNodes);
})

xo.listener.on(`fetch::px:Entity`, function ({ store, node }) {
    if (this.documentElement.matches(`*[@controlType="calendar"]`)) {
        this.documentElement.append(xo.xml.createNode(`<labels>
		<meses>
			<mes value="01">Enero</mes>
			<mes value="02">Febrero</mes>
			<mes value="03">Marzo</mes>
			<mes value="04">Abril</mes>
			<mes value="05">Mayo</mes>
			<mes value="06">Junio</mes>
			<mes value="07">Julio</mes>
			<mes value="08">Agosto</mes>
			<mes value="09">Septiembre</mes>
			<mes value="10">Octubre</mes>
			<mes value="11">Noviembre</mes>
			<mes value="12">Diciembre</mes>
		</meses>
		<diaSemana>
			<dia>Semana</dia>
			<dia>Domingo</dia>
			<dia>Lunes</dia>
			<dia>Martes</dia>
			<dia>Miercoles</dia>
			<dia>Jueves</dia>
			<dia>Viernes</dia>
			<dia>Sabado</dia>
		</diaSemana>
	</labels>`))
        var date = new Date();
        let month = date.getMonth() + 1;
        let year = date.getFullYear();
        this.documentElement.append(xo.xml.createNode(`<dias state:current_month="${year}-${('0' + month).substr(-2, 2)}"/>`));
    }
})

function moveMonth(attr, interval = { m: 1 }) {
    let date = new Date(attr.value + '-01T00:00:00');
    date.setMonth(date.getMonth() + interval.m);
    date.setDate(1)
    attr.set(date.toJSON().substring(0, 7));
}

function dateRange(date = Date.now(), range = { m: 1 }) {
    let first_date = new Date(`${date}T00:00:00`);
    let dates = getDates(first_date, new Date(first_date).setMonth(first_date.getMonth() + (range.m || 0)) - 1);
    dates = getDates(dates[0].addDays(-dates[0].getDay()), dates[0].addDays(-1)).concat(dates);
    dates = dates.concat(getDates(dates[dates.length - 1].addDays(1), dates[dates.length - 1].addDays(6 - dates[dates.length - 1].getDay())));
    return dates;
}

function getDates(startDate, stopDate) {
    var dateArray = new Array();
    var currentDate = startDate;
    while (currentDate <= stopDate) {
        dateArray.push(new Date(currentDate));
        currentDate = currentDate.addDays(1);
    }
    return dateArray;
}

function weekNumber(date) {
    let startDate = new Date(date.getFullYear(), 0, 1);
    let days = Math.floor((date - startDate) /
        (24 * 60 * 60 * 1000));

    return Math.ceil(date.getDay() + 1 + days / 7);
}

Date.prototype.getWeek = function () {
    var onejan = new Date(this.getFullYear(), 0, 1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
};

/**/
xo.listener.on(`fetch::px:Entity[@Schema="Agenda"]`, function ({ store, node }) {
    this.documentElement.set('controlType', 'calendar')
})