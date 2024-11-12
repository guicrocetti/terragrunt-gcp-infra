
variable "project_id" {}

variable "role_name" {
  description = "eg: roles/dns.admin"
  type        = string
}

variable "service_account_email" {
  description = "email of the service account that will be binded to the role"
}
