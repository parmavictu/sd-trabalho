const fetch = require('node-fetch');
const logger = require('./../../config/logger');
const { HEADERS, ROUTES } = require('./../../config/constants');
const { AuthTokenException, UnauthorizedException } = require('./../exceptions');

var os = require("os");
var hostname = os.hostname();

logger.info('[BaseController]: ' + ROUTES.BACKEND_GO_ROUTE);

async function doRequest(req, res, next) {
    const url = ROUTES.BACKEND_GO_ROUTE;

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

                logger.info(`[SUCESSO: [ID]:  ${JSON.stringify(parsResponse)}`);

                return res.status(response.status).send(parsResponse);
            }).catch((err) => next(err));
        }).catch((err) => next(err));
}

async function doHealth(req, res, next) {
    return res.status(200).json({status: 'UP'});
}

module.exports = { doRequest, doHealth }