locals {
  subnet_settings = {
    name = ["subnet1","subnet2"]
    address_prefix = ["10.0.1.0/24","10.0.2.0/24"]
  }
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "Japan East"
}

resource "azurerm_network_security_group" "appvnetnsg" {
  name                = "app-vnet-nsg"
  location            = azurerm_resource_group.appgrp.location
  resource_group_name = azurerm_resource_group.appgrp.name
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_virtual_network" "appvnet" {
  name                = "app-vnet"
  location            = azurerm_resource_group.appgrp.location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
/*
  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.appvnetnsg.id
  }*/
  
  depends_on = [ azurerm_resource_group.appgrp ]
}