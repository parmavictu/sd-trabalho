const app        = require('./config/express')();
const logger     = require('./config/logger')
const port       = app.get('port');

// RODANDO NOSSA APLICAÇÃO NA PORTA SETADA
app.listen(port, () => {
  logger.info(`Servidor rodando na porta ${port}`)
});