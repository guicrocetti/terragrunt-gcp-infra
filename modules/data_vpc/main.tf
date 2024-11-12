data "google_compute_network" "default" {
  name    = var.vpc_name
  project = var.project_id
}

data "google_compute_subnetwork" "default" {
  name   = var.subnet_name
  region = var.region
}
