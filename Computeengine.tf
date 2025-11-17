
resource "google_compute_instance" "debian_machine" {
  name         = "debian1"
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
    Name        = "Terraform_Learning"
    Environment = "training"
  }

}


######### Machine 2 #########

# 🔑 Generate SSH Key Pair
resource "tls_private_key" "ssh_key1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# 📦 Get Latest Ubuntu Image with GUI Support
data "google_compute_image" "ubuntu_gui" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
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

# 🖥️ Create Ubuntu GUI VM
resource "google_compute_instance" "ubuntu_gui" {
  name         = "ubuntu-gui-vm"
  machine_type = "e2-medium"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_gui.self_link
      size  = 30
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {} # Enables external IP
  }

  metadata = {
    ssh-keys       = "ubuntu:${tls_private_key.ssh_key1.public_key_openssh}"
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop
      apt-get install -y nginx
      systemctl enable nginx
      systemctl start nginx
    EOF
  }

  tags = ["ubuntu-gui"]
}

# 💾 Save Private Key Locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key1.private_key_pem
  filename = "${path.module}/ubuntu_gui_key.pem"
}
