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

variable "subnet" {
  description = "CloudAMQP subnet"
  type        = string
  default     = "10.56.72.0/24"
}
