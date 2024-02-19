# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
data "template_file" "telemetry_user_data" {
  template = file("./telemetry_server-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key = file(var.ansible_ssh_public_key_filename)
    csgo_client_access_password = var.csgo_client_access_password
    server_name = var.server_name
  }
}

resource "libvirt_cloudinit_disk" "telemetry_cloudinit" {
  name      = "csgo_telemetry_cloudinit.iso"
  user_data = data.template_file.telemetry_user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "telemetry-qcow2" {
  name = "csgo_telemetry.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "telemetry-vm" {
  name   = "csgo_telemetry_vm"
  memory = "4096"
  vcpu   = 4

  cloudinit = libvirt_cloudinit_disk.telemetry_cloudinit.id

  network_interface {
    network_name = "default" # List networks with virsh net-list
    bridge = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.telemetry-qcow2.id}"
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

