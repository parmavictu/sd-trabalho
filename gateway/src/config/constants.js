const env = require('./environment/env');

const HEADERS = {
    authTokenKey: 'x-auth-token',
    contentTypeKey: 'Content-Type'
}

const ROUTES = {
    API_ROUTE: '/api/v1/user',
    HEALTH_ROUTE: '/health',
    BACKEND_ROUTE: env.getEnv('URL_BACKEND') || 'http://api-backend-trabalho-sd.io/api/v1/valid/user/',
    BACKEND_GO_ROUTE: env.getEnv('BACKEND_GO_ROUTE') || 'http://api-go-trabalho-sd-service:5000/api/v1/user'
}

module.exports = { HEADERS, ROUTES }