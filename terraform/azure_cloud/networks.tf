# Create a virtual network within the resource group
resource "azurerm_virtual_network" "cs2_vnet" {
  name                = "cs2-vnet"
  resource_group_name = azurerm_resource_group.cs_rg.name
  location            = var.resource_group_location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "cs2_subnet" {
  name                 = "cs2-subnet"
  resource_group_name  = azurerm_resource_group.cs_rg.name
  virtual_network_name = azurerm_virtual_network.cs2_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
