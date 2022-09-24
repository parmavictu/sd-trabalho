const env = require('./environment/env');

const HEADERS = {
    authTokenKey: 'x-auth-token',
    contentTypeKey: 'Content-Type'
}

const ROUTES = {
    API_ROUTE: '/api/v1/user/:id',
    BACKEND_ROUTE: env.getEnv('URL_BACKEND') || 'http://api-backend-trabalho-sd.io/api/v1/valid/user/'
}

module.exports = { HEADERS, ROUTES }