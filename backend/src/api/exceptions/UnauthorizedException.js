const logger = require('../../config/logger');

function UnauthorizedException(message) {
    this.name = "UnauthorizedException";
    this.message = message || 'Não autorizado!';
    this.status = 401;
    this.model = {mensagem: this.message, code: 'ERR_401' };
    logger.info(this);
}
UnauthorizedException.prototype = Error.prototype;

module.exports = { UnauthorizedException }