provider "google" {
  project = "extreme-cycling-463901-b3"
  region  = "us-central1"
  zone    = "us-central1-a"
}
# 1. Red VPC
resource "google_compute_network" "vpc_network" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
}
# 2. Subred personalizada
resource "google_compute_subnetwork" "subnet" {
  name          = "demo-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}
# 3. Reglas de firewall (solo SSH desde tu IP)
resource "google_compute_firewall" "ssh_rule" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["34.121.131.147/32"]
}
# 4. Instancia e2-micro Debian
resource "google_compute_instance" "vm_instance" {
  name         = "demo-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
  metadata = {
    ssh-keys = "usuario:${file(".ssh/id_rsa.pub")}"
  }
}
