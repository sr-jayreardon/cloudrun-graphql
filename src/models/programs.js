// src/models/programs.js

class Program {
  constructor(restApi) {
    this.restApi = restApi;
  }

  getAll(filters) {
    let fetchUri = '/rest/programs';
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
    type Program {
      id: String
      name: String
      status: Int
      utility: String
      regionCode: String
      countryCode: String
      targetServceLocations: String
      utilityDermsPartnerId: String!
      timezone: String
      startDate: String
      endDate: String
      details: String
      serviceType: String
      serviceGoalDetails: String!
      inverterFrequencyRegulation: String
      baselineCriteria: String!
      qualificationCriteria: String!
      priority: Int
      aggregationCompensationDetails: String!
      customerCompensationDetails: String!
      reportingCriteria: String
      created: String
      lastUpdated: String
      archivedOn: String!
    }

    type Query {
      programs(filters: [String!]): [Program]
    }
  `;

  const programModel = new Program(restApi);

  const resolver = {
    programs: (args) => {
      const data = programModel.getAll(args.filters);
      return data;
    },
  };

  return { typedef, resolver };
});
