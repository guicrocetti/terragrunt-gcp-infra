resource "google_compute_address" "loadbalancer" {
  name         = var.lb_name
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.region
}
