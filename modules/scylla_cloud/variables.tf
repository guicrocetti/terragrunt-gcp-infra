# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Name of the ScyllaDB cluster."
  type        = string
}

variable "region" {
  description = "GCP region where the resources will be created."
  type        = string
}

variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "network_self_link" {
  description = "Self-link of the GCP network to peer with."
  type        = string
}

variable "network_name" { #
  description = "GCP network name"
  type        = string
}

variable "network_cidr_ranges" {
  description = "list of GCP network cidr ranges"
  type        = list(string)
}

variable "ip_cidr_range" {
  description = "primary IP cidr range"
  type        = string
}

variable "scylla_token" {
  type      = string
  sensitive = true
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------


variable "scylla_nodes" {
  description = "Number of nodes in the ScyllaDB cluster."
  type        = number
  default     = 3
}

variable "scylla_node_type" {
  description = "Node type for the ScyllaDB cluster."
  type        = string
  default     = "n2-highmem-2"
}

variable "scylla_cidr_block" {
  description = "CIDR block of the ScyllaDB network."
  type        = string
  default     = "172.31.0.0/16"
}
