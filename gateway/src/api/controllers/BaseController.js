const fetch = require('node-fetch');
const logger = require('./../../config/logger');
const { HEADERS, ROUTES } = require('./../../config/constants');
const { AuthTokenException, UnauthorizedException } = require('./../exceptions');

var os = require("os");
var hostname = os.hostname();

logger.info('[BaseController]: ' + ROUTES.API_ROUTE);

async function doRequest(req, res, next) {
    const id = req.params.id;

    const url = ROUTES.BACKEND_ROUTE + id;

    logger.info('Chamando api: ' + url);

    const token = req.headers[HEADERS.authTokenKey];

    if (!token) {
        const error = new AuthTokenException();
        logger.error(error.message);
        return res.status(error.status).json(error.model);
    }

    return await fetch(url, {
        method: 'GET',
        headers: {
            [HEADERS.authTokenKey]: token 
        }
    }).then(response => {
            response.json().then(data => {
                
                if (response.status != 200) {
                    throw new UnauthorizedException(data)
                }

                const parsResponse = { data, service: hostname }

                logger.info(`[SUCESSO: [ID]:  ${id}    ${JSON.stringify(parsResponse)}`);

                return res.status(response.status).send(parsResponse);
            }).catch((err) => next(err));
        }).catch((err) => next(err));
}

module.exports = { doRequest }