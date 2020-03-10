terraform {
  //   required_version = "> 0.14.0"
  backend "gcs" {
    // use `terraform workspace select dev|stage|prd`
    // if you don't have them create via `terraform workspace new dev|stage|prd`
    bucket = "terraform-artefacts"
    prefix = "state/cloudrun-graphql"
  }
}
// Configure the Google Cloud provider

provider "google" {
  project = "${var.provider_projectId}"
  region  = "${var.provider_region}"
}


provider "google-beta" {
  project = "${var.provider_projectId}"
  region  = "${var.provider_region}"
}
