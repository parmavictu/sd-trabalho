const logger = require('./../../config/logger');

function UnauthorizedException(apiError) {
    this.name = "UnauthorizedException";
    this.message = 'Não autorizado!';
    this.status = 401;
    this.model = {mensagem: this.message, code: 'ERR_401', apiError };
    logger.info(this);
}
UnauthorizedException.prototype = Error.prototype;

module.exports = { UnauthorizedException }