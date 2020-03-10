// src/models/customers.js

class Customer {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll(filters) {
    let fetchUri = '/rest/customers';
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
    type Customer {
      prospectId: String
      serviceContractNumber: String
      name: String
      streetAddress: String
      regionCode: String
      countryCode: String
      postalCode: String
      latitude: String
      longitude: String
      utility: String
      creationDate: String!
      installationDate: String!
      PTODate: String!
      salesPartner: String!
      postSolarRate: String!
      systemSize: String
      numOfBatteries: Int
      numOfInverters: Int
      fund: String!
      utilityBillName: String!
      utilityBillStreetAddress: String!
      utilityBillAccountNumber: String!
      enrollments: [CustomerEnrollment]
      assets: [Asset]!
      created: String
      lastUpdated: String
    }

    type Query {
      customers(filters: [String!]): [Customer]
    }
  `;

  const customerModel = new Customer(restApi);
  
  const resolver = {
    programs: (args) => {
      const data = customerModel.getAll(args.filters);
      return data;
    },
  };

  return { typedef, resolver };
});
