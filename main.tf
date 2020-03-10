data "google_project" "project" {}

resource "google_storage_bucket" "code-deployment-bucket" {
  name = "${var.env_name}-${var.project_prefix}-deployment-bucket"
  depends_on = [
    "null_resource.enableServices"]
}

module "package-cloudfunction-source" {
  source = "git::git@github.com:SunRun/terraform-modules.git//gcp/cloudfunctions/packaging?ref=v1.0.3"
  packaging_deployment_bucket = "${google_storage_bucket.code-deployment-bucket.name}"
}

resource "null_resource" "enableServices" {
  provisioner "local-exec" {
    # command = "./infraScripts/enableServices.sh ${data.google_project.project.id}"
    command = "./infraScripts/enableServices.sh ${lookup(var.env_map[var.env_name], "project")}"
  }
}

#
# Cloudrun Graphql Functions Begin
#
resource "google_cloudfunctions_function" "getGraphql" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getGraphql"
  entry_point = "getGraphql"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "postGraphql" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "postGraphql"
  entry_point = "postGraphql"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}
#
# GS Cloudrun Functions End
#
