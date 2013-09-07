# IJN48

艦隊のアイドル、那珂ちゃんだよー!

## IJNって?

*Imperial Japanese Navy* の略で大日本帝国海軍の名称です

## なにができるの?

- 第1艦隊に補給 (補給クエ自動)
- 修理 (修理クエ自動)
- 遠征 (遠征クエ自動)
- 造船/武器 (クエ自動)
- 任務 (自動完了)
- 演習 (回数クエ自動)

WEBインターフェイスになっているので
cronとかつかってcurlで叩くと自動化できます

## つかいかた

### 必要なもの

- ruby
- redis

### gem入れる

```
$ bundle install
```

### chrome extension作る

```
$ rake crx
```

ijn48.crx ができるのでchromeに放り込む

### サーバを起動する

```
$ rackup
```

http://localhost:2411/ にアクセスする

### 艦これを起動する

艦これを起動するとchrome extensionによって艦これAPIアクセスに必要な情報が localhost:2411 に自動で送られます

### cronに登録する

```
* * * * * curl http://localhost:2411/repair
```

みたいに登録しよう
