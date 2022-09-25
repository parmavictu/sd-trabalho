module.exports = (error, req, res, next) => {
  const { UnexpectedException } = require('../api/exceptions');
  const logger = require('./logger');

  if(!error.model) {
    error = new UnexpectedException(error.stack);
    logger.error(`\nCausa:\n${error.stack}`);
  }
  
  logger.error(`\n[Falhou]: para endpoint [${req.method}]:${req.path}, com erro: ${JSON.stringify(error.model)}`);

  return res.status(error.status).send(error.model);
}