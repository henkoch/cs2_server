resource "azurerm_resource_group" "counterstrike_rg" {
  location = var.resource_group_location
  name     = "counterstrike-rg"
}
