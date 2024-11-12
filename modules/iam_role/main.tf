resource "google_project_iam_member" "dns_admin" {
  project = var.project_id
  role    = var.role_name
  member  = "serviceAccount:${var.service_account_email}"
}
