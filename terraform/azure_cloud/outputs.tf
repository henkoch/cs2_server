# Output public IP
output "ip" {
  # NOTE: this showed an old IP address instead of the new ip address when re-running tf apply
  value = azurerm_public_ip.cs2_public_ip.*.ip_address
}