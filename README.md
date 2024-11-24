# Nanacl

自分用AtCoder用ライブラリ。
[nanacl.rbs](./sig/nanacl.rbs) を参照。

## 機能一覧

### CLI

- ライブラリ展開機能

### ライブラリ

[`/verify`](./verify) ディレクトリには、[verification-helper](https://github.com/online-judge-tools/verification-helper) 用の証明ファイルが含まれています。
以下に凡例を示します：

| 記号               | 意味                      |
| ------------------ | ------------------------- |
| :100:              | `./verify` にて動作確認済 |
| :white_check_mark: | AtCoder にて動作確認済    |
| :o:                | RSpec にて動作確認済      |
| :question:         | 動作未確認                |

:question: 以外の記号は、クリックするとそれに対応するコードや提出が表示されます。

| 状態                                                                          | ファイル名                                                | 機能                                      |
| ----------------------------------------------------------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| [:white_check_mark:](https://atcoder.jp/contests/abc381/submissions/60139738) | [`array_bfind.rb`](./lib/nanacl/array_bfind.rb)           | 二分探索を使った値の範囲の探索。          |
| [:100:](./verify/static_range_sum.test.rb)                                    | [`array_sum.rb`](./lib/nanacl/array_sum.rb)               | Range指定の区間和。                       |
| [:white_check_mark:](https://atcoder.jp/contests/abc381/submissions/60139738) | [`bsearch_right.rb`](./lib/nanacl/bsearch_right.rb)       | find-maximum式二分探索。                  |
| [:100:](./verify/unionfind_with_potential.test.rb)                            | [`const.rb`](./lib/nanacl/const.rb)                       | 定数。                                    |
| [:100:](./verify/shortest_path.test.rb)                                       | [`dijkstra.rb`](./lib/nanacl/dijkstra.rb)                 | ダイクストラ法による最短距離/経路の取得。 |
| [:100:](./verify/abc215_b_log2.test.rb)                                       | [`logi.rb`](./lib/nanacl/logi.rb)                         | 正確な整数log。                           |
| [:white_check_mark:](https://atcoder.jp/contests/abc380/submissions/60139803) | [`unionfind_map.rb`](./lib/nanacl/unionfind_map.rb)       | モノイドの乗るUnionFind。                 |
| [:100:](./verify/unionfind_with_potential.test.rb)                            | [`unionfind_weight.rb`](./lib/nanacl/unionfind_weight.rb) | 重み付きUnionFind。                       |

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
