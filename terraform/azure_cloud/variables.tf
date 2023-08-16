variable ansible_ssh_public_key_filename {
  type        = string
  description = "Location of ansible SSH public key file."
  default = "./tf-cloud-init.pub"
}

variable "resource_group_location" {
  description = "Location of the resource group."
  default     = "northeurope"
}


variable "resource_group_name" {
  description = "Name of the resource group."
  default     = "free_csgo_group"
}


variable "username" {
  description = "Name the admin user in the VM."
  default     = "ansible"
}
