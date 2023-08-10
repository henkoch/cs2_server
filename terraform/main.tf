# Configure the Libvirt provider

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest

# See: https://registry.terraform.io/providers/multani/libvirt/latest/docs

provider "libvirt" {
  uri = "qemu:///system"
}


# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf
data "template_file" "user_data" {
  template = file("./add-ssh-web-app.yaml")

  vars = {
    ansible_ssh_public_key = file(var.ansible_ssh_public_key_filename)
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "csgo_commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "csgo-qcow2" {
  name = "csgo.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "data-qcow2" {
  name = "csgo-data.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  format = "qcow2"
  size = 45097156608
}

# Define KVM domain to create
resource "libvirt_domain" "csgo-vm" {
  name   = "csgo_vm"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default" # List networks with virsh net-list
    bridge = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.csgo-qcow2.id}"
  }

  disk {
    volume_id = "${libvirt_volume.data-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}


# Output Server IP
output "ip" {
  value = "${libvirt_domain.csgo-vm.network_interface.0.addresses.0}"
}