# Mahjong Parlor
雀荘の検索・閲覧・レビュー投稿等ができるアプリケーションです。

Ruby on Rails v5.2 を使用しています。

## App URL
https://www.mahjong-parlor.com/

## Design
<img src="https://user-images.githubusercontent.com/43493096/80306860-caae0080-8800-11ea-9a96-a6c6d3f904f2.png" width="400px"><br>
<img src="https://user-images.githubusercontent.com/43493096/80306862-cbdf2d80-8800-11ea-8f05-6f7eeede619b.png" width="400px"><br>
<img src="https://user-images.githubusercontent.com/43493096/80111118-6e599f80-85ba-11ea-8e79-1f1bfd708786.png" width="400px"><br>
<img src="https://user-images.githubusercontent.com/43493096/80306865-cd105a80-8800-11ea-9ccc-1a831fb42605.png" width="400px"><br>
<img src="https://user-images.githubusercontent.com/43493096/80110311-80870e00-85b9-11ea-95c9-2bbecb531806.gif" width="400px">

## Technical Specification
### Backend
Ruby 2.6.5

Ruby on Rails 5.2.4.1

MySQL 5.7

### Server
Nginx 1.17

Puma 3.11

### Infrastructure
AWS (VCP / EC2 / RDS / S3 / ALB / Route53 / Certificate Manager)

Docker Compose

CircleCI

### Web API
Google Maps API (Maps JavaScript API / Geocoding API)

![Untitled Diagram](https://user-images.githubusercontent.com/43493096/80299708-66c01380-87d1-11ea-842d-02d80cbdff14.png)


## Usage
- **ログイン**
    - ヘッダーの**ログイン**のリンク先に**テストユーザーのボタン**があるので、それをクリックしてログインしてください。
    - 'テストユーザー'はアカウント情報の編集・削除ができないようになっているので、ご注意ください。


- **雀荘を調べる** (ログイン不要)
    - トップページに登録されている全雀荘の一覧が地図と共に表示されています。
    - ヘッダーの検索窓に'店舗名'もしくは'住所'を入力し検索することで、登録済みの雀荘を調べることができます。


- **雀荘を登録する** (ログイン不要)
    - ヘッダーの**雀荘登録**のリンク先で未登録の雀荘を登録することができます。
    - 検索窓に登録したい雀荘の店舗名を入力します。場所を入力することができれば、より正確です。
    - 検索すると地図上に検索結果の位置がマークされます。また、登録フォームに全ての情報が入力されます。
    - 上記の情報で問題がなければ、登録ボタンを押してください。店舗名は登録用に変更することが可能です。
    - 登録後、その雀荘のページに飛ぶので、追加情報 (**URL, タバコ**)の入力、またレビューの投稿が可能となります。


- **レビューを投稿する**
    - レビューを投稿したい雀荘のページに進み、**レビューを投稿する**ボタンをクリックすると、レビューを記入する画面が表示されます。
    - 全項目を記入後、**投稿**ボタンをクリックすると、新規レビューが投稿されます。
    - 投稿したレビューは**各雀荘のページ**、及び各ユーザーの**プロフィールページ**から確認できます。
    - 各レビューの**詳しく見る**のリンクをクリックすると、レビューの全容をモーダルで確認することができます。
    - 自分の投稿したレビューに関しては、**レビュー編集**・**レビュー削除**をクリックすると編集・削除が可能です。


- **コメントを投稿する**
    - 投稿されている全てのレビューに対して、自分のコメントを投稿することができます。
    - 各レビューの**詳しく見る**のリンクをクリックして開かれるモーダルの下部にコメント一覧、及びコメント入力フォームがあります。
    - 自分の投稿したコメントについては、**削除**のリンクをクリックすることで削除することができます。


- **雀荘を行きつけに追加する**
    - 各雀荘のページに**お気に入り**ボタンがあります。
    - クリックすると、自分の**行きつけ**に登録することができます。
    - ヘッダーの**行きつけ**ボタンをクリックすると、その一覧を確認できます。


- **レビューにいいね！する**
    - 各レビューに**いいね**ボタンがあるので、クリックします。
    - いいね！したレビューの一覧はヘッダーの**ユーザー名 -> いいね！**から一覧を確認することができます。


## Feature
- **Google Maps API**
    - Maps JavaScript API を使用した直感的でわかりやすい使用感を実現しました。
    - Geocoding API を使用し、新規雀荘登録が簡便です。


- **Query Interface**
    - 各種一覧ページにてN+1問題が発生しないように、Controller/Model 側でデータベースへのアクセス数が削減されるように調整しました。 


- **自動テスト (RSpec)**
    - 小さな変更でも影響をキャッチできるように、小さな機能に対してもspecを記述しました。
    - Capybara / Factory Bot / Chrome Headless Blowser (JSのみ)


- **リアルタイムでのレスポンス**
    - Geocoding API で新規の雀荘を検索すると、非同期で住所・座標を取得し、非常に短時間で登録が可能です。
    - コメント、お気に入り、いいね、及び検索候補の機能をAjaxで実装しました。

    
- **Issue / PullRequest を使用した擬似開発**
    - Issue発行 -> localのブランチで開発 -> Push -> PullRequest発行 -> CircleCI通過後、Merge -> Pull の工程での開発を繰り返しました。    
    
    
- **Dockerでの開発**
    - Dockerを使用したリモート開発にチャレンジしたので、開発環境と本番環境で同一の設定を実現しました。
    - 本番環境のみNginxを導入しました。


- **CircleCIを用いた開発**
    - CircleCIで自動ビルド/自動テストを実施しました。


## Challenge
### 今後の課題
- ~~**Active Storageを使用した画像アップロード機能の作成**~~
    - ~~レビューと合わせて、店内の写真などをアップロードする機能を追加する予定です。~~
    - ~~それにともない、AWS S3を使用したインフラを実現する予定です。~~
    
    **実装済みです**

- **CircleCIでの自動デプロイ**
    - 現時点では自動ビルド・自動テストは実現できているので、自動デプロイの実装にもチャレンジする予定です。

- **Terraformの導入**
    - インフラのコード化に関しては、その概要含め、まだ不勉強ではありますが、内容として非常に興味があるので、今後チャレンジしたいです。

- **AWS ECS/ECRの導入**
    - まだ不勉強ではありますが、AWS上でのコンテナ管理に関しては、非常に興味があるので、今後チャレンジしたいです。
