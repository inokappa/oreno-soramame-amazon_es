# 俺の Amazon ES チュートリアル

## 使い方

### required

- Docker

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
