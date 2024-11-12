output "instance_group_urls" {
  description = "List of instance group URLs for the cluster nodes"
  value       = google_container_node_pool.general.instance_group_urls
}

output "cluster_name" {
  description = "List of instance group URLs for the cluster nodes"
  value       = google_container_cluster.primary.name
}

output "service_account_email" {
  description = "service account email used for the cluster nodes"
  value       = google_service_account.argocd-k8s.email
}
