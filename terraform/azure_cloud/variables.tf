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

variable "csgo_client_access_password" {
  description = "Password clients use to connect to the server"
  default = "CheatersWillBeKicked"
}

variable "csgo_server_rcon_password" {
  description = "Password for accessing the rcon on the server"
  default = "SuperSecret"
}

variable "csgo_one_for_local_zero_for_global" {
  description = "0 = internet, 1 = LAN"
  default = "1"
}

variable "csgo_server_name" {
  description = "The name of the server displayed in the server browser"
  default = "You-Really-Need-To-Change-This"
}

variable "csgo_steam_server_token" {
  description = "GSLT token to allow CSGO server to be listed in the public section of servers. https://steamcommunity.com/dev/managegameservers"
  default = "EMPTY"
}
