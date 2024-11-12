data "google_dns_managed_zone" "env_dns_zone" {
  name    = var.dns_zone
  project = var.project_id
}

resource "google_dns_record_set" "name" {
  name         = "${var.sub_domain}.${var.dns_name}."
  type         = "A"
  ttl          = var.ttl
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name
  rrdatas      = [var.loadbalancer_address]
}
