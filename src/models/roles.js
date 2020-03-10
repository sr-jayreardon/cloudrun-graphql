// src/models/roles.js

class Roles {
  constructor(restApi) {
    this.restApi = restApi;
  }

  get(accessToken) {
    return this.restApi.get(`/rest/okta/roles?accessToken=${accessToken}`)
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
      roles(accessToken: String): [String]
    }
  `;

  const roleModel = new Roles(restApi);

  const resolver = {
    roles: (args) => {
      const data = roleModel.get(args.accessToken);
      return data;
    }
  };

  return { typedef, resolver };
});
