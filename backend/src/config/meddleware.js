const env = require('./environment/env');
const logger = require('./logger');
const {HEADERS} = require('./constants');

module.exports = (req, res, next) => {
  const { AuthTokenException } = require('../api/exceptions');

  
  let token = undefined;

  token = process.env.TOKEN_AUTH || env.getEnv('TOKEN_AUTH');

  if(!token || !req.headers[HEADERS.authTokenKey]) {
    throw new AuthTokenException();
  } else if (req.headers[HEADERS.authTokenKey] && token && req.headers[HEADERS.authTokenKey] !== token) {
    throw new AuthTokenException('Token inválido!');
  }

  logger.info('Solicitação para: ' + req.url);

  return next();
}

