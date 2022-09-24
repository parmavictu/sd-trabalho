const logger = require('../../config/logger');

function AuthTokenException(apiError) {
    this.name = "AuthTokenException";
    this.message = 'Token não encontrado!';
    this.status = 500;
    this.model = {mensagem: this.message, code: 'ERR_500', apiError };
    logger.info(this);
}
AuthTokenException.prototype = Error.prototype;

module.exports = { AuthTokenException }