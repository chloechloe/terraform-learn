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

