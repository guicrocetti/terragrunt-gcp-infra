# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "cloudamqp_instance_name" {
  description = "CloudAMQP instance name"
  type        = string
}

variable "region" {
  description = "CloudAMQP region"
  type        = string
}

variable "vpc_id" {
  description = "CloudAMQP VPC_ID"
  type        = string
}

variable "network_self_link" {
  description = "Google Compute Network self_link"
  type        = string
}

variable "cloudamqp_apikey" {
  description = "privet cloudamqp apikey"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "cloudamqp_plan" {
  description = "CloudAMQP plan name"
  type        = string
  default     = "squirrel-1"
}
