# Azure既存リソースをterraformエクスポート
2024/07/06 初版
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
<img width="826" alt="截屏2024-07-06 15 26 26" src="https://github.com/chloechloe/terraform-learn/assets/8857472/8380a668-ae9d-4012-a278-1ee100d3f8c9">

`w`を押す

<img width="828" alt="截屏2024-07-06 15 30 41" src="https://github.com/chloechloe/terraform-learn/assets/8857472/ccd0fd47-ac8b-4979-b6c6-084f9a10a423">

<img width="824" alt="截屏2024-07-06 15 31 45" src="https://github.com/chloechloe/terraform-learn/assets/8857472/168dc5f7-20fa-41c6-9213-f2eec2184334">



