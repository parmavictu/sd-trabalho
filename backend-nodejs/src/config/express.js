const express    = require('express');
const bodyParser = require('body-parser');
const errorHandler = require('./errorHandler');
const meddleware = require('./meddleware');
const env = require('./environment/env');
const { doRequest, doHealth } = require('../api/controllers/BaseController');
const constants = require('./constants');
const logger = require('./logger');

module.exports = () => {
  const app = express();

  // SETANDO VARIÁVEIS DA APLICAÇÃO
  app.set('port', process.env.PORT || env.getEnv('PORT'));

  logger.info('[ENV_SERVICE]: ' + process.env.ENV_SERVICE || env.getEnv('ENV_SERVICE'));
  logger.info('[ENV]: ' + process.env.NODE_ENV || env.getEnv('NODE_ENV'));

  // MIDDLEWARES
  app.use(bodyParser.json());

  app.use(meddleware);

  app.route(constants.ROUTES.API_ROUTE).get(doRequest);

  app.route(constants.ROUTES.HEALTH_ROUTE).get(doHealth);

  app.use(errorHandler);

  return app;
};