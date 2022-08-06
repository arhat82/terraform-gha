resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.custom-test.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_service_account" "default" {
  account_id   = "white-byway-349416"
  display_name = "Service Account"
}

resource "google_compute_instance" "instance-apigee-network" {
  name                      = "instance-apigee-netwthork"
  machine_type              = "e2-medium"
  zone                      = "europe-west2-a"
  allow_stopping_for_update = true

  tags = ["tuvieja", "entanga"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
  }
}
