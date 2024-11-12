output "instance_group_urls" {
  description = "List of instance group URLs for the cluster nodes"
  value       = google_container_node_pool.general.instance_group_urls
}

output "service_account_email" {
  description = "service account email used for the cluster nodes"
  value       = google_service_account.argocd-k8s.email
}

output "cluster_name" {
  description = "List of instance group URLs for the cluster nodes"
  value       = google_container_cluster.primary.name
}

output "cluster_server" {
  description = "endpoint of the cluster"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_data" {
  description = "Base64 encoded public certificate that is the root certificate of the cluster."
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive   = true
}
