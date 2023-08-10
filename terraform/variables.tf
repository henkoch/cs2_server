variable ansible_ssh_public_key_filename {
  type        = string
  description = "Location of ansible SSH public key file."
  default = "./tf-cloud-init.pub"
}

variable "csgo_client_access_password" {
  description = "Password clients use to connect to the server"
  default = "CheatersWillBeKicked"
}

variable "csgo_server_rcon_password" {
  description = "Password for accessing the rcon on the server"
  default = "SuperSecret"
}

variable "one_for_local_zero_for_global" {
  description = "0 = internet, 1 = LAN"
  default = "1"
}

variable "server_name" {
  description = "The name of the server displayed in the server browser"
  default = "You Really Need To Change This"
}

variable "steam_server_token" {
  description = "GSLT token to allow CSGO server to be listed in the public section of servers. https://steamcommunity.com/dev/managegameservers"
  default = "EMPTY"
}
