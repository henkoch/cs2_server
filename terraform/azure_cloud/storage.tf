# storage account + file share

resource "azurerm_storage_account" "counterstrike_storage_account" {
  name                     = var.unique_storage_account_name
  resource_group_name      = azurerm_resource_group.counterstrike_rg.name
  location                 = var.resource_group_location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  cross_tenant_replication_enabled  = false
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules
# set the network so that only the subnet can access the storage account
resource "azurerm_storage_account_network_rules" "counterstrike_storage_network_rules" {
  storage_account_id = azurerm_storage_account.counterstrike_storage_account.id

  default_action     = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.counterstrike_subnet.id]
  bypass                     = ["AzureServices"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share

resource "azurerm_storage_share" "counterstrike_storage_share" {
  name                 = var.smb_share_name
  storage_account_name = azurerm_storage_account.counterstrike_storage_account.name
  access_tier          = "Hot"
  enabled_protocol     = "SMB"
  quota                = 50
}