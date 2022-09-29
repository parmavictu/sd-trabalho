const logger = require('../../config/logger');
const { ROUTES } = require('./../../config/constants');
const uuid = require('uuidv4');

logger.info('[BaseController]: ' + ROUTES.API_ROUTE);

async function doRequest(req, res, next) {
    const id = req.params.id;
    const uuidList = uuid.uuid().split('-')
    const protocol = uuidList[0] + uuidList[1] + uuidList[3];
    logger.info(`[SUCESSO]: [ID]:   ${id}   ID validado com sucesso!`);
    return res.status(200).json({message: 'ID validado com sucesso!', id: id, protocol});
}

async function doHealth(req, res, next) {
    return res.status(200).json({status: 'UP'});
}

module.exports = { doRequest, doHealth }