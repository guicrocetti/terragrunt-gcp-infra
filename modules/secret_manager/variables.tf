variable "secret_name" {
  type    = string
  default = "default_cluster_secret_data"
}

variable "cluster_name" { type = string }
variable "cluster_server" { type = string }
variable "cluster_ca_data" { type = string }

variable "label" {
  description = "secret manager label"
  type        = string
  default     = "cluster_secret_data"
}
