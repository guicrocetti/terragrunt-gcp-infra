# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.1"

  required_providers {
    cloudamqp = {
      source  = "cloudamqp/cloudamqp"
      version = "~> 1.32"
    }
  }
}

provider "cloudamqp" {
  apikey = var.cloudamqp_apikey
}

# ---------------------------------------------------------------------------------------------------------------------
# SETUP THE CLOUD NETWORK
# ---------------------------------------------------------------------------------------------------------------------

resource "cloudamqp_vpc" "vpc" {
  name   = "${var.cloudamqp_instance_name}-vpc"
  region = "google-compute-engine::${var.region}"
  subnet = var.subnet
  tags   = []
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE CLOUD_AMQP INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "cloudamqp_instance" "instance" {
  name   = var.cloudamqp_instance_name
  plan   = var.cloudamqp_plan
  region = "google-compute-engine::${var.region}"
  tags   = ["terraform"]
  vpc_id = cloudamqp_vpc.vpc.id
}

# ---------------------------------------------------------------------------------------------------------------------
# PEERING THE CLOUD_AMQP INSTANCE WITH GCP NETWORK
# ---------------------------------------------------------------------------------------------------------------------

resource "cloudamqp_vpc_gcp_peering" "vpc_peering_request" {
  vpc_id           = cloudamqp_vpc.vpc.id
  peer_network_uri = var.network_self_link
}

data "cloudamqp_vpc_gcp_info" "vpc_info" {
  vpc_id = cloudamqp_vpc.vpc.id
}

resource "google_compute_network_peering" "peering1" {
  name         = "${var.cloudamqp_instance_name}-peering-gcp"
  network      = var.network_self_link
  peer_network = data.cloudamqp_vpc_gcp_info.vpc_info.network

  depends_on = [
    cloudamqp_vpc_gcp_peering.vpc_peering_request
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# EXPOSE CLOUD_AMQP INSTANCE DATA FOR OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

data "cloudamqp_credentials" "credentials" {
  instance_id = cloudamqp_instance.instance.id
}

data "cloudamqp_instance" "instance" {
  instance_id = cloudamqp_instance.instance.id
}
