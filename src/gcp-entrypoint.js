// /src/gcp-entrypoint.js

const logger = require('@sunrun/structured-logging').createModuleLogger(module);
const graphqlHTTP = require('express-graphql');
const { buildSchema } = require('graphql');
const { mergeTypes, mergeResolvers } = require('merge-graphql-schemas');

const models = require('./models')(logger);
const mergedTypes = mergeTypes(models.typedefs, { all: true });
const schema = buildSchema(mergedTypes);
const mergedResolvers = mergeResolvers(models.resolvers);

const graphqlFunction = graphqlHTTP({
  schema: schema,
  rootValue: mergedResolvers,
  pretty: true,
  graphiql: process.env.graphiql || true,
});

function getGraphql(req, res) {
  return graphqlFunction(req, res);
}

function postGraphql(req, res) {
  return graphqlFunction(req, res);
}

module.exports = {
  getGraphql,
  postGraphql
};
