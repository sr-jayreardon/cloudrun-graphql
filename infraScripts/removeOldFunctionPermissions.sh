#!/bin/bash
set -e

if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=dev-gs-platform
computeAccount=571674742228-compute@developer.gserviceaccount.com
gcloud --project=${project} functions remove-iam-policy-binding getAssets --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getAssetEnrollments --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getCustomers --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getCustomerEnrollments --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getPrograms --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getUtilities --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding verifyToken --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding getRoles --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding echo --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding healthcheck --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding agInventoryFetcher --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true

gcloud --project=${project} functions remove-iam-policy-binding agInventoryPusher --member ${computeAccount} --role "roles/cloudfunctions.invoker" || true