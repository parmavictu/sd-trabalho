const winston = require('winston');
var os = require("os");
var hostname = os.hostname();

const myformat = winston.format.combine(
  winston.format.colorize(),
  winston.format.timestamp(),
  winston.format.align(),
  winston.format.printf(info => `${info.timestamp} ${info.level}: [${hostname}] ${info.message}`)
);

const logger = winston.createLogger({
    transports: [
        new winston.transports.Console({
            format: myformat
        })
    ]
});

logger.info('Information message');

module.exports = logger