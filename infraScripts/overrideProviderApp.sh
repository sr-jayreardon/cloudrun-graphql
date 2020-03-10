#!/bin/bash 
set -e
PROJECT=$1
SERVICENAME=$2
REGION=$3
currentJsonValue=$4

tempFileName="temp-package.json"
fileName="package.json"

REGION+=1
RUNURL=$(gcloud alpha --project=$PROJECT run services describe $SERVICENAME --region=$REGION --platform=managed --format=json | jq '.status.domain')

# Checking that the returned cloudruns contians the servicename
if [[ $RUNURL != *$SERVICENAME* ]]; then
  echo "$SERVICENAME not found in return gcloud's services describe status.domain exiting with error"
  exit 1
fi

# remove the https://
WORDTOREMOVE="https://"
FORMATTED_RUNURL="${RUNURL//$WORDTOREMOVE/}"

#remove the double quoutes'""' around the stirng
temp="${FORMATTED_RUNURL%\"}"
FORMATTED_RUNURL="${temp#\"}"

# Override whats currently in package.json's config.provider app with the value from gcloud 
sed "s/$currentJsonValue/$FORMATTED_RUNURL/g" ./$fileName | tee ./$tempFileName
rm ./$fileName
cp ./$tempFileName ./$fileName
rm ./$tempFileName