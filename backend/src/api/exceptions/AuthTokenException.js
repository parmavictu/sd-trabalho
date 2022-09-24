const logger = require('../../config/logger');

function AuthTokenException(message) {
    this.name = "AuthTokenException";
    this.message = message || 'Token não encontrado!';
    this.status = 500;
    this.model = {message: this.message, code: 'ERR_500' };
    logger.info(this);
}
AuthTokenException.prototype = Error.prototype;

module.exports = { AuthTokenException }