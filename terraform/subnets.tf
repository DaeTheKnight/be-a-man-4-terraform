resource "google_compute_subnetwork" "subnet-1-johannesburg" {
  depends_on = [google_compute_network.vpc]
  name          = "subnet-1-johannesburg"
  ip_cidr_range = "10.214.10.0/24"
  region        = "africa-south1"
  network       = google_compute_network.vpc.id
}
resource "google_compute_subnetwork" "subnet-2-sao-paulo" {
  depends_on = [google_compute_network.vpc]
  name          = "subnet-2-sao-paulo"
  ip_cidr_range = "10.214.15.0/24"
  region        = "southamerica-east1"
  network       = google_compute_network.vpc.id
}
resource "google_compute_subnetwork" "subnet-3-iowa" {
  depends_on = [google_compute_network.vpc]
  name          = "subnet-3-iowa"
  ip_cidr_range = "10.214.20.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}
