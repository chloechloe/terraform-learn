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

