# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs


# Create the service principal to use for the terraform operations
#   https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli
# First create a csgo resource group, via the web interface
# For the rolle look at the 'Access control(IAM)' entry under the resource group web page.
#  Contributor -  Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries.
# subscriptionID=$(az account show --query id -o tsv)
# mkdir ~/.variouos_credentials && chmod 700 ~/.variouos_credentials
# az ad sp create-for-rbac --name terraform_op --role Contributor --scopes /subscriptions/$subscriptionID/resourceGroups/$resourceGroup > ~/.variouos_credentials/azure.$resourceGroup.terraform_op

# add the following to your private apply script, do not check this in
# export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
# export ARM_TENANT_ID="<azure_subscription_tenant_id>"
# export ARM_CLIENT_ID="<service_principal_appid>"
# export ARM_CLIENT_SECRET="<service_principal_password>"

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.69.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.

  features {}

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_csgo_tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

data "template_file" "user_data" {
  template = file("./cloud-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    csgo_client_access_password   = var.csgo_client_access_password
    csgo_server_rcon_password     = var.csgo_server_rcon_password
    one_for_local_zero_for_global = var.csgo_one_for_local_zero_for_global
    server_name                   = var.csgo_server_name
    steam_server_token            = var.csgo_steam_server_token
  }
}

data "template_cloudinit_config" "commoninit" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.user_data.rendered
  }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "csgo_vnet" {
  name                = "csgo-vnet"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "csgo_subnet" {
  name                 = "csgo-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.csgo_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "csgo_public_ip" {
  name                = "csgo-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "csgo_nsg" {
  name                = "csgo-nsg"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "CSGO"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "27015-27017"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "csgo_nic" {
  name                = "csgoNIC"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "csgo_nic_configuration"
    subnet_id                     = azurerm_subnet.csgo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.csgo_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "csgo_nsg_association" {
  network_interface_id      = azurerm_network_interface.csgo_nic.id
  network_security_group_id = azurerm_network_security_group.csgo_nsg.id
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "csgo_vm" {
  name                  = "csgoVM"
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.csgo_nic.id]
  # https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general
  #  D2a v4 or D4a v4
  # az vm list-sizes --location "northeurope"
  # az vm list-skus --location northeurope --size Standard_B --all --output table
  size = "Standard_B1s"

  # Provide the the cloud-init data.
  custom_data = data.template_cloudinit_config.commoninit.rendered

  os_disk {
    name    = "myOsDisk"
    caching = "ReadWrite"
    # found this by creating a vm via web and then create an ARM template, in 'Parameters' tab
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "csgo"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.admin_public_ssh_key
  }

  # Data disk is linked using azurerm_virtual_machine_data_disk_attachment

}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk
resource "azurerm_managed_disk" "data_disk" {
  name                 = "csgo_data_disk"
  resource_group_name  = var.resource_group_name
  location             = var.resource_group_location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "45"

}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_on_csgo_vm" {
  count              = 1
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.csgo_vm.id
  # The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine.
  lun     = "10"
  caching = "ReadWrite"
}

# Output Server IP
output "ip" {
  # NOTE: this showed an old IP address instead of the new ip address when re-running tf apply
  value = azurerm_public_ip.csgo_public_ip.*.ip_address
}
