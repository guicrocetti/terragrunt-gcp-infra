output "secret_key" {
  value     = google_secret_manager_secret_version.cluster_secret_data.secret
  sensitive = true
}

output "secret_key_id" {
  value     = google_secret_manager_secret_version.cluster_secret_data.id
  sensitive = false
}

output "secret_key_data" {
  value     = google_secret_manager_secret_version.cluster_secret_data.secret_data
  sensitive = true
}
