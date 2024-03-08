# https://developer.hashicorp.com/terraform/language/values/outputs

# Output public IP
output "game_ip" {
  # NOTE: this showed an old IP address instead of the new ip address when re-running tf apply
  value = azurerm_public_ip.cs2_public_ip.*.ip_address
  description = "The game server public IP"
}
output "telemetry_ip" {
  value = azurerm_public_ip.telemetry_public_ip.*.ip_address
  description = "The public IP address of the telemetry server"
}