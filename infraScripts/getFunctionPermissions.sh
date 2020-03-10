#!/bin/bash
set -e

if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=dev-gs-platform
computeAccount=571674742228-compute@developer.gserviceaccount.com
gcloud --project=${project} functions get-iam-policy getAssets

gcloud --project=${project} functions get-iam-policy getAssetEnrollments

gcloud --project=${project} functions get-iam-policy getCustomers

gcloud --project=${project} functions get-iam-policy getCustomerEnrollments

gcloud --project=${project} functions get-iam-policy getPrograms

gcloud --project=${project} functions get-iam-policy getUtilities

gcloud --project=${project} functions get-iam-policy verifyToken

gcloud --project=${project} functions get-iam-policy getRoles

gcloud --project=${project} functions get-iam-policy echo

gcloud --project=${project} functions get-iam-policy healthcheck

gcloud --project=${project} functions get-iam-policy agInventoryFetcher

gcloud --project=${project} functions get-iam-policy agInventoryPusher