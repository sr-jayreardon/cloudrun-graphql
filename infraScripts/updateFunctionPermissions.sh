#!/bin/bash
set -e

if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=$1
computeAccount=$2
gcloud alpha --project=${project} functions remove-iam-policy-binding getAssets --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getAssets --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getAssetEnrollments --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getAssetEnrollments --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getCustomers --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getCustomers --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getCustomerEnrollments --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getCustomerEnrollments --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getPrograms --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getPrograms --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getUtilities --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getUtilities --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding verifyToken --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding verifyToken --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding getRoles --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding getRoles --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding echo --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding echo --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding healthcheck --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding healthcheck --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding agInventoryFetcher --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding agInventoryFetcher --member ${computeAccount} --role "roles/cloudfunctions.invoker"

gcloud alpha --project=${project} functions remove-iam-policy-binding agInventoryPusher --member allUsers --role "roles/cloudfunctions.invoker" || true
gcloud alpha --project=${project} functions add-iam-policy-binding agInventoryPusher --member ${computeAccount} --role "roles/cloudfunctions.invoker"
