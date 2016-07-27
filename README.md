# インフラ勉強会#1「Terraformハンズオン」

## インフラ勉強会の目的
* 今後利用していくまたは利用していきたいインフラ面の技術を広く共有することで仲間を増やす
* インフラ面からのサービスの改善を促す
* 息抜き

## Terraformとは？
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

## 
