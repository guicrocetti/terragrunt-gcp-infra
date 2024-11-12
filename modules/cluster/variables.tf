# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region in which to create the resources."
  type        = string
}

variable "zone" {
  type = string
}

variable "project_id" {
  description = "The ID of the project in which to create the resources."
  type        = string
}

variable "cluster_name" {
  type      = string
  sensitive = false
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "service_account" {
  type    = string
  default = "terraform-default-sa"
}

variable "node_count" {
  type        = number
  description = "number of nodes in the cluster"
  default     = 3
}

variable "machine_type" {
  description = "Node Instance machine type"
  default     = "n1-standard-2"
}

variable "node_label" {
  default = "terraform-node-pool"
}
