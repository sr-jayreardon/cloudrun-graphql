// src/models/index.js

const fs = require('fs');
const path = require('path');
const axios = require('axios');

const typedefs = [];
const resolvers = [];

const restApi = axios.create({
  baseURL: process.env.cloudrunUrl,
  headers: { 'x-api-key': process.env.apiKey },
});


/**
 * This iterates through all .js files (except this file) at load time and loads each
 * of the sets of typedef/resolvers.
 *
 * These are then passed back through a paired `require('./models')()` statement
 */

module.exports = (logger) => {
  logger.info('- Loading GraphQL models -');
  fs.readdirSync(__dirname)
    .filter((file) => {
      return file.substr(-3) === '.js' && file.indexOf('.') !== 0 && file !== 'index.js';
    })
    .forEach((file) => {
      try {
        const name = file.substr(0, file.indexOf('.'));
        logger.info(`-- ${name}`);
        const model = require(path.join(__dirname, file))(restApi);
        typedefs.push(model.typedef);
        resolvers.push(model.resolver);
      } catch (err) {
        // Prevent load errors from crashing
        logger.error(err);
      }
    });
  return { typedefs, resolvers };
};
