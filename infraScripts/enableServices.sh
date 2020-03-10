#!/bin/bash
if [[ $# -eq 0 ]]
  then
    echo "Please provide the project id as the first parameter"
    exit -1
fi
project=$1
gcloud --project=${project} services enable serviceusage.googleapis.com
gcloud --project=${project} services enable storage-api.googleapis.com
gcloud --project=${project} services enable cloudresourcemanager.googleapis.com
gcloud --project=${project} services enable cloudbilling.googleapis.com
gcloud --project=${project} services enable compute.googleapis.com
gcloud --project=${project} services enable cloudfunctions.googleapis.com
gcloud --project=${project} services enable appengine.googleapis.com
gcloud --project=${project} services enable pubsub.googleapis.com
gcloud --project=${project} services enable dataflow.googleapis.com
gcloud --project=${project} services enable servicemanagement.googleapis.com
gcloud --project=${project} services enable datastore.googleapis.com
gcloud --project=${project} services enable bigquery-json.googleapis.com
gcloud --project=${project} services enable composer.googleapis.com
gcloud --project=${project} services enable iam.googleapis.com
gcloud --project=${project} services enable bigtableadmin.googleapis.com
gcloud --project=${project} services enable sheets.googleapis.com
gcloud --project=${project} services enable cloudtasks.googleapis.com
gcloud --project=${project} services enable cloudscheduler.googleapis.com
gcloud --project=${project} services enable run.googleapis.com
