data "google_compute_zones" "johannesburg" {
  region = "africa-south1"
}

data "google_compute_zones" "sao-paulo" {
  region = "southamerica-east1"
}

data "google_compute_zones" "iowa" {
  region = "us-central1"
}

resource "google_compute_instance" "instance-1-johannesburg" {
  depends_on = [google_compute_network.vpc]
  name         = "instance-1-johannesburg"
  machine_type = "e2-medium"
  zone         = data.google_compute_zones.johannesburg.names[0]

  tags = ["http-server-1"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      }
    }
    metadata_startup_script = file("be-a-man-4-webpage.sh")

      network_interface {
    network = var.vpc
    subnetwork = google_compute_subnetwork.subnet-1-johannesburg.id
    access_config {
        }
  }

   service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
  }

resource "google_compute_instance" "instance-2-sao-paulo-1" {
  depends_on = [google_compute_network.vpc]
  name         = "instance-2-sao-paulo-1"
  machine_type = "e2-medium"
  zone         = data.google_compute_zones.sao-paulo.names[0]

  tags = ["http-server-2"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      }
    }

    metadata_startup_script = file("crystal-shine.sh")

      network_interface {
    network = var.vpc
    subnetwork = google_compute_subnetwork.subnet-2-sao-paulo.id
    access_config {
        }
  }
  }

resource "google_compute_instance" "instance-2-sao-paulo-2" {
  depends_on = [google_compute_network.vpc]
  name         = "instance-2-sao-paulo-2"
  machine_type = "n2-standard-2"
  zone         = data.google_compute_zones.sao-paulo.names[0]

  tags = ["windows-server-2"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
      }
    }
      network_interface {
    network = var.vpc
    subnetwork = google_compute_subnetwork.subnet-2-sao-paulo.id
    access_config {
      # this grants an ephemeral public ip automatically
        }
  }
   service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
  }

resource "google_compute_instance" "instance-3-iowa-1" {
  depends_on = [google_compute_network.vpc]
  name         = "instance-3-iowa-1"
  machine_type = "e2-medium"
  zone         = data.google_compute_zones.iowa.names[0]

  tags = ["http-server-3"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      }
    }

    metadata_startup_script = file("larrygeddon-webpage.sh")

      network_interface {
    network = var.vpc
    subnetwork = google_compute_subnetwork.subnet-3-iowa.id
    access_config {
        }
  }
  }

resource "google_compute_instance" "instance-3-iowa-2" {
  depends_on = [google_compute_network.vpc]
  name         = "instance-3-iowa-2"
  machine_type = "n2-standard-2"
  zone         = data.google_compute_zones.iowa.names[0]

  tags = ["windows-server-3"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
      }
    }
      network_interface {
    network = var.vpc
    subnetwork = google_compute_subnetwork.subnet-3-iowa.id
    access_config {
      # you already know what this does! why did you put a note here?!?!
        }
  }
   service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
  }
