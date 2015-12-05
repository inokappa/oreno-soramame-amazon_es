# 俺の Amazon ES チュートリアル

## 必要なもの

- Docker
- make

## PM2.5 のデータを Amazon ES に突っ込む

### Amazon ES のエンドポイントを設定する

```sh
$ mv Makefile.sample Makefile
$ sed -i 's/YOUR_AMAZON_ES_ENDPOINT/search-xxxxxxxxxxxxxxxxxxxxxxxx.ap-northeast-1.es.amazonaws.com/g' Makefile
```

### build

```sh
$ make build
```

### run

```sh
$ make soramame
```

## PM2.5 のデータを Kibana に登録する為の準備

### Amazon ES のエンドポイントを設定する

```sh
$ cd kibana
$ mv Makefile.sample Makefile
$ sed -i 's/YOUR_AMAZON_ES_ENDPOINT/search-xxxxxxxxxxxxxxxxxxxxxxxx.ap-northeast-1.es.amazonaws.com/g' Makefile
```

### build

```sh
$ cd kibana
$ make build
```

### Search オブジェクト登録

```sh
$ cd kibana
$ make kibana-search
```

### Visualize オブジェクト登録

```sh
$ cd kibana
$ make kibana-visualize
```

## スナップショットとレストア

### スナップショット先の S3 バケットと IAM ロールの作成

- Makefile の修正

```sh
$ cd oreno-soramame-amazon_es/snapshot/terraform
$ mv Makefile.sample Makefile
$ vim Makefile

# アクセスキーとシークレットアクセスキー、S3 バケットを環境に応じて設定する
PLAN         := terraform plan -var 'access_key=AKxxxxxxxxxxxxxxxxxxx' -var 'secret_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -var 's3_bucket_name=your-bucket-name'
APPLY        := terraform apply -var 'access_key=AKxxxxxxxxxxxxxxxxxx' -var 'secret_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' -var 's3_bucket_name=your-bucket-name'
```

- terraform plan と apply

```sh
$ make tf-plan
$ make tf-apply
```

### スナップショット用のレジストリを登録

- コマンドを Docker build する

```sh
$ cd oreno-soramame-amazon_es/snapshot/
$ mv Makefile.sample Makefile
$ vim Makefile

#
# ES_HOST には Amazon ES のエンドポイント
# ES_SNAPSHOT にはスナップショットのレジストリ名
# ES_SNAPSHOT_NAME_PREFIX にはスナップショット名
#
DOCKER_BUILD        := docker build --no-cache=true -t oreno-es-index-snapshot .
DOCKER_RUN_REGIST   := docker run --rm --name oreno-es-index-snapshot --env "ES_HOST=search-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.ap-northeast-1.es.amazonaws.com" --env "ES_SNAPSHOT=your-snapshot" -v `pwd`:/tmp -v /etc/localtime:/etc/localtime:ro oreno-es-index-snapshot regist
DOCKER_RUN_CREATE   := docker run --rm --name oreno-es-index-snapshot --env "ES_HOST=search-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.ap-northeast-1.es.amazonaws.com" --env "ES_SNAPSHOT=your-snapshot" --env "ES_SNAPSHOT_NAME_PREFIX=your-snapshot" -v `pwd`:/tmp -v /etc/localtime:/etc/localtime:ro oreno-es-index-snapshot create
DOCKER_RUN_LIST     := docker run --rm --name oreno-es-index-snapshot --env "ES_HOST=search-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.ap-northeast-1.es.amazonaws.com" --env "ES_SNAPSHOT=your-snapshot" -v `pwd`:/tmp -v /etc/localtime:/etc/localtime:ro oreno-es-index-snapshot list

# Makefile を修正後に build を実行する
$ make build
```

- スナップショットのレジストリを登録する

```sh
$ make snapshot-regist
```

### スナップショットの作成

```sh
$ make snapshot-create
```

### スナップショットの一覧

```sh
$ make snapshot-list
```

***

## 補足

- http://inokara.hateblo.jp/entry/2015/12/05/181358
