// src/models/customerEnrollments.js

class CustomerEnrollment {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll(filters) {
    let fetchUri = '/rest/customerEnrollments';
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
    type CustomerEnrollment {
      prospectId: String
      programId: String
      status: String
      created: String
      lastUpdated: String
    }

    type Query {
      enrollments(filters: [String!]): [CustomerEnrollment]
    }
  `;

  const customerEnrollmentModel = new CustomerEnrollment(restApi);

  const resolver = {
    customerEnrollments: (args) => {
      const data = CustomerEnrollment.getAll(args.filters);
      return data;
    }
  };

  return { typedef, resolver };
});
