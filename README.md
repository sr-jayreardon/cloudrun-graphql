# cloudrun-graphql
Example of running graphql inside a cloudfunction

## `/src/openapi-functions.yaml`
This file contains two endpoints:
* GET  /graphql
* POST /graphql

Both endpoints ultimately resolve to the same logic inside of `gcp-entrypoints.js`. You will need to change the `host` and each endpoint `x-google-backend.address` to match your project in GCP.

## `/src/gcp-entrypoints.js`
This file uses the `express-graphql` module to wrap the request / response objects for graphql that CloudFunctions provide. All typedefs for each of the graphql resolvers are dynamically loaded at coldstart from the `/src/models` folder, merged, and then passed into graphql.

## `/src/models/index.js`
This is built as a BFF endpoint which connects to REST API endpoints. This is responsible for dynamically loading each of the model files in `/src/models/*.js`. Each module returns an object containing the following:
```
{
  typedef: {graphql typedef string},
  resolvers: {object containing resolver functions}
}
```


