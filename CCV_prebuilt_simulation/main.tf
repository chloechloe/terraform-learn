locals {
  resource_group_name_admin="sky-admin-japaneast-rg"
  location="Japan East"
  virtual_network_admin={
    name="userEdge-japaneast-vnet"
    address_space="10.39.173.96/27"
  }

  subnets_admin=[
    {
      name="GateWaySubnet"
      address_prefix="10.39.173.96/27"
    }
  ]
  resource_group_name_user="user-japaneast-rg"
  virtual_network_user={
    name="user-japaneast-vnet"
    address_space="10.39.36.36/27"
  }

  expressRoute="erc-fic-kdmz-tokyo2"

}

resource "azurerm_resource_group" "admingrp" {
  name     = local.resource_group_name_admin
  location = local.location  
}

resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.admingrp.id
  lock_level = "ReadOnly"
  notes      = "This Resource Group is Read-Only"
}


resource "azurerm_resource_group" "usergrp" {
  name     = local.resource_group_name_user
  location = local.location  
}

resource "azurerm_virtual_network" "adminvnet" {
  name                = local.virtual_network_admin.name
  location            = local.location
  resource_group_name = local.resource_group_name_admin.name
  address_space       = [local.virtual_network_admin.address_space]  
  
   depends_on = [
     azurerm_resource_group.admingrp
   ]
  }

resource "azurerm_virtual_network" "uservnet" {
  name                = local.virtual_network_user.name
  location            = local.location
  resource_group_name = local.resource_group_name_user.name
  address_space       = [local.virtual_network_user.address_space]  
  
   depends_on = [
     azurerm_resource_group.usergrp
   ]
  }


resource "azurerm_subnet" "adminsubnet" {
  name                 = local.subnets[0].name
  resource_group_name  = local.resource_group_name_admin
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[0].address_prefix]
  depends_on = [
    azurerm_virtual_network.adminvnet
  ]
}
//expressroute
resource "azurerm_express_route_circuit" "expressRoute1" {
  name                  = local.expressRoute
  resource_group_name   = local.resource_group_name_admin
  location              = local.location
  service_provider_name = "NTT Communications - Flexible InterConnect"
  peering_location      = "Tokyo2"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }
}
/*
resource "azurerm_express_route_circuit_peering" "expressroutepeering" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = local.expressRoute
  resource_group_name           = local.resource_group_name_admin
  peer_asn                      = 100
  primary_peer_address_prefix   = "123.0.0.0/30"
  secondary_peer_address_prefix = "123.0.0.4/30"
  ipv4_enabled                  = true
  vlan_id                       = 300

  ipv6 {
    primary_peer_address_prefix   = "2002:db01::/126"
    secondary_peer_address_prefix = "2003:db01::/126"
    enabled                       = true
  }
}
*/


/*
resource "azurerm_network_interface" "appinterface" {
  name                = "appinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.appip.id
  }
  depends_on = [
    azurerm_subnet.subnetA
  ]
}

resource "azurerm_public_ip" "appip" {
  name                = "app-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
 depends_on = [
   azurerm_resource_group.appgrp
 ]
}

resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}

resource "azurerm_windows_virtual_machine" "appvm" {
  name                = "appvm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Azure@123"
  network_interface_ids = [
    azurerm_network_interface.appinterface.id,
    azurerm_network_interface.secondaryinterface.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.appinterface,
    azurerm_resource_group.appgrp,
    azurerm_network_interface.secondaryinterface
  ]
}

resource "azurerm_network_interface" "secondaryinterface" {
  name                = "secondaryinterface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"    
  }
  depends_on = [
    azurerm_subnet.subnetA
  ]
}

resource "azurerm_managed_disk" "appdisk" {
  name                 = "appdisk"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "16"

 }

 resource "azurerm_virtual_machine_data_disk_attachment" "appdiskattach" {
  managed_disk_id    = azurerm_managed_disk.appdisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.appvm.id
  lun                = "0"
  caching            = "ReadWrite"
}*/