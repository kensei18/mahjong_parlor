# Mahjong Parlor
雀荘の検索・閲覧・レビュー投稿等ができるアプリケーションです。

Ruby on Rails v5.2 を使用しています。

## App URL
https://www.mahjong-parlor.com/

## Design
![mahjong_parlor](https://user-images.githubusercontent.com/43493096/80110311-80870e00-85b9-11ea-95c9-2bbecb531806.gif)

## Technical Specification
#### Backend
Ruby 2.6.5

Ruby on Rails 5.2.4.1

MySQL 5.7

#### Server
Nginx 1.17

Puma 3.11

#### Infrastructure
AWS (VCP / EC2 / RDS / ALB / Route53 / Certificate Manager)

Docker Compose

CircleCI

#### Web API
Google Maps API (Maps JavaScript API / Geocoding API)

![Untitled Diagram](https://user-images.githubusercontent.com/43493096/80103128-b246a780-85ae-11ea-838d-3e51cc38dd6c.png)

## Feature
- Google Maps API
    - Maps JavaScript API を使用した直感的でわかりやすい使用感を実現しました。
    - Geocoding API を使用し、新規雀荘登録が簡便です。


- Query Interface
    - 各種一覧ページにてN+1問題が発生しないように、Controller/Model 側でデータベースへのアクセス数が削減されるように調整しました。 


- 自動テスト (RSpec)
    - 小さな変更でも影響をキャッチできるように、小さな機能に対してもspecを記述しました。
    - Capybara / Factory Bot / Chrome Headless Blowser (JSのみ)


- リアルタイムでのレスポンス
    - Geocoding API で新規の雀荘を検索すると、非同期で住所・座標を取得し、非常に短時間で登録が可能です。
    - コメント、お気に入り、いいね、及び検索候補の機能をAjaxで実装しました。

    
- Issue / PullRequest を使用した擬似開発
    - Issue発行 -> localのブランチで開発 -> Push -> PullRequest発行 -> CircleCI通過後、Merge -> Pull の工程での開発を繰り返しました。    
    
    
- Dockerでの開発
    - Dockerを使用したリモート開発にチャレンジしたので、開発環境と本番環境で同一の設定を実現しました。
    - 本番環境のみNginxを導入しました。


- CircleCIを用いた開発
    - CircleCIで自動ビルド/自動テストを実施しました。


## Challenge
### 今後の課題
- Active Storageを使用した画像アップロード機能の作成
    - レビューと合わせて、店内の写真などをアップロードする機能を追加する予定です。
    - それにともない、AWS S3を使用したインフラを実現する予定です。


- CircleCIでの自動デプロイ
    - 現時点では自動ビルド・自動テストは実現できているので、自動デプロイの実装にもチャレンジする予定です。
