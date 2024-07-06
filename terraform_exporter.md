# Azure既存リソースをterraformエクスポート
## 1.AZ Cli ローカルPCインストール
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos

`brew update && brew install azure-cli`

## 2.Microsoft Azure Export for Terraform インストール
https://github.com/azure/aztfexport

`brew install aztfexport`

## 3.Azure リソースをエクスポートする
### 3.1 ローカルPC Azureログイン
`az login`
### 3.2 Azure リソースをエクスポートする
https://learn.microsoft.com/ja-jp/azure/developer/terraform/azure-export-for-terraform/export-first-resources?tabs=azure-cli#export-an-azure-resource

`aztfexport resource-group myResourceGroup`
