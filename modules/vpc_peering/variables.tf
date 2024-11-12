variable "project_id" {
  description = "The ID of the project where the networks exist."
  type        = string
}

variable "peer_network_self_link1" {
  description = "Self link of the first network to peer."
  type        = string
}

variable "peer_network_self_link2" {
  description = "Self link of the second network to peer."
  type        = string
}

variable "peer_network_name_1" {
  description = "network 1 name"
  type        = string
}

variable "peer_network_name_2" {
  description = "network 2 name"
  type        = string
}
