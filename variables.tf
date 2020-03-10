variable "provider_projectId" {
  type = "string"
  description = "the gcp project you want to deploy into"
}

variable "provider_region" {
  type = "string"
  description = "the region in gcp you want to deploy into"
  default = "us-central"
}
 
variable "memorystore_region" {
  type = "string"
  description = "the region of the memory store"
  default = "us-central1"
}

variable "env_name" {
  type = "string"
  description = "the logical environment name, e.g. prd, relcert, majstg, devmaj, dev, training"
  default = "devmaj"
}

variable "project_prefix" {
  type = "string"
  description = "the logical environment name, e.g. prd, relcert, majstg, devmaj, dev, training"
  default = "cloudrun-graphql"
}

variable "repo" {
  type = "string"
  description = "this should match your repo name potentially"
  default = "cloudrun-graphql"
}

variable "env_map" {
  type = "map"
  default = {
    dev = {
      envName = "dev",
      project=""
      namespace="",
      enbalaEnabled="",
      dataPlatformSA=""
    }
    dev2 = {
      envName = "dev2",
      project="d"
      namespace="",
      enbalaEnabled="",
      dataPlatformSA=""
    }
    stage = {
      envName = "stage",
      project="",
      namespace="",
      enbalaEnabled="",
      dataPlatformSA=""
    }
    prd = {
      envName = "prd",
      project="",
      namespace="",
      enbalaEnabled="",
      dataPlatformSA=""
    }
  }
}
