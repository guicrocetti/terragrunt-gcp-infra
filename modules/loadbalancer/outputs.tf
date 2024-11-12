output "loadbalancer_ip" {
  description = "IP address of the load balancer"
  value       = google_compute_address.loadbalancer.address
}
