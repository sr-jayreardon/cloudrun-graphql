// src/models/utilities.js

class Utility {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll() {
    return this.restApi.get('/rest/utilities')
      .then((results) => {
        const { data } = results;
        return data;
      })
      .catch(() => { return []; });
  }
}

module.exports = ((restApi) => {
  const typedef = `
    type Query {
      utilities: [String]
    }
  `;

  const utilityModel = new Utility(restApi);

  const resolver = {
    utilities: () => {
      const data = utilityModel.getAll();
      return data;
    },
  };

  return { typedef, resolver };
});
