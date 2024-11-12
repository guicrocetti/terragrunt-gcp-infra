

resource "google_secret_manager_secret" "cluster_secret_data" {
  secret_id = var.secret_name

  labels = {
    label = var.label
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "cluster_secret_data" {
  secret      = google_secret_manager_secret.cluster_secret_data.id
  secret_data = filebase64(var.secret_data)
}
