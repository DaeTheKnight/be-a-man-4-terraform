resource "google_compute_firewall" "allow-80-from-windows-to-johannesburg" {
  depends_on = [google_compute_network.vpc]
  name    = "allow-80-from-windows-to-johannesburg"
  network = var.vpc

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["windows-server-2", "windows-server-3"]
  target_tags   = ["http-server-1"]
}

resource "google_compute_firewall" "allow-3389-from-anywhere-to-windows" {
  depends_on = [google_compute_network.vpc]
  name    = "allow-3389-from-anywhere-to-windows"
  network = var.vpc

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["windows-server-2", "windows-server-3"]
}

resource "google_compute_firewall" "allow-80-from-windows-to-sao-paulo" {
  depends_on = [google_compute_network.vpc]
  name    = "allow-80-from-windows-to-sao-paulo"
  network = var.vpc

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["windows-server-2"]
  target_tags   = ["http-server-2"]
}

resource "google_compute_firewall" "allow-80-from-windows-to-iowa" {
  depends_on = [google_compute_network.vpc]
  name    = "allow-80-from-windows-to-iowa"
  network = var.vpc

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["windows-server-3"]
  target_tags   = ["http-server-3"]
}
