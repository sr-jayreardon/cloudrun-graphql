#!/bin/bash
if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id"
    exit -1
fi
project=$1
region=$2
service=$3

gcloud --project=${project} services enable run.googleapis.com
gcloud beta --project=${project} run deploy ${service} --region ${region}1 --platform=managed --image="gcr.io/endpoints-release/endpoints-runtime-serverless:1.30.0" --allow-unauthenticated --quiet
