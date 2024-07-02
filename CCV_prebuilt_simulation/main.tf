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
    address_space="10.39.36.32/27"
  }

  expressRoute="erc-fic-kdmz-tokyo2"

}

resource "azurerm_resource_group" "admingrp" {
  name     = local.resource_group_name_admin
  location = local.location  
}
//lock
/*
resource "azurerm_management_lock" "resource-group-level" {
  name       = "resource-group-level"
  scope      = azurerm_resource_group.admingrp.id
  lock_level = "ReadOnly"
  notes      = "This Resource Group is Read-Only"
  depends_on = [ azurerm_resource_group.admingrp ]
}*/


resource "azurerm_resource_group" "usergrp" {
  name     = local.resource_group_name_user
  location = local.location  
}

resource "azurerm_virtual_network" "adminvnet" {
  name                = local.virtual_network_admin.name
  location            = local.location
  resource_group_name = local.resource_group_name_admin
  address_space       = [local.virtual_network_admin.address_space]  
  
   depends_on = [
     azurerm_resource_group.admingrp
   ]
  }

resource "azurerm_virtual_network" "uservnet" {
  name                = local.virtual_network_user.name
  location            = local.location
  resource_group_name = local.resource_group_name_user
  address_space       = [local.virtual_network_user.address_space]  
  
   depends_on = [
     azurerm_resource_group.usergrp
   ]
  }


resource "azurerm_subnet" "adminsubnet" {
  name                 = local.subnets_admin[0].name
  resource_group_name  = local.resource_group_name_admin
  virtual_network_name = local.virtual_network_admin.name
  address_prefixes     = [local.subnets_admin[0].address_prefix]
  depends_on = [
    azurerm_virtual_network.adminvnet
  ]
}
//VPN Gateway
resource "azurerm_public_ip" "publicip" {
    name                         = "userEdge-japaneast-pip"
    location                     = local.location
    resource_group_name          = local.resource_group_name_admin
    allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vng" {
    name = "userEdge-japaneast-vnetgw"
    location = local.location
    resource_group_name = local.resource_group_name_admin

    type = "ExpressRoute"
    sku = "Standard"

    ip_configuration {
        name = "vng-config"
        public_ip_address_id = azurerm_public_ip.publicip.id
        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.adminsubnet.id
    }
    depends_on = [ azurerm_public_ip.publicip,azurerm_subnet.adminsubnet ]
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
  depends_on = [ azurerm_resource_group.admingrp ]
}

resource "azurerm_virtual_network_peering" "peer_admin_to_user" {
  name                      = "peer_admin_to_user"
  resource_group_name       = local.resource_group_name_admin
  virtual_network_name      = local.virtual_network_admin.name
  remote_virtual_network_id = azurerm_virtual_network.uservnet.id
  depends_on = [ azurerm_virtual_network.adminvnet,azurerm_virtual_network.uservnet ]
}

resource "azurerm_virtual_network_peering" "peer_user_to_admin" {
  name                      = "peer_user_to_admin"
  resource_group_name       = local.resource_group_name_user
  virtual_network_name      = local.virtual_network_user.name
  remote_virtual_network_id = azurerm_virtual_network.adminvnet.id
  depends_on = [ azurerm_virtual_network.adminvnet,azurerm_virtual_network.uservnet ]
}

//Private Peering
//ExpressRoute Circuit と Azure のネットワークの Peering 設定を行います。

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
}
*/

//Connection(Virutal Network と Express Route の接続)
//ルーティング設定が終わった後は、実際に接続したい Virtual Network との接続設定を行います。