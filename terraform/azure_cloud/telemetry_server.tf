data "template_file" "telementry_user_data" {
  template = file("./telemetry_server-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key        = file(var.ansible_ssh_public_key_filename)
  }
}

data "template_cloudinit_config" "telementry_commoninit" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.telementry_user_data.rendered
  }
}

# Create public IPs
resource "azurerm_public_ip" "telemetry_public_ip" {
  name                = "telemetry-public-ip"
  resource_group_name = azurerm_resource_group.counterstrike_rg.name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "telemetry_nsg" {
  name                = "telemetry-nsg"
  resource_group_name = azurerm_resource_group.counterstrike_rg.name
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
    name                       = "web"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
  # TODO: grafana, prometheus?
}

# Create network interface
resource "azurerm_network_interface" "telemetry_nic" {
  name                = "telemetryNIC"
  resource_group_name = azurerm_resource_group.counterstrike_rg.name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "telemetry_nic_configuration"
    subnet_id                     = azurerm_subnet.counterstrike_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.telemetry_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "telemetry_nsg_association" {
  network_interface_id      = azurerm_network_interface.telemetry_nic.id
  network_security_group_id = azurerm_network_security_group.telemetry_nsg.id
}


# Create virtual machine
#  It seems that the docker image memory requirement is at least 8 GB.
#  Standard_B2ms has 8 GB memory and 2 vcpus.
#  Standard_B4ms has 16 GB memory and 4 vcpus.
#  https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
resource "azurerm_linux_virtual_machine" "telemetry_vm" {
  name                  = "telemetryVM"
  resource_group_name   = azurerm_resource_group.counterstrike_rg.name
  location              = var.resource_group_location
  network_interface_ids = [azurerm_network_interface.telemetry_nic.id]
  # https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-general
  #  D2a v4 or D4a v4
  # az vm list-sizes --location "northeurope"
  # az vm list-skus --location northeurope --size Standard_B --all --output table
  size = "Standard_B2ms"

  # Provide the the cloud-init data.
  custom_data = data.template_cloudinit_config.telementry_commoninit.rendered

  os_disk {
    name    = "telemetryOsDisk"
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

  computer_name  = "telemetry"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = var.admin_public_ssh_key
  }

}

