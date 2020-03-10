TF_VAR_env_name=$1
TF_VAR_domain=$2 
TF_VAR_provider_projectId=$3
TF_VAR_provider_region=$4

terraform import google_storage_bucket.code-deployment-bucket dev-gs-cloudrun-cf-deployment-bucket

