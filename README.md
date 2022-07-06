# README

## 開発環境セットアップ

イメージビルド
```sh
docker-compose build
```

コンテナ起動
```sh
docker-compose up -d
```

データベース作成
```sh
docker-compose exec web rails db:create
```

マイグレーション実行
```sh
docker-compose exec web rails db:migrate
```

初期データ投入
```sh
docker-compose exec web rails rails db:seed
```

開発サーバ起動
```sh
docker-compose exec web foreman start -f Procfile.dev
```
※`http://localhost:3000/` 