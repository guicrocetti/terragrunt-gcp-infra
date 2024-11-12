# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
#TODO: trace all firewall policies needed for this project
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.terraform-network.name #TODO: check how to reference this on module level

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_network.terraform-network] #TODO: check how to reference this on module level
}


resource "google_compute_firewall" "allow_scylla_traffic" {
  name    = "allow-scylla-traffic"
  network = google_compute_network.terraform-network.name #TODO: check how to reference this on module level

  allow {
    protocol = "tcp"
    ports    = ["9042", "9100", "9180"]
  }

  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["10.48.0.0/14"]
  target_tags   = ["scylla-vm"]

  description = "Allow incoming Scylla traffic from GKE pods"
}
