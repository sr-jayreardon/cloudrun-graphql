#!/bin/bash
if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=$1
region=$2
cloudRunApp=$3
service=$4
gcloud --project=${project} endpoints services deploy src/openapi-functions.yaml --quiet
gcloud beta  --project=${project} run services update ${service} --region ${region}1 --platform=managed --set-env-vars ENDPOINTS_SERVICE_NAME=${cloudRunApp} --quiet
