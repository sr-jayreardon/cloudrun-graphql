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

resource "google_redis_instance" "memoryStore" {
  memory_size_gb = 5
  tier = "STANDARD_HA"
  region = "${var.memorystore_region}"
  name = "${var.env_name}-memorystore-instance"
}

# resource "google_vpc_access_connector" "memoryStoreConnector" {
#   name = "memory-store-connector"
#   provider = "google-beta"
#   region = "${var.memorystore_region}"
#   ip_cidr_range = "10.8.0.0/28"
#   network = "default"
# }

#
# GS Processing PubSubs Begin
#
resource "google_pubsub_topic" "agStartFetch" {
  name = "agStartFetch"
}

resource "google_pubsub_subscription" "agStartFetch-sub" {
  name = "agStartFetch-sub"
  topic = "${google_pubsub_topic.agStartFetch.name}"
  ack_deadline_seconds = 10
  depends_on = ["google_pubsub_topic.agStartFetch"]
}

resource "google_pubsub_topic" "agCompleteFetch" {
  name = "agCompleteFetch"
}

resource "google_pubsub_subscription" "agCompleteFetch-sub" {
  name = "agCompleteFetch-sub"
  topic = "${google_pubsub_topic.agCompleteFetch.name}"
  ack_deadline_seconds = 10
  depends_on = ["google_pubsub_topic.agCompleteFetch"]
}

resource "google_pubsub_topic" "agInventoryPush" {
  name = "agInventoryPush"
}

resource "google_pubsub_subscription" "agInventoryPush-sub" {
  name = "agInventoryPush-sub"
  topic = "${google_pubsub_topic.agInventoryPush.name}"
  ack_deadline_seconds = 10
  depends_on = ["google_pubsub_topic.agInventoryPush"]
}


resource "google_pubsub_topic" "agCompletePush" {
  name = "agCompletePush"
}

resource "google_pubsub_subscription" "agCompletePush-sub" {
  name = "agCompletePush-sub"
  topic = "${google_pubsub_topic.agCompletePush.name}"
  ack_deadline_seconds = 10
  depends_on = ["google_pubsub_topic.agCompletePush"]
}

resource "google_pubsub_topic" "agCompleteInventoryDAG" {
  name = "agCompleteInventoryDAG"
}

resource "google_pubsub_subscription" "agCompleteInventoryDAG-sub" {
  name = "agCompleteInventoryDAG-sub"
  topic = "${google_pubsub_topic.agCompleteInventoryDAG.name}"
  ack_deadline_seconds = 10
  depends_on = ["google_pubsub_topic.agCompleteInventoryDAG"]
}
#
# GS Processing PubSubs End
#


#
# GS Processing Functions Begin
#
resource "google_cloudfunctions_function" "agInventoryFetcher" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "agInventoryFetcher"
  entry_point = "inventoryFetcher"
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  service_account_email = "${lookup(var.env_map[var.env_name], "dataPlatformSA")}"
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource = "agStartFetch"
  }
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${lookup(var.env_map[var.env_name], "envName")}"
    region = "${var.provider_region}1"
    project = "${var.provider_projectId}"
  }
}

resource "google_cloudfunctions_function" "agInventoryPusher" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "agInventoryPusher"
  entry_point = "inventoryPusher"
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  service_account_email = ""
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource = "agInventoryPush"
  }
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${lookup(var.env_map[var.env_name], "envName")}"
    region = "${var.provider_region}1"
    project = "${var.provider_projectId}"
  }
}

resource "google_cloudfunctions_function" "agLaunchPushDAG" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "agLaunchPushDAG"
  entry_point = "launchPushDAG"
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  service_account_email = "${lookup(var.env_map[var.env_name], "dataPlatformSA")}"
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource = "sitesBulkRegCompleted"
    project = "${lookup(var.env_map[var.env_name], "envName")}-data-platform"
  }
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${lookup(var.env_map[var.env_name], "envName")}"
    region = "${var.provider_region}1"
    project = "${var.provider_projectId}"
  }
}
#
# GS Processing Functions Begin
#


#
# GS Cloudrun Functions Begin
#
resource "google_cloudfunctions_function" "getPrograms" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getPrograms"
  entry_point = "getPrograms"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getUtilities" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getUtilities"
  entry_point = "getUtilities"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getCustomers" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getCustomers"
  entry_point = "getCustomers"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getCustomerEnrollments" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getCustomerEnrollments"
  entry_point = "getCustomerEnrollments"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getAssets" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getAssets"
  entry_point = "getAssets"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getAssetEnrollments" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getAssetEnrollments"
  entry_point = "getAssetEnrollments"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "getRoles" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "getRoles"
  entry_point = "getRoles"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "verifyToken" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "verifyToken"
  entry_point = "verifyToken"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "echo" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "echo"
  entry_point = "echo"
  trigger_http = true
  region = "${var.provider_region}1"
  runtime = "nodejs8"
  available_memory_mb = 2048
  timeout = 540
  environment_variables = {
    envName = "${var.env_name}",
  }
}

resource "google_cloudfunctions_function" "healthcheck" {
  source_archive_bucket = "${module.package-cloudfunction-source.deployment-bucket}"
  source_archive_object = "${module.package-cloudfunction-source.source_archive}"
  name = "healthcheck"
  entry_point = "healthcheck"
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
