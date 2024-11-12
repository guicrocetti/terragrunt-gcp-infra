variable "region" {
  description = "region for the network"
}

variable "network_name" {
  description = "network name"
  default     = "terraform-network"
}

variable "subnetwork_name" {
  description = "subnetwork name"
  default     = "terraform-subnetwork"
}

variable "cidr_range" {
  description = "subnetwork cidr range"
  default     = "10.0.0.0/16" //65536 IPs - 10.0.64.0 to 10.0.255.255.
}

variable "k8s_pod_range" {
  description = "k8s pod range"
  default     = "10.48.0.0/14" //262144 IPs - 10.48.0.0 to 10.51.255.255.
}

variable "k8s_service_range" {
  description = "k8s service range"
  default     = "10.52.0.0/20" //4096 IPs - 10.52.0.0 to 10.52.15.255.
}
