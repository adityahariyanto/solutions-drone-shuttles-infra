resource "google_compute_firewall" "allow-http" {
  name    = "${var.network}-allow-http"
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}