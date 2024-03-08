resource "azurerm_resource_group" "cs_rg" {
  location = var.resource_group_location
  name     = "rg-cs"
}

