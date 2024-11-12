# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.1"

  required_providers {
    scylladbcloud = {
      source  = "registry.terraform.io/scylladb/scylladbcloud"
      version = "~> 1.8"
    }
  }
}

provider "scylladbcloud" {
  token = var.scylla_token
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SCYLLA_CLOUD INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

# Create a new cluster
resource "scylladbcloud_cluster" "scylla_0" {
  name       = var.name
  cloud      = "GCP"
  region     = var.region
  node_count = var.scylla_nodes
  node_type  = var.scylla_node_type
  cidr_block = var.scylla_cidr_block

  enable_vpc_peering = true
  enable_dns         = true
}

# Fetch credential information for cluster
data "scylladbcloud_cql_auth" "scylla_0" {
  cluster_id = scylladbcloud_cluster.scylla_0.id
  depends_on = [scylladbcloud_cluster.scylla_0]
}

resource "scylladbcloud_vpc_peering" "scylla_0" {
  cluster_id = data.scylladbcloud_cql_auth.scylla_0.cluster_id
  datacenter = data.scylladbcloud_cql_auth.scylla_0.datacenter

  peer_vpc_id     = var.network_name
  peer_region     = var.region
  peer_account_id = var.project_id

  peer_cidr_blocks = var.network_cidr_ranges

  allow_cql = true
}

resource "google_compute_network_peering" "scylla_0" {
  name         = "${var.name}-peering-${var.network_name}"
  network      = var.network_self_link
  peer_network = scylladbcloud_vpc_peering.scylla_0.network_link
}

resource "scylladbcloud_allowlist_rule" "scylla_0" {
  cluster_id = data.scylladbcloud_cql_auth.scylla_0.cluster_id
  cidr_block = var.ip_cidr_range
  depends_on = [scylladbcloud_vpc_peering.scylla_0]
}
