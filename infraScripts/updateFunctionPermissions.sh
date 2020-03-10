#!/bin/bash
set -e

if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=$1
computeAccount=$2
gcloud alpha --project=${project} functions remove-iam-policy-binding getGraphql --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getGraphql --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding postGraphql --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding postGraphql --member ${computeAccount} --role "roles/cloudfunctions.invoker"
