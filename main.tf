resource "azurerm_linux_virtual_machine" "res-0" {
  admin_password                  = "Elastic00330033"
  admin_username                  = "radmin"
  disable_password_authentication = false
  location                        = "japaneast"
  name                            = "TEST-VM"
  network_interface_ids           = ["/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/networkInterfaces/test-vm881_z3"]
  patch_mode                      = "AutomaticByPlatform"
  reboot_setting                  = "IfRequired"
  resource_group_name             = "ACR-TEST"
  secure_boot_enabled             = true
  size                            = "Standard_B1s"
  vtpm_enabled                    = true
  zone                            = "3"
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.res-10,
  ]
}
resource "azurerm_resource_group" "res-1" {
  location = "japaneast"
  name     = "acr-test"
}

resource "azurerm_container_registry" "res-2" {
  admin_enabled                 = true
  location                      = "japaneast"
  name                          = "ccvacr"
  public_network_access_enabled = false
  resource_group_name           = "acr-test"
  sku                           = "Premium"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
/*
resource "azurerm_bastion_host" "res-9" {
  location            = "japaneast"
  name                = "Vnet1-bastion"
  resource_group_name = "acr-test"
  ip_configuration {
    name                 = "IpConf"
    public_ip_address_id = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/publicIPAddresses/Vnet1-ip"
    subnet_id            = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1/subnets/AzureBastionSubnet"
  }
  depends_on = [
    azurerm_public_ip.res-27,
    azurerm_subnet.res-30,
  ]
}*/

resource "azurerm_network_interface" "res-10" {
  location            = "japaneast"
  name                = "test-vm881_z3"
  resource_group_name = "acr-test"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.39.36.55"
    subnet_id                     = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1/subnets/app-subnet"
    public_ip_address_id = azurerm_public_ip.res-28.id
  }
  depends_on = [
    azurerm_subnet.res-31,
    azurerm_public_ip.res-28
  ]
}
resource "azurerm_network_interface_security_group_association" "res-11" {
  network_interface_id      = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/networkInterfaces/test-vm881_z3"
  network_security_group_id = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/networkSecurityGroups/test-vm-nsg"
  depends_on = [
    azurerm_network_interface.res-10,
    azurerm_network_security_group.res-12,
  ]
}
resource "azurerm_network_security_group" "res-12" {
  location            = "japaneast"
  name                = "test-vm-nsg"
  resource_group_name = "acr-test"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_network_security_rule" "res-13" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "test-vm-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "acr-test"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-12,
  ]
}

resource "azurerm_private_dns_zone" "res-14" {
  name                = "privatelink.azurecr.io"
  resource_group_name = "acr-test"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-15" {
  name                = "ccvacr"
  records             = ["10.39.36.53"]
  resource_group_name = "acr-test"
  ttl                 = 3600
  zone_name           = "privatelink.azurecr.io"
  depends_on = [
    azurerm_private_dns_zone.res-14,
  ]
}
resource "azurerm_private_dns_a_record" "res-16" {
  name                = "ccvacr.japaneast.data"
  records             = ["10.39.36.52"]
  resource_group_name = "acr-test"
  ttl                 = 3600
  zone_name           = "privatelink.azurecr.io"
  depends_on = [
    azurerm_private_dns_zone.res-14,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-18" {
  name                  = "f46t6q2nkvacw"
  private_dns_zone_name = "privatelink.azurecr.io"
  resource_group_name   = "acr-test"
  virtual_network_id    = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1"
  depends_on = [
    azurerm_private_dns_zone.res-14,
    azurerm_virtual_network.res-29,
  ]
}
/*
resource "azurerm_private_dns_zone" "res-19" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = "acr-test"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-20" {
  name                = "nginx-test0705"
  records             = ["10.39.36.54"]
  resource_group_name = "acr-test"
  tags = {
    creator = "created by private endpoint pe-app with resource guid 79b42a72-dea5-432f-99ce-2cd5cb76876a"
  }
  ttl       = 10
  zone_name = "privatelink.azurewebsites.net"
  depends_on = [
    azurerm_private_dns_zone.res-19,
  ]
}
resource "azurerm_private_dns_a_record" "res-21" {
  name                = "nginx-test0705.scm"
  records             = ["10.39.36.54"]
  resource_group_name = "acr-test"
  tags = {
    creator = "created by private endpoint pe-app with resource guid 79b42a72-dea5-432f-99ce-2cd5cb76876a"
  }
  ttl       = 10
  zone_name = "privatelink.azurewebsites.net"
  depends_on = [
    azurerm_private_dns_zone.res-19,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-23" {
  name                  = "c3adf66381838"
  private_dns_zone_name = "privatelink.azurewebsites.net"
  resource_group_name   = "acr-test"
  virtual_network_id    = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1"
  depends_on = [
    azurerm_private_dns_zone.res-19,
    azurerm_virtual_network.res-29,
  ]
}*/

resource "azurerm_private_endpoint" "res-24" {
  location            = "japaneast"
  name                = "pe-acr"
  resource_group_name = "acr-test"
  subnet_id           = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1/subnets/app-subnet"
  private_service_connection {
    is_manual_connection           = false
    name                           = "pe-acr_908b1f56-8369-422e-8472-fd416fd4c045"
    private_connection_resource_id = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourcegroups/acr-test/providers/Microsoft.ContainerRegistry/registries/ccvacr"
    subresource_names              = ["registry"]
  }
  depends_on = [
    azurerm_subnet.res-31,
  ]
}

/*
resource "azurerm_private_endpoint" "res-25" {
  location            = "japaneast"
  name                = "pe-app"
  resource_group_name = "acr-test"
  subnet_id           = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1/subnets/app-subnet"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "pe-app-9b22"
    private_connection_resource_id = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Web/sites/nginx-test0705"
    subresource_names              = ["sites"]
  }
  depends_on = [
    azurerm_private_dns_zone.res-19,
    azurerm_subnet.res-31,
    azurerm_linux_web_app.res-35,
  ]
}*/

resource "azurerm_public_ip" "res-27" {
  allocation_method   = "Static"
  location            = "japaneast"
  name                = "Vnet1-ip"
  resource_group_name = "acr-test"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_public_ip" "res-28" {
  allocation_method   = "Static"
  location            = "japaneast"
  name                = "test-vm-ip"
  resource_group_name = "acr-test"
  sku                 = "Standard"
  zones               = ["3"]
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_virtual_network" "res-29" {
  address_space       = ["10.39.36.0/24"]
  location            = "japaneast"
  name                = "Vnet1"
  resource_group_name = "acr-test"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
resource "azurerm_subnet" "res-30" {
  address_prefixes     = ["10.39.36.64/26"]
  name                 = "AzureBastionSubnet"
  resource_group_name  = "acr-test"
  virtual_network_name = "Vnet1"
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet" "res-31" {
  address_prefixes     = ["10.39.36.48/28"]
  name                 = "app-subnet"
  resource_group_name  = "acr-test"
  virtual_network_name = "Vnet1"
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet" "res-32" {
  address_prefixes     = ["10.39.36.32/29"]
  name                 = "appgw-subnet"
  resource_group_name  = "acr-test"
  virtual_network_name = "Vnet1"
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_subnet" "res-33" {
  address_prefixes     = ["10.39.36.40/29"]
  name                 = "vnet-integration"
  resource_group_name  = "acr-test"
  virtual_network_name = "Vnet1"
  delegation {
    name = "delegation"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
  depends_on = [
    azurerm_virtual_network.res-29,
  ]
}
resource "azurerm_service_plan" "res-34" {
  location            = "japaneast"
  name                = "ASP-acrtest-8001"
  os_type             = "Linux"
  resource_group_name = "acr-test"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.res-1,
  ]
}
/*
resource "azurerm_linux_web_app" "res-35" {
  app_settings = {
    DOCKER_ENABLE_CI                    = "true"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_PULL_IMAGE_OVER_VNET        = "true"
  }
  ftp_publish_basic_authentication_enabled       = false
  https_only                                     = true
  location                                       = "japaneast"
  name                                           = "nginx-test0705"
  public_network_access_enabled                  = false
  resource_group_name                            = "acr-test"
  service_plan_id                                = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Web/serverFarms/ASP-acrtest-8001"
  virtual_network_subnet_id                      = "/subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/acr-test/providers/Microsoft.Network/virtualNetworks/Vnet1/subnets/vnet-integration"
  webdeploy_publish_basic_authentication_enabled = false
  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on              = false
    ftps_state             = "FtpsOnly"
    vnet_route_all_enabled = true
  }
  depends_on = [
    azurerm_subnet.res-33,
    azurerm_service_plan.res-34,
  ]
}
resource "azurerm_app_service_custom_hostname_binding" "res-39" {
  app_service_name    = "nginx-test0705"
  hostname            = "nginx-test0705.azurewebsites.net"
  resource_group_name = "acr-test"
  depends_on = [
    azurerm_linux_web_app.res-35,
  ]
}*/
