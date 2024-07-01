resource "azurerm_subnet" "terrasubnet" {
  name                 = "terra-subnet"
  resource_group_name  = "app-grp"
  virtual_network_name = "app-vnet"
  address_prefixes     = ["10.0.1.0/24"]
}