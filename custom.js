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