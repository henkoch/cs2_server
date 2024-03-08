variable "resource_group_location" {
  description = "Location of the resource group."
  default     = "northeurope"
}


variable "username" {
  description = "Name the admin user in the VM."
  default     = "ubuntu"
}

variable ansible_ssh_public_key_filename {
  type        = string
  description = "Location of ansible SSH public key file."
  default = "./private_admin_id_rsa.pub"
}

variable "cs2_client_access_password" {
  description = "Password clients use to connect to the server"
  default = "CheatersWillBeKicked"
}

variable "cs2_server_rcon_password" {
  description = "Password for accessing the rcon on the server"
  default = "SuperSecret"
}

variable "cs2_one_for_local_zero_for_global" {
  description = "0 = internet, 1 = LAN"
  default = "0"
}

variable "cs2_server_name" {
  description = "The name of the server displayed in the server browser"
  default = "You-Really-Need-To-Change-This"
}

variable "cs2_steam_server_token" {
  description = "GSLT token to allow CS2 server to be listed in the public section of servers. https://steamcommunity.com/dev/managegameservers"
  default = "EMPTY"
}
