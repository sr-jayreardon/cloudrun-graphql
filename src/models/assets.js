// src/models/assets.js

class Asset {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll(filters) {
    let fetchUri = '/rest/assets';
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
    type Asset {
      id: String
      siteId: String
      prospectId: String
      inverterManufacturer: String
      inverterSerialNumber: String
      batteryManufacturer: String
      batterySerialNumber: String
      vendor: String
      vendorDERId: String
      firmwareVersion: String
      ratedPower: Int
      minStateOfCharge: Int
      maxStateOfCharge: Int
      remoteState: String
      assets: [Asset]!
      created: String
      lastUpdated: String
    }

    type Query {
      assets(filters: [String!]): [Asset]
    }
  `;

  const assetModel = new Asset(restApi);

  const resolver = {
    assets: (args) => {
      const data = assetModel.getAll(args.filters);
      return data;
    }
  };

  return { typedef, resolver };
});
