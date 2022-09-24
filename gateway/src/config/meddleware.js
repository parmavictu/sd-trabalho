const env = require('./environment/env');
const logger = require('./logger');
const {HEADERS} = require('./constants');

module.exports = (req, res, next) => {
  const { AuthTokenException } = require('../api/exceptions');
  let token = undefined;

  try {
    token = process.env.TOKEN_AUTH || env.getEnv('TOKEN_AUTH');
  } catch (error) {}

  if(!token) {
    const error = new AuthTokenException();
    logger.error(error.message);
    return res.status(error.status).json(error.model);
  } 

  logger.info('Inserindo token!');

  req.headers[ HEADERS.authTokenKey ] = token;
  req.headers[ HEADERS.contentTypeKey ] = 'application/json';

  return next();
}