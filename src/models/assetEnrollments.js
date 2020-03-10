// src/model/assetEnrollments.js

class AssetEnrollment {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll(filters) {
    let fetchUri = '/rest/assetEnrollments';
    if (filters) {
      fetchUri += `?filters=${filters}`;
    }

    return this.restApi.get(fetchUri)
      .then((results) => {
        const { data } = results;
        return data;
      })
      .catch(() => { return []; });
  }
}

module.exports = ((restApi) => {
  const typedef = `
    type AssetEnrollment {
      assetId: String
      programId: String
      status: String
      created: String
      lastUpdated: String
    }

    type Query {
      assetEnrollments(filters: [String!]): [AssetEnrollment]
    }
  `;

  const assetEnrollmentModel = new AssetEnrollment(restApi);

  const resolver = {
    assetEnrollments: (args) => {
      const data = assetEnrollmentModel.getAll(args.filters);
      return data;
    }
  };

  return { typedef, resolver };
});
