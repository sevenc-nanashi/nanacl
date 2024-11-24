# Nanacl

自分用AtCoder用ライブラリ。
[nanacl.rbs](./sig/nanacl.rbs) を参照。

## 機能一覧

> [!NOTE]
> リンクをクリックすると実際にその機能を使ってACした提出が表示されます。

- ライブラリ展開機能

- `array_bfind`：[二分探索を使ったArrayの値探索。](https://atcoder.jp/contests/abc381/submissions/60139738)
- `array_sum`：Range指定のArrayの区間和。
- `bsearch_right`：[find-maximum式二分探索。](https://atcoder.jp/contests/abc381/submissions/60139738)
- `const.rb`：定数。
- `dijkstra.rb`：ダイクストラ法での最短距離、最短経路の取得。
- `logi.rb`：[より正確な整数log。](https://atcoder.jp/contests/abc380/submissions/60139798)
- `unionfind_map.rb`：[モノイドの乗るUnionFind。](https://atcoder.jp/contests/abc380/submissions/60139803)
- `unionfind_weight.rb`：[重み付きUnionFind。](https://atcoder.jp/contests/abc373/submissions/60140009)

## 使い方：CLI

```
❯ nanacl -h
Usage: nanacl [subcommand] [options]
Subcommands:
  expand  Expand libraries

❯ nanacl expand -h
Usage: nanacl expand [options] FILE [OUTPUT]
    -h, --help                       Prints this help
    -m, --mode=MODE                  Specify MODE as expand mode. (blacklist or whitelist)
    -i, --include=LIB                Specify LIB as include path.
    -e, --exclude=LIB                Specify LIB as exclude path.
```

## ライセンス

CC0 で公開します。詳しくは [LICENSE.txt](./LICENSE.txt) を参照。
