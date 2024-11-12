variable "secret_name" {}

variable "secret_data" {
  description = "file secret path"
  type        = string
}

variable "label" {
  description = "secret manager label"
  type        = string
  default     = "cluster_secret_data"
}
