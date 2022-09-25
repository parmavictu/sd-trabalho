const {UnexpectedException} = require('./UnexpectedException');
const {UnauthorizedException} = require('./UnauthorizedException');
const {AuthTokenException} = require('./AuthTokenException');

const index = {
  UnexpectedException,
  UnauthorizedException,
  AuthTokenException
}

module.exports = index;