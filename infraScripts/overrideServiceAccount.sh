#!/bin/bash 
set -e
PROJECT=$1
currentJsonValue=$2

tempFileName="temp-package.json"
fileName="package.json"

REGION+=1
computeSA=$(gcloud --project=$PROJECT iam service-accounts list --filter="displayName='Compute Engine default service account'" --format=json | jq .[0].email)

if [[ $computeSA != *"-compute@developer.gserviceaccount.com"* ]]; then
  echo "-compute@developer.gserviceaccount.com not found in gcloud's gcloud iam service-accounts list exiting with error"
  exit 1
fi

#remove the double quoutes'""' around the stirng
temp="${computeSA%\"}"
computeSA="${temp#\"}"
echo $computeSA

# Override whats currently in package.json's config.provider_computeAccount app with the value from gcloud 
sed "s/$currentJsonValue/serviceAccount:$computeSA/g" ./$fileName | tee ./$tempFileName
rm ./$fileName
cp ./$tempFileName ./$fileName
rm ./$tempFileName