# Create a virtual network within the resource group
resource "azurerm_virtual_network" "counterstrike_vnet" {
  name                = "counterstrike-vnet"
  resource_group_name = azurerm_resource_group.counterstrike_rg.name
  location            = var.resource_group_location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "counterstrike_subnet" {
  name                 = "counterstrike-subnet"
  resource_group_name  = azurerm_resource_group.counterstrike_rg.name
  virtual_network_name = azurerm_virtual_network.counterstrike_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # To allow storage account to access the subnet
  service_endpoints = ["Microsoft.Storage"]
}