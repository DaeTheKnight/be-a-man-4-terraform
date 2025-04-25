provider "google" {
  project = var.project
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com"
  ])

  project = var.project
  service = each.key
  disable_on_destroy  = false
}
