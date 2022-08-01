Object.defineProperty(xo.session, 'login', {
    value: async function (username, password, connection_id) {
        try {
            xover.session.user_login = username
            xover.session.status = 'authorizing';
            let response = await xover.server.login(new URLSearchParams({ 'connection_id': connection_id }), { headers: { authorization: `Basic ${btoa(username + ':' + password)}` } });
            xover.session.status = 'authorized';
            xover.stores.active.render();
        } catch (e) {
            xover.session.status = 'unauthorized';
            if (e.message) alert(e.message);
        }
    }, writable: true, configurable: true
})

Object.defineProperty(xo.session, 'logout', {
    value: async function () {
        try {
            let response = await xover.server.logout();
            xover.session.status = 'unauthorized';
        } catch (e) {
            if (e.message) alert(e.message);
        }
    }, writable: true, configurable: true
})

app = {}

app.request = async function (object_name, mode) {
    let parts = object_name.split('/') || [];
    let name = parts.pop();
    let schema = parts.pop();
    return xo.sources.defaults["#" + name] || xo.xml.createDocument(`<?xml-stylesheet type="text/xsl" href="form.xslt" target="@#shell main"?><?xml-stylesheet type="text/xsl" href="title.xslt" target="@#shell nav header h1"?><?xml-stylesheet type="text/xsl" href="shell_buttons.xslt" target="@#shell #shell_buttons" action="replace"?><${name} schema="${schema}"/>`)
}

px = {}
px.request = async function (request_or_entity_name, mode, filters, ref) {
    if (!request_or_entity_name) {
        return null;
    }
    if (!(xover.manifest.server["request"])) {
        throw ("Endpoint for request is not defined in the manifest");
    }
    var schema, entity_name;
    var page_index, page_size;
    var on_success = function (xml_document) { xover.stores.active = xml_document; };
    let rebuild;
    if (typeof (request_or_entity_name) == 'string') {
        let parts = request_or_entity_name.split('/') || [];
        entity_name = parts.pop();
        schema = parts.pop();
        mode = (mode || "view");
    }
    if (request_or_entity_name.constructor === {}.constructor) {
        ({ schema, name: entity_name } = request_or_entity_name);
        //schema = request_or_entity_name["schema"]
        //entity_name = (schema ? "[" + schema + "]." : "") + request_or_entity_name["name"];
        if (!schema) {
            let full_name = entity_name;
            [, schema, entity_name] = String(full_name).match(/^\s*\[([^\]]+)\]\.\[(.+)\]\s*$/i);
        }
        mode = (mode || request_or_entity_name["mode"] || "view");
        page_index = request_or_entity_name["pageIndex"];
        page_size = request_or_entity_name["pageSize"];
        filters = (request_or_entity_name["filters"] || filters);
        on_success = (request_or_entity_name["on_success"] || on_success);
        rebuild = request_or_entity_name["rebuild"]
    }

    page_size = (page_size || xover.manifest.getSettings(`#${schema}/${mode}:${entity_name}`, "pageSize").pop());
    page_index = (page_index || xover.manifest.getSettings(`#${schema}/${mode}:${entity_name}`, "pageIndex").pop());
    let mock_store = xo.Store(xo.xml.createDocument(`<entity ${xover.json.toAttributes({ filters, mode, page_size, page_index, Name: entity_name, Schema: schema })}/>`), { tag: `${schema}/${mode}:${entity_name}`.toLowerCase() });
    let other_filters = xo.manifest.getSettings(mock_store, 'filters').pop();
    if (other_filters && other_filters[0] === '`') {
        let entity = { schema: schema, name: entity_name };
        other_filters = eval(other_filters.replace(/\\/g, '\\\\')).replace(/\\b/g, '\\b');
    }
    filters = [filters, other_filters].filter(f => f).join(' AND ').replace(/'/g, "''");

    //var current_location = window.location.hash.match(/#(\w+):(\w+)/);
    rebuild = (!xover.listener.keypress.altKey ? [rebuild, 'DEFAULT'].coalesce() : '1');
    let current_store = xover.stores.active;
    current_store.state.busy = true;
    try {
        let Response = await xover.server.request(`command=[#entity].request @@user_id='-1', @full_path='', @full_entity_name='[${schema}].[${entity_name}]', @mode=${(!mode ? 'DEFAULT' : `'${mode}'`)}, @page_index=${(page_index || 'DEFAULT')}, @page_size=${(page_size || 'DEFAULT')}, @max_records=DEFAULT, @control_type=DEFAULT, @Filters=${(!filters ? 'DEFAULT' : `'${Encoder.urlEncode(filters)}'`)}, @sorters=DEFAULT, @parameters=DEFAULT, @lang=es, @get_data=1, @get_structure=1, @rebuild=${rebuild}, @column_list=DEFAULT, @output=HTML`, {
            headers: {
                "Content-Type": 'text/xml'
                , "Accept": 'text/xml'
                , "x-Detect-Input-Variables": false
                , "x-Detect-Output-Variables": false
                , "x-Debugging": xover.debug.enabled
            }
        })
        Request.requester = ref;
        if (!(Response instanceof xover.Store) && Response && Response.documentElement) {
            let control_type = Response.$('//px:Entity').get("xsi:type").replace(':control','.xslt')
            Response.addStylesheet({ href: control_type, target: "@#shell main" });
            Response.addStylesheet({ href: "title.xslt", target: "@#shell nav header h1" });
            Response.addStylesheet({ href: "page_controls.xslt", target: "@#shell #page_controls" });
            Response.addStylesheet({ href: "shell_buttons.xslt", target: "@#shell #shell_buttons", action: "replace" });
            Response.documentElement.setAttributeNS(xover.spaces["xmlns"], "xmlns:data", "http://panax.io/source");

            let entity = Response.$('//px:Entity');
            let id = entity.$$(`px:Record/px:Field[@IsIdentity="1"]|px:Record[not(*[2])]/px:Field`).shift()
            let text = entity.$$(`px:Record/px:Field[not(@IsIdentity="1")][1]|px:Record[not(*[2])]/px:Field`).shift()

            let fields = Object.fromEntries(entity.$$('px:Record/px:Field|px:Record/px:Association[@Type="belongsTo"]/px:Mappings/px:Mapping|px:Record/px:Association[@Type="belongsTo"]').map(field => [field.$("@Name|@Referencee").value, (field.$("self::px:Field/@Name|self::px:Mapping/@Referencee") || {}).value || `(SELECT ${field.$("px:Entity/@*[local-name()='value']").value} FROM [${field.$("px:Entity/@Schema").value}].[${field.$("px:Entity/@Name").value}] parent WHERE ${field.$$('px:Mappings/px:Mapping').map(map => '['+entity.get("Name")+'].[' + map.get("Referencee") + '] = parent.[' + map.get("Referencer") + ']').join(' AND ')})`
            ]))
            
            //fields = fields.map(field => `[@${field}]=RTRIM([${field}])`);
            if (text && !fields['@text']) {
                fields["text"] = `RTRIM([${text.get("Name")}])`;
            }
            if (id && !fields['@value']) {
                fields["value"]=`RTRIM([${id.get("Name")}])`;
            }
            entity.setAttribute("data:rows", `${Object.entries(fields).map(([key, value]) => `[@${key}]=${value}`).join(',')}~>[${entity.get("Schema")}].[${entity.get("Name")}]#:=1/20`)
            return entity.ownerDocument;
            /*
            <?xml-stylesheet type="text/xsl" href="form.xslt" target="@#shell main"?><?xml-stylesheet type="text/xsl" href="title.xslt" target="@#shell nav header h1"?><?xml-stylesheet type="text/xsl" href="shell_buttons.xslt" target="@#shell #shell_buttons" action="replace"?>
             */
            //var manifest_stylesheets = xover.manifest.getSettings(xover.data.hashTagName(xml_document.documentElement), 'transforms').filter(t => !(t.role == 'init' || t.role == "binding"));
            //var stylesheets = manifest_stylesheets.concat([{ href: (xml_document.documentElement.getAttribute('controlType') || "shell").toLowerCase() + '.xslt' }].filter(() => (manifest_stylesheets.length == 0))).reduce((stylesheets, transform) => { stylesheets.push({ "href": transform.href, target: (transform.target || '@#shell main'), role: transform.role }); return stylesheets; }, []);
            //stylesheets.forEach(stylesheet => xml_document.addStylesheet(stylesheet));
            //current_store.state.busy = undefined;
            //let store = new xover.Store(xml_document)
            //var caller = xover.stores.find(Request.requester)[0];
            //if (caller && caller.selectSingleNode('self::px:dataRow')) {
            //    var new_datarow = store.document.selectSingleNode('*/px:data/px:dataRow')
            //    if (new_datarow) {
            //        new_datarow.setAttribute('x:id', caller.getAttribute('x:id'))
            //    }
            //}
            //if (caller && caller.selectSingleNode('(ancestor-or-self::*[@Name and @Schema][1])[@foreignReference]')) {
            //    store.document.documentElement.setAttribute('x:reference', caller.getAttribute('x:id'), false)
            //    var foreignReference = caller.selectSingleNode('ancestor-or-self::*[@foreignReference]');
            //    if (foreignReference) {
            //        store.documentElement.selectNodes('//px:layout//px:field[@fieldName="' + foreignReference.getAttribute('foreignReference') + '"]').remove(false);
            //    }
            //}
            //store.addStylesheet({ href: 'xover/panax/panax_bindings.xslt', target: 'self', action: 'replace' });
            //store.initialize();
            //xover.stores.active = store;
        }
    } catch (e) {
        current_store.state.busy = undefined;
        if (e instanceof HTMLDocument) {
            return Promise.reject(xover.dom.createDialog(e));
        } else {
            return Promise.reject(e);
        }
    }
}

px.getData = function (...args) {
    let settings = args.pop() || {};
    let parameters = args.pop() || {};
    let node = settings["source"];
    if (node) {
        let command = parameters;
        let attribute_base_name = node.localName;
        let fields, request;
        if (typeof (parameters) === 'string') {
            //let [request_with_fields, ...predicate] = command.split(/=>|&filters=/);
            //let [fields, request] = comnd.match('(?:(.*)~>)?(.+)');
            [rest, page] = parameters.indexOf("#:=") != -1 && parameters.split("#:=") || [parameters, "1/20"];
            [rest, predicate = ''] = rest.split("=>");
            [fields, request] = rest.indexOf("~>") != -1 && rest.split("~>") || ["*", rest];
            //let [, fields, request, predicate = ''] = command.match('(?:(.*)~>|^)?((?:(?<!=>).)+)(?:=>(.+))?$');

            /*TODO: Mover esto a un listener o definir */
            parameters = (node.getAttribute('source_filters:' + attribute_base_name) || predicate || "");
        }
        let root_node = node.prefix.replace(/^request$/, "source") + ":" + attribute_base_name;
        let headers = new Headers(xover.json.merge(settings["headers"] instanceof Headers && Object.fromEntries(settings["headers"].entries()), {
            "Cache-Response": (Array.prototype.coalesce(eval(node.getAttribute("cache" + ":" + (attribute_base_name))), eval(node.parentElement.getAttribute("cache" + ":" + (attribute_base_name))), false))
            , "Accept": content_type.xml
            , "cache-control": 'force-cache'
            , "pragram": 'force-cache'
            , "x-source-tag": node.store.tag
            , "x-original-request": command
            , "x-namespaces": `'${node.resolveNS(node.prefix)}' as ${node.prefix}`
            , "x-Root-Node": root_node
            , "x-Page-Index": page.split("/")[0]
            , "x-Page-Size": page.split("/")[1]
            , "x-Detect-Missing-Variables": "false"
            , "x-Debugging": xover.debug.enabled
            , "x-data-text": (node.getAttribute('source_text:' + attribute_base_name) || node.getAttribute('dataText') || "")
            , "x-data-value": (node.getAttribute('source_value:' + attribute_base_name) || node.getAttribute('dataValue') || "")
            , "x-data-fields": (node.getAttribute('source_fields:' + attribute_base_name) || fields || "")
        }))
        settings["headers"] = headers;
        parameters = request && { command: request, predicate: parameters } || undefined;
    }
    args.push(parameters);
    args.push(settings);
    return xo.server.request.apply(this, args);
    /*return this.source.fetch.apply(this, args)*/
}