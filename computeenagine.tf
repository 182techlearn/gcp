
resource "google_compute_instance" "debian_machine" {
  name         = "debian2"
  machine_type = "e2-micro" # Free-tier eligible
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Lightweight and free-tier eligible
    }
  }

  network_interface {
    network = "default"
    access_config {} # Enables external IP
  }

  tags = ["low-cost"]

  metadata = {
    startup-script = "echo Hello, world! > /var/log/startup-script.log"
  }
  labels = {
    name = "terraform_learning"
    env  = "training"
  }

}


######### Machine 2 #########

# 🔑 Generate SSH Key Pair
resource "tls_private_key" "ssh_key1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


# 🌐 Create VPC Network
resource "google_compute_network" "vpc" {
  name                    = "ubuntu-gui-network"
  auto_create_subnetworks = true
}

# 🔥 Create Firewall Rule to Allow Ports 22–9000
resource "google_compute_firewall" "allow_ports" {
  name    = "allow-ssh-nginx"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "9000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 💾 Save Private Key Locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key1.private_key_pem
  filename = "${path.module}/ubuntu_gui_key.pem"
}

