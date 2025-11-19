
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
    network    = "default"
    access_config {} # Enables external   
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



# 💾 Save Private Key Locally
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key1.private_key_pem
  filename = "${path.module}/ubuntu_gui_key.pem"
}

