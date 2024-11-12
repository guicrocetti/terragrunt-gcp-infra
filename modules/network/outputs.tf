output "network_self_link" {
  description = "VPC Self-link"
  value       = google_compute_network.terraform-network.self_link
}

output "network_name" {
  description = "VPC Name"
  value       = google_compute_network.terraform-network.name
}

output "ip_cidr_range" {
  value = google_compute_subnetwork.private.ip_cidr_range
}

output "network_cidr_ranges" {
  description = "List of CIDR Blocks"
  value = compact([
    google_compute_subnetwork.private.ip_cidr_range,
    google_compute_subnetwork.private.secondary_ip_range[0].ip_cidr_range,
    google_compute_subnetwork.private.secondary_ip_range[1].ip_cidr_range
  ])
}
