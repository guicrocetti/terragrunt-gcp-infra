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
  validation {
    condition     = var.node_count > 0
    error_message = "This application requires at least one node"
  }
}

variable "machine_type" {
  description = "Node Instance machine type"
  default     = "n1-standard-2"
}

variable "node_label" {
  default = "terraform-node-pool"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_\\.]*[a-zA-Z0-9]$", var.resource_name))
    error_message = "Resource name must start and end with an alphanumeric character and contain only alphanumeric characters, dashes, underscores, and dots."
  }
}
