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
            for (store in xo.stores) {
                xo.stores[store].remove()
            }
            xover.session.status = 'unauthorized';
            history.go(-xo.state.position + 1);
        } catch (e) {
            if (e.message) alert(e.message);
        }
    }, writable: true, configurable: true
})

xo.listener.on('beforeRender::#shell', ({ target }) => {
    [...target.childNodes].removeAll()
})

xo.listener.on(['beforeAppendToHTMLElement::MAIN'], ({ target,  }) => {
    [...target.childNodes].removeAll()
})

xo.listener.on('change::xo:r/@*', function ({ element, attribute, old, value }) {
    if (["http://panax.io/state"].includes(attribute.namespaceURI.split(/\//g, 4).join('/'))) return;
    let initial_value = element.getAttributeNodeNS('http://panax.io/state/initial', attribute.localName);
    if (value!==null && !initial_value) {
        element.set(`initial:${attribute.localName}`, old);
    } else if (initial_value.value === value) {
        initial_value.remove();
    }
    element.set(`prev:${attribute.localName}`, old);
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
    let prev = (xo.state.prev || [])[0] || {};
    let ref_store = xo.stores[prev.store];
    let ref_node = ref_store && ref_store.findById(prev.id) || null;
    association_ref = ref_node && ref_node.$("ancestor::px:Entity[1]/parent::px:Association").get("AssociationName")
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
    let identity;
    [mode, identity] = mode.split(':')
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
    rebuild = ((xover.listener.keypress.altKey || xover.session.autoRebuild) ? '1' : [rebuild, 'DEFAULT'].coalesce());
    let current_store = xover.stores.active;
    current_store.state.busy = true;
    try {
        let Response = await xover.server.request(`command=[#entity].request @@user_id='-1', @full_path='', @full_entity_name='[${schema}].[${entity_name}]', @mode=${(!mode ? 'DEFAULT' : `'${mode}'`)}, @page_index=${(page_index || 'DEFAULT')}, @page_size=${(page_size || 'DEFAULT')}, @max_records=DEFAULT, @control_type=DEFAULT, @Filters=${(!filters ? 'DEFAULT' : `'${encodeURIComponent(filters)}'`)}, @sorters=DEFAULT, @parameters=DEFAULT, @lang=es, @get_data=1, @get_structure=1, @rebuild=${rebuild}, @column_list=DEFAULT, @output=HTML`, {
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
            let control_type = Response.$('//px:Entity').get("xsi:type").replace(':control', '.xslt')
            Response.addStylesheet({ href: control_type, target: "@#shell main" });
            Response.addStylesheet({ href: "title.xslt", target: "@#shell nav header h1" });
            Response.addStylesheet({ href: "page_controls.xslt", target: "@#shell #page_controls" });
            Response.addStylesheet({ href: "shell_buttons.xslt", target: "@#shell #shell_buttons", action: "replace" });
            Response.documentElement.setAttributeNS(xover.spaces["xmlns"], "xmlns:data", "http://panax.io/source");
            association_ref && Response.documentElement.$$(`*[local-name()="layout"]/association:*[@name="${association_ref}"]`).remove()
            px.loadData([Response.$('px:Entity')], mode == 'add' && 'NULL' || identity)
            return Response;
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

px.loadData = function (entities, identity) {
    for (entity of entities.filter(el => el)) {
        let id = entity.$$(`@combobox:value|px:Record/px:Field[@IsIdentity="1"]/@Name|px:Record[not(*[2])]/px:Field/@Name`).shift()
        let text = entity.$$(`@displayText|self::*[not(@displayText)]/@combobox:text|px:Record/px:Field[not(@IsIdentity="1")][1]/@Name|px:Record[not(*[2])]/px:Field/@Name`).shift()

        let predicate = id && identity && `[${id.value}] IN (${(identity && identity != 'NULL' ? `'${identity}'` : null) || 'null'})` || ''
        predicate = predicate || identity=='NULL' && "1=0" || ""
        let parent_entity = entity.$('ancestor::px:Entity[1]');
        if (parent_entity && parent_entity.$('data:rows/*')) {
            let parent_relationship = entity.$('parent::px:Association[@Type="hasMany"]/px:Mappings')
            let mappings = parent_relationship && parent_relationship.$$('px:Mapping').map(map => `[${entity.get("Name")}].[${map.get("Referencer")}] IN (${parent_entity.$$('data:rows/*').map(row => (row.get(map.get("Referencee")) || 'NULL')).join(',')})`) || [];
            predicate && mappings.unshift(predicate);
            predicate = mappings.join(' AND ')
        }

        let fields = Object.fromEntries(entity.$$('px:Record/px:Field|px:Record/px:Association[@Type="belongsTo"]/px:Mappings/px:Mapping|px:Record/px:Association[@Type="belongsTo"]').map(field => [field.$("@Name|@Referencer").value, `#panax.${field.get("DataType") == 'nvarchar' ? 'prepareString' : 'prepareValue'}(` + ((field.$("self::px:Field/@Name|self::px:Mapping/@Referencer") || {}).value || `(SELECT ${field.$("px:Entity/@combobox:text").value} FROM [${field.$("px:Entity/@Schema").value}].[${field.$("px:Entity/@Name").value}] parent WHERE ${field.$$('px:Mappings/px:Mapping').map(map => '[' + entity.get("Name") + '].[' + map.get("Referencer") + '] = parent.[' + map.get("Referencee") + ']').join(' AND ')})`) + ')'
        ]))

        //fields = fields.map(field => `[@${field}]=RTRIM([${field}])`);
        if (text && !fields['@text']) {
            fields["text"] = `RTRIM(#panax.prepareString(${text.value}))`; // No se ponen brackets para los nombres de las funciones
        }
        if (id && !fields['@value']) {
            fields["value"] = `RTRIM(#panax.prepareValue([${id.value}]))`;
        }
        entity.setAttribute("data:rows", `${Object.entries(fields).map(([key, value]) => `[@${key}]=${value}`).join(',')}~>[${entity.get("Schema")}].[${entity.get("Name")}]=>${predicate || ''}#:=1/${!parent_entity ? '100' : '1000'}`)
    }
}

px.getData = async function (...args) {
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
            , "x-data-text": encodeURIComponent(node.getAttribute('source_text:' + attribute_base_name) || node.getAttribute('dataText') || "")
            , "x-data-value": encodeURIComponent(node.getAttribute('source_value:' + attribute_base_name) || node.getAttribute('dataValue') || "")
            , "x-data-fields": encodeURIComponent(node.getAttribute('source_fields:' + attribute_base_name) || fields || "")
        }))
        settings["headers"] = headers;
        parameters = request && { command: request, predicate: parameters } || undefined;
    }
    args.push(parameters);
    args.push(settings);
    let response = await xo.server.request.apply(this, args);
    let entity = node.parentElement.$('self::px:Entity[@mode="add"][not(parent::px:Association)]')
    //let entity = node.$('parent::px:Entity[//px:Entity[@mode="add"]]')
    if (entity && !(response.documentElement.firstElementChild)) {
        let fields = [...new Set(entity.$$('px:Record/px:Field|px:Record/px:Association[@Type="belongsTo"]/px:Mappings/px:Mapping|px:Record/px:Association[@Type="belongsTo"]').map(field => field.$("@Name|@Referencer").value + '=""'))].join(' ')
        response.documentElement.append(xo.xml.createNode(`<xo:r xmlns:xo="http://panax.io/xover" ${fields}/>`))
    }
    return response
}

xo.listener.on('appendTo::data:rows', function ({ node }) {
    //let empty_node = node.$('xo:empty')
    //if (empty_node) {
    //    let entity = node.parentElement.$('self::px:Entity[@mode="add"][not(parent::px:Association)]')
    //    if (entity) {
    //        let fields = [...new Set(entity.$$('px:Record/px:Field|px:Record/px:Association[@Type="belongsTo"]/px:Mappings/px:Mapping|px:Record/px:Association[@Type="belongsTo"]').map(field => field.$("@Name|@Referencer").value + '=""'))].join(' ')
    //        empty_node.replace(xo.xml.createNode(`<xo:r xmlns:xo="http://panax.io/xover" ${fields}/>`))
    //    }
    //}
    px.loadData(node.parentNode.$$(`px:Record/px:Association/px:Entity`));
})

xo.listener.on('beforeChange::@headerText', function ({ element, attribute, value, old }) {
    if (!element.has(`initial:${attribute.localName}`)) {
        element.set(`initial:${attribute.localName}`, old)
    }
    event.detail.value = event.detail.value.replace(/:/g, '').trim()
})

function saveConfiguration() {
    xo.stores.active.documentElement.$$('//px:Record/*/@initial:*').map(attr => [`[${attr.parentNode.$('ancestor::px:Entity[1]').get('Schema')}].[${attr.parentNode.$('ancestor::px:Entity[1]').get('Name')}]`, (attr.parentNode.get("AssociationName") || attr.parentNode.get("Name")), `@${attr.localName}`, attr.parentNode.get(attr.localName)]).map(el => el.map(item => `'${item}'`)).forEach(config => xo.server.request({ command: "[#entity].[config]", parameters: config }, {}))
}

function submit(data_rows) {
    let prev = (xo.state.prev || [])[0] || {};
    let ref_store = xo.stores[prev.store];
    let ref_node = ref_store && ref_store.findById(prev.id) || null;

    if (ref_node) {
        ref_node.append(...data_rows)
        history.go(-1)
        return
    } 
    for (let row of data_rows) {
        let post = xo.xml.createNode(`<batch xmlns="http://panax.io/persistence" xmlns:state="http://panax.io/state" xmlns:session="http://panax.io/session"/>`)
        let entity = row.$('ancestor::px:Entity[1]');
        let id = entity.$(`px:Record/px:Field[@IsIdentity="1"]`)
        let data;
        if (row.$('self::*[@state:delete]')) {
            post.append(xo.xml.createNode(`<dataTable xmlns="http://panax.io/persistence" name="[${entity.get("Schema")}].[${entity.get("Name")}]"${id ? ` identityKey="${id.get("Name")}"` : ''}><deleteRow${id ? ` identityValue="${row.get(id.get("Name"))}"` : ''}>${entity.$$('px:Record/px:Field').map((field) => {
                let field_name = field.get("Name");
                let isPK = field.$(`ancestor::px:Entity[1]/px:PrimaryKeys/px:PrimaryKey[@Field_Name="${field_name}"]`)
                if (isPK) {
                    return `<field name="${field.get("Name")}"${isPK ? ` currentValue="'${row.get(`initial:${field.get("Name")}`) || row.get(field.get("Name"))}'" isPK="true"` : ''}></field>`
                }
            }
            ).join('')
                }</deleteRow></dataTable>`))
        } else if (entity.get("mode") == 'add') {
            post.append(xo.xml.createNode(`<dataTable xmlns="http://panax.io/persistence" name="[${entity.get("Schema")}].[${entity.get("Name")}]"${id ? ` identityKey="${id.get("Name")}"` : ''}>
    <insertRow>${entity.$$('px:Record/px:Field[not(@IsIdentity="1" or @formula)]').map((field) => {
                let field_name = field.get("Name");
                let isPK = field.$(`ancestor::px:Entity[1]/px:PrimaryKeys/px:PrimaryKey[@Field_Name="${field_name}"]`)
                return `<field name="${field.get("Name")}"${isPK ? ` isPK="true"` : ''}>${[row.get(field.get("Name"))].map(val => !val && (field.get("defaultValue") || 'null') || `'${val}'`)}</field>`
            }).join('')
                }</insertRow></dataTable>`))

        } else {
            post.append(xo.xml.createNode(`<dataTable xmlns="http://panax.io/persistence" name="[${entity.get("Schema")}].[${entity.get("Name")}]"${id ? ` identityKey="${id.get("Name")}"` : ''}><updateRow${id ? ` identityValue="${row.get(id.get("Name"))}"` : ''}>${entity.$$('px:Record/px:Field[not(@IsIdentity="1" or @formula)]').map((field) => {
                let field_name = field.get("Name");
                let new_value = row.get(field_name);
                let isPK = field.$(`ancestor::px:Entity[1]/px:PrimaryKeys/px:PrimaryKey[@Field_Name="${field_name}"]`)

                return `<field name="${field.get("Name")}"${isPK ? ` currentValue="'${row.get(`initial:${field.get("Name")}`) || row.get(field.get("Name"))}'" isPK="true"` : ''}>${[new_value].map(val => !val && 'null' || `'${val}'`)}</field>`
            }
            ).join('')
                }</updateRow></dataTable>`))
        }
        row.setAttribute("xmlns:session", "http://panax.io/session")
        payload = xover.xml.createDocument(`<x:post xmlns:x="http://panax.io/xover" xmlns:session="http://panax.io/session"><x:source>${row.toString()}</x:source><x:submit>${post.toString()}</x:submit></x:post>`);
        xover.server.submit(payload, { responseHandler: (return_value, request, response) => [return_value, request, response] })
            .then(([result, request]) => {
                if (result.$$('//result').every(r => r.get("status") == 'success')) {
                    if (entity.get("control:type").indexOf('form') != -1) {
                        entity.ownerDocument.store.remove();
                    } else {
                        entity.$$('//data:rows').remove()
                    }
                }
            }).catch(response => {
                try {
                    let [result] = response
                    let message = result.documentElement.$$(`//results/result[@status='error']`).map(r => r.get("statusMessage")).join('<br/>')
                    xo.dom.alert(message)
                } catch (e) {
                    xo.dom.alert(e)
                }
            })
    }
    //xo.server.post({
    //    body: body
    //})
}

xover.dom.navigateTo = function (hashtag, ref_id) {
    hashtag = (hashtag || "").replace(/^([^#])/, '#$1');
    if ([xover.state.seed, ...(xover.state.activeTags() || [])].includes(hashtag) || xover.stores[hashtag].isRendered) { //TODO: Revisar si isRendered siempre 
        xover.state.active = hashtag;
    } else {
        xover.state.next = hashtag;

        let public_hashtag = hashtag//Array.prototype.coalesce(public_hashtag || hashtag)
        var prev = (history.state["prev"] || [])
        prev.unshift({ store: xo.state.seed, id: ref_id })
        history.pushState({
            seed: hashtag
            //, active: hashtag
            , prev: prev
        }, ((event || {}).target || {}).textContent, public_hashtag);
    }
    xover.stores.active.render();
}
