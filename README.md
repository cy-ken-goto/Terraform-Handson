# インフラ勉強会#1「Terraformハンズオン」

## インフラ勉強会の目的
* 今後利用していくまたは利用していきたいインフラ面の技術を広く共有することで仲間を増やす
* インフラ面からのサービスの改善を促す
* 息抜き

## Terraformとは？
* https://www.terraform.io
* Hashicorp社製
 * VagrantやたSerfやら作ってる会社
* **サーバ構成**のコード化を行うためのもの
 * Infrastructure as Code ってやつですね
 * ![サービス自動化の図](https://raw.githubusercontent.com/cy-ken-goto/Terraform-Handson/master/ServiceAutomation.png)
* 各種プロバイダ対応もおこなっている
 * 触った感じAWSが主。新規サービスにもわりとすぐに対応してる
 * IaaS系AWS, GCP, Azure,SoftLayer などに対応(他にも一杯DigitalOceanとかも)
 * HerokuといったPaaSにも対応している
 * OpenStack, CloudStackにも対応(IDCFクラウドはCloudStackなので行ける・・・と思う※未検証)
 * なんとGitHubのチーム管理やリポジトリ管理もできる
 * 実はただのサーバ構成ツールで終わっていない

### コード
* JSON 互換である HCL (HashiCorp Configuration Language) で記述する
* 複雑なことは苦手
* その分「見たまま」の内容が反映される

### 構成要素
* Provider
 * 実行先のサービス
 * ex.) AWS, GCP
* Resource
 * サービスごとないで利用するインスタンスなど
 * ex.) EC2インスタンス, VPC, Route53のレコード
* Variable
 * 各種パラメータ
 * ex.) AccessKey, AMI ID

### 実行方法
1. コード記述
1. テスト
  ```
  $ terraform plan
  ```
1. 実行
  ```
  $ terraform apply
  ```

### 誰もがハマる落とし穴
1. terraform plan が 通っているのに apply でコケる
 * plan は ただのシンタックスチェックです。内容がProviderのAPI的に防いでも通ってしまいます
1. 再起動が必要な設定変更などを行うとやばい
 * EC2のインスタンスタイプを変えてapplyするとか
1. IAM ユーザ削除の失敗
 * IAMユーザは結構色々なところに紐付けされており、それが全て外れていないと削除できない
 * AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
 * Management Console パスワード
 * IAM Policy
 * IAM Group 所属情報

## 今ある環境に適用するには・・・？

### 必要なもの
* .tf ファイル
* Terraformのリソース管理はapply後に作成される**terraform.tfstate**で管理される
 * このファイルをGit管理するとコンフリクト起こすのでやめましょう

### どうやる？
* 残念ながらTerraform自体にその機能は存在しない
* Wantedlyの方が作った[Terraforming](https://github.com/dtan4/terraforming)というOSSが存在する
 * AWS専用
 * かなり活発

### インストール
```
$ gem install terraforming
```

または

```
$ docker pull quay.io/dtan4/terraforming:latest
```

### 使い方
#### tf 形式の出力
```
$ export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX
$ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
$ export AWS_DEFAULT_REGION=xx-yyyy-0
$ terraforming s3
```

または

```
$ docker run \
    --rm \
    --name terraforming \
    -e AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX \
    -e AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
    -e AWS_DEFAULT_REGION=xx-yyyy-0 \
    quay.io/dtan4/terraforming:latest \
    terraforming s3
```

#### tfstate 形式の出力
* --tfstateオプションつけるだけ
```
$ export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX
$ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
$ export AWS_DEFAULT_REGION=xx-yyyy-0
$ terraforming s3 --tfstate
```