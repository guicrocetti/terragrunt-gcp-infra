output "network_self_link" {
  value = data.google_compute_network.default.self_link
}

output "network_name" {
  value = data.google_compute_network.default.name
}

output "ip_cidr_range" {
  value = data.google_compute_subnetwork.default.ip_cidr_range
}

output "network_cidr_ranges" {
  value = compact([
    data.google_compute_subnetwork.default.ip_cidr_range
  ])
}
