output "record_set" {
  value     = google_dns_record_set.name.name
  sensitive = false
}
