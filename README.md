# terraform-learn
coding when I learn terraform

## memo
Terraform で ExpressRoute や VritualNetworkGateway を用いて専用線接続の設定を行う
https://qiita.com/moaikids/items/c85908c9ed5be1e12993

*error*
 Error: creating/updating Virtual Network Gateway (Subscription: "ff3de05d-5049-4835-8ade-393c974d9b1c"
│ Resource Group Name: "sky-admin-japaneast-rg"
│ Virtual Network Gateway Name: "userEdge-japaneast-vnetgw"): performing CreateOrUpdate: unexpected status 400 (400 Bad Request) with error: PublicIpWithBasicSkuNotAllowedOnExpressRouteGateways: Basic IP configuration for ExpressRoute Virtual Network Gateways is not supported. Please create and associate a Standard IP. /subscriptions/ff3de05d-5049-4835-8ade-393c974d9b1c/resourceGroups/sky-admin-japaneast-rg/providers/Microsoft.Network/virtualNetworkGateways/userEdge-japaneast-vnetgw
│ 
│   with azurerm_virtual_network_gateway.vng,
│   on main.tf line 85, in resource "azurerm_virtual_network_gateway" "vng":
│   85: resource "azurerm_virtual_network_gateway" "vng" {
│ 
╵

terraform-learn/CCV_prebuilt_simulation on  main took 1m 38s 
➜ 

ACR利用方法
https://learn.microsoft.com/ja-jp/azure/container-instances/container-instances-github-action

Web App for Containers vNet統合経由でプライベートエンドポイント先のACRからイメージPullする
https://qiita.com/shingo_kawahara/items/903ab9261d0d87c1d0a2

# Azure database for mysql
https://learn.microsoft.com/ja-jp/azure/mysql/flexible-server/tutorial-simple-php-mysql-app
