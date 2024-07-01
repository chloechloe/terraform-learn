# 検証PC（Mac）でのTerraform実行環境構築手順
## 1.terraformインストール
macの場合、homebrewですぐインストールできる

`brew install terraform`

※：suoh端末そう簡単にいけないないかも

参考ページ：https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

インストールできましたら、ターミナルに
`terraform -v`
を入力し、⇩このような出力されたら、OKです。
![image](https://github.com/chloechloe/terraform-learn/assets/8857472/e4877904-464d-417e-81c4-0a0157db976c)

## 2.編集環境VS code整備
### 2.1 VS code ダウンロード
Macの場合、方式DLページにてダウンロードできて、手順通りインストールできれば、OKです。

https://code.visualstudio.com/

suoh端末の場合、zipをDLする必要あります。
<img width="1363" alt="截屏2024-07-01 13 36 54" src="https://github.com/chloechloe/terraform-learn/assets/8857472/962b7a5a-a0a4-4001-9a0c-cc7d8c5146c8">

その後、解凍すれば利用できます。
### 2.2 VS codeでterraformプラグインインストール
terraformプラグインあれば、コーディングされる際、自動補完機能があり、利用しやすいです。

プラグインインストール方法：
VS code > Extensions > "terraform"を検索 > HashiCorp発行されたバージョンを選択 > install

<img width="1391" alt="Screenshot 2024-07-01 at 14 03 40" src="https://github.com/chloechloe/terraform-learn/assets/8857472/fea8be74-7012-441a-b17a-77337044c250">

## 3 AzureテナントとTerraform関連する
### 3.1 AzureテナントにTerraform登録する
Azureポータルにログインした後、
Microsoft Entra IDを選択
<img width="1371" alt="Screenshot 2024-07-01 at 14 24 33 1" src="https://github.com/chloechloe/terraform-learn/assets/8857472/2f9fdf9d-604b-4844-b92a-4761f2d7f24d">

App registrationsを選択、+ New registrationをクリック
<img width="684" alt="Screenshot 2024-07-01 at 14 28 27" src="https://github.com/chloechloe/terraform-learn/assets/8857472/565b3f06-c012-4831-a668-1c5d3a20bd40">

名前を入力し、Registerをクリック
<img width="1364" alt="Screenshot 2024-07-01 at 14 30 16" src="https://github.com/chloechloe/terraform-learn/assets/8857472/56b5228f-893d-46cb-8b17-5e69103c6918">

app registration作成後、secretを作成する
terraform詳細画面左側　Manage > Certificate & Secretをクリック
![Screenshot 2024-07-01 at 14 42 25](https://github.com/chloechloe/terraform-learn/assets/8857472/fa386cea-dad1-4918-bab6-6dab6e505e43)
「+ New client Secret」をクリック、任意な名前を入力し、「add」をクリック
![Screenshot 2024-07-01 at 14 51 45](https://github.com/chloechloe/terraform-learn/assets/8857472/a1c774da-e366-4d9e-a026-8ce19ab11ee9)
その後、Value欄の文字列すぐコピーし、PCのメモ帳に貼り付けます。

**このsecret明文は一度しか表示されないため、必ずどこかでメモ帳すぐ貼り付けてください**

![Screenshot 2024-07-01 at 14 54 14](https://github.com/chloechloe/terraform-learn/assets/8857472/74105bf3-032d-4d65-8868-6b770ddbe753)

### 3.2 terraformにAzure Provider情報を記入する
VS Codeに新規ファイル、「main.tf」を作成する
terraform Azure provider公式ページにアクセスする
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

「Use　Provider」をクリック、コードブロックをコピーし、VSCodeの「main.tf」に貼り付けます。

<img width="1377" alt="Screenshot 2024-07-01 at 15 41 09" src="https://github.com/chloechloe/terraform-learn/assets/8857472/d5665e1a-d596-450a-8f4e-158cf3ee6df0">
<img width="704" alt="Screenshot 2024-07-01 at 15 43 30" src="https://github.com/chloechloe/terraform-learn/assets/8857472/96f11440-e96f-4854-9ba9-070e8f443605">

```
provider "azurerm" {
  # Configuration options
}
```
ブロックに必要なAzureテナント情報を入力します。
subscription_idはAzureスクリプション情報になります。このように確認できます。
![Screenshot 2024-07-01 at 15 52 39](https://github.com/chloechloe/terraform-learn/assets/8857472/3fb879a1-7505-408f-b376-cad39a1bb81c)
tenant_id、client_idはこのように確認できます。
Microsoft Entra ID > App registrations > All applications > terraform 

![Screenshot 2024-07-01 at 15 56 19](https://github.com/chloechloe/terraform-learn/assets/8857472/8464df3f-2abf-4e23-b2c9-2af4f51da691)
![Screenshot 2024-07-01 at 15 57 34](https://github.com/chloechloe/terraform-learn/assets/8857472/f8a3a971-683f-48f2-aba9-f932264b46fa)

client_secretは3.1章でメモ帳に貼り付けたsecretになります。

そうしたら、providerブロックはこのようになります。

```
provider "azurerm" {
  # Configuration options
  subscription_id = "ff3de05d-***"
  tenant_id = "db12c563-***"
  client_id = "38695bad-***"
  client_secret = "17J8Q~***"
  features {
    
  }

}
```

## 4 terraform実行してみる (resource group作成の例）
### 4.1 resource group定義を追加します。
全体的に「main.tf」がこのようになります。
```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.110.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "ff3de05d-***"
  tenant_id = "db12c563-***"
  client_id = "38695bad-***"
  client_secret = "17J8Q~****"
  features {
    
  }

}

resource "azurerm_resource_group" "testgrp" {
  name     = "test-grp"
  location = "Japan East"
}
```

### 4.2 VS Codeでterminalを開く
<img width="855" alt="Screenshot 2024-07-01 at 16 05 18" src="https://github.com/chloechloe/terraform-learn/assets/8857472/d8f944e6-fde7-4238-85d9-f5039e9fb696">

<img width="1418" alt="Screenshot 2024-07-01 at 16 05 58" src="https://github.com/chloechloe/terraform-learn/assets/8857472/d55b1551-ce1b-4f07-9485-3804c78930b0">

### 4.3 terraformを実行する
`terraform init`
<img width="1097" alt="Screenshot 2024-07-01 at 16 07 09" src="https://github.com/chloechloe/terraform-learn/assets/8857472/df4fe64c-35f0-4e94-82f7-21d847aa42fd">
<img width="1084" alt="Screenshot 2024-07-01 at 16 07 31" src="https://github.com/chloechloe/terraform-learn/assets/8857472/f85c2420-0aaa-479e-b8b6-35d56bc443f9">

`terraform plan`
<img width="1083" alt="Screenshot 2024-07-01 at 16 08 27" src="https://github.com/chloechloe/terraform-learn/assets/8857472/84057d69-6ed7-4756-a333-4cb6e06ea93c">
<img width="1093" alt="Screenshot 2024-07-01 at 16 08 46" src="https://github.com/chloechloe/terraform-learn/assets/8857472/95cacc11-4e73-4c9f-942b-41dcdaa1f3bd">

`terraform apply`
<img width="1088" alt="Screenshot 2024-07-01 at 16 09 37" src="https://github.com/chloechloe/terraform-learn/assets/8857472/4d95a4bb-fd9f-4c94-9852-b91973319e2c">
実行するかしつもん出たら、「yes」を入力して、enterをおします。
<img width="1094" alt="Screenshot 2024-07-01 at 16 10 08" src="https://github.com/chloechloe/terraform-learn/assets/8857472/bdfb312b-b560-4291-ab84-11863337b2e2">
「apply completed!」みたいな情報出たら、デプロイ完成
<img width="1091" alt="Screenshot 2024-07-01 at 16 11 23" src="https://github.com/chloechloe/terraform-learn/assets/8857472/54b5fec8-b8e9-45cc-935e-b05cb3aa03aa">

Azure ポータル確認したら、test-grp作成されてます。
![Screenshot 2024-07-01 at 16 12 44](https://github.com/chloechloe/terraform-learn/assets/8857472/0139263b-f97f-40ad-b7bb-601711b059f4)



