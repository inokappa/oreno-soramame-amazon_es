# 俺の Amazon ES チュートリアル

## required

- Docker

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
