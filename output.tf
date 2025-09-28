output "instance_ip" {
    description = "IP externa de la vm"
    value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

