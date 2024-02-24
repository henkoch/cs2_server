# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf
# https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/
data "template_file" "user_data" {
  template = file("./game_server-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key = file(var.ansible_ssh_public_key_filename)
    csgo_client_access_password = var.csgo_client_access_password
    csgo_server_rcon_password = var.csgo_server_rcon_password
    one_for_local_zero_for_global = var.one_for_local_zero_for_global
    vm_hostname = "csgame"
    steam_server_token = var.steam_server_token
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "csgo_server_commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "csgo-qcow2" {
  name = "csgo_server-root.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "csgo-data-qcow2" {
  name = "csgo_server-data.qcow2"
  pool = "default" # List storage pools using virsh pool-list
  format = "qcow2"
  size = 45097156608
}

# Define KVM domain to create
resource "libvirt_domain" "csgo-vm" {
  name   = "csgo_game_vm"
  memory = "4096"
  vcpu   = 4

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
    volume_id = "${libvirt_volume.csgo-data-qcow2.id}"
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

