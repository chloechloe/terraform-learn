resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "Japan East"
}

resource "azurerm_storage_account" "storageaccount0630" {
  name                     = "storageaccount0630"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = azurerm_resource_group.appgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.storageaccount0630.name
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.storageaccount0630 ]
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.storageaccount0630.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [ azurerm_storage_container.data ]
}