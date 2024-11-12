resource "google_compute_network_peering" "peer1" {
  name         = "${var.peer_network_name_1}-to-${var.peer_network_name_2}"
  network      = var.peer_network_self_link1
  peer_network = var.peer_network_self_link2
}

resource "google_compute_network_peering" "peer2" {
  name         = "${var.peer_network_name_2}-to-${var.peer_network_name_1}"
  network      = var.peer_network_self_link2
  peer_network = var.peer_network_self_link1
}
