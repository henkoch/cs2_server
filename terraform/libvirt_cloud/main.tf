# Configure the Libvirt provider

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest

# See: https://registry.terraform.io/providers/multani/libvirt/latest/docs

provider "libvirt" {
  uri = "qemu+ssh://vmadm@homelab1/system"
}



# Output Server IP
#output "ip" {
#  value = "${libvirt_domain.csgo-vm.network_interface.0.addresses.0}"
#}
