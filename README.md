# Nanacl

自分用AtCoder用ライブラリ。\
[nanacl.rbs](./sig/nanacl.rbs) を参照。

## 機能一覧

### CLI

#### ライブラリ展開機能

Nanacl はライブラリ展開機能を提供します。\
AtCoder で提供されているライブラリは展開されません。詳細は[./lib/nanacl/exe/expand/libraries.rb](./lib/nanacl/exe/expand/libraries.rb) を参照。\
この挙動は`-p`/`--preset`オプションで変更できます。\
デフォルトではライブラリを先に配置し、main をラムダで包まず末尾に配置します。\
`--main-first` を指定すると、従来の main を先頭に置く形式になります。\
生成コードの先頭には、使用する gem の名前と RubyGems の URL をコメントとして付記します。\
バイナリ提出用ファイルの生成には、後述の `binary` コマンドを使用できます。

<details>
<summary>展開前後の例</summary>

```ruby
# frozen_string_literal: true
require "nanacl/logi"
in_n = gets.chomp.to_i

puts Nanacl.logi(in_n, 2)
```

```ruby
# frozen_string_literal: true
# This file is expanded by nanacl.
# Gems:
# - nanacl: https://github.com/sevenc-nanashi/nanacl

# === dependencies -------------------------------------------------------------
# == nanacl/logi from main -----------------------------------------------------
# frozen_string_literal: true

module Nanacl
  module_function

  def logi(value, base)
    maybe_accurate = Math.log(value, base).floor
    if base**maybe_accurate > value
      maybe_accurate - 1
    elsif base**(maybe_accurate + 1) <= value
      maybe_accurate + 1
    else
      maybe_accurate
    end
  end
end

# === main ---------------------------------------------------------------------
# frozen_string_literal: true
# require "nanacl/logi" # (expanded: L7)
in_n = gets.chomp.to_i

puts Nanacl.logi(in_n, 2)
```

</details>

### ライブラリ

[`/verify`](./verify) ディレクトリには、[verification-helper](https://github.com/online-judge-tools/verification-helper) 用の証明ファイルが含まれています。
以下に凡例を示します：

| 記号               | 意味                      |
| ------------------ | ------------------------- |
| :100:              | `./verify` にて動作確認済 |
| :white_check_mark: | AtCoder にて動作確認済    |
| :o:                | RSpec にて動作確認済      |

クリックするとそれに対応するコードや提出が表示されます。

|                                                    |                                                                               |                                        | ファイル名                                                | 機能                                      |
| -------------------------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------- | --------------------------------------------------------- | ----------------------------------------- |
|                                                    | [:white_check_mark:](https://atcoder.jp/contests/abc381/submissions/60139738) | [:o:](./spec/array_bfind_spec.rb)      | [`array_bfind.rb`](./lib/nanacl/array_bfind.rb)           | 二分探索を使った値の範囲の探索。          |
| [:100:](./verify/static_range_sum.test.rb)         |                                                                               | [:o:](./spec/array_sum_spec.rb)        | [`array_sum.rb`](./lib/nanacl/array_sum.rb)               | Range指定の区間和。                       |
|                                                    | [:white_check_mark:](https://atcoder.jp/contests/abc381/submissions/60139738) | [:o:](./spec/bsearch_right_spec.rb)    | [`bsearch_right.rb`](./lib/nanacl/bsearch_right.rb)       | find-maximum式二分探索。                  |
| [:100:](./verify/unionfind_with_potential.test.rb) |                                                                               |                                        | [`const.rb`](./lib/nanacl/const.rb)                       | 定数。                                    |
| [:100:](./verify/shortest_path.test.rb)            |                                                                               | [:o:](./spec/dijkstra_spec.rb)         | [`dijkstra.rb`](./lib/nanacl/dijkstra.rb)                 | ダイクストラ法による最短距離/経路の取得。 |
|                                                    |                                                                               | [:o:](./spec/imos_spec.rb)             | [`imos.rb`](./lib/nanacl/imos.rb)                         | imos法。                                  |
|                                                    | [:white_check_mark:](https://atcoder.jp/contests/abc215/submissions/60181049) | [:o:](./spec/logi_spec.rb)             | [`logi.rb`](./lib/nanacl/logi.rb)                         | 正確な整数log。                           |
|                                                    |                                                                               | [:o:](./spec/rooti.rb)                 | [`rooti.rb`](./lib/nanacl/rooti.rb)                       | 正確な整数のn乗根。                       |
|                                                    | [:white_check_mark:](https://atcoder.jp/contests/abc380/submissions/60139803) | [:o:](./spec/unionfind_map_spec.rb)    | [`unionfind_map.rb`](./lib/nanacl/unionfind_map.rb)       | モノイドの乗るUnionFind。                 |
| [:100:](./verify/unionfind_with_potential.test.rb) | [:white_check_mark:](https://atcoder.jp/contests/abc373/submissions/60140009) | [:o:](./spec/unionfind_weight_spec.rb) | [`unionfind_weight.rb`](./lib/nanacl/unionfind_weight.rb) | 重み付きUnionFind。                       |

## 使い方：CLI

```
❯ nanacl -h
Usage: nanacl [subcommand] [options]
Subcommands:
  expand  Expand libraries
  binary  Generate a binary submission

❯ nanacl expand -h
Usage: nanacl expand [options] FILE [OUTPUT]
    -h, --help                       Prints this help
    -m, --mode=MODE                  Specify MODE as expand mode. (blacklist or whitelist)
    -p, --preset=SERVICE             Specify SERVICE as preset. (atcoder or vanilla, default is atcoder)
    -i, --include=LIB                Specify LIB as include path.
    -e, --exclude=LIB                Specify LIB as exclude path.
        --main-first                 Place main before libraries using a lambda.

❯ nanacl binary -h
Usage: nanacl binary [options] FILE [OUTPUT]
    -h, --help                       Prints this help
    -I DIR                           Add a library search path.
```

### バイナリ提出用ファイルの生成

ライブラリを先に展開し、main を末尾に配置したソースを [Spinel](https://github.com/matz/spinel) でコンパイルして、圧縮したバイナリを埋め込んだ Ruby ファイルを生成します。
生成ファイルの末尾には、`__END__` に続けて展開前のソースコードを添付します。
`spinel` を PATH に配置し、C コンパイラを用意してください。
提出先と同じ OS・CPU アーキテクチャで、glibc などの共有ライブラリも互換性のある環境で生成する必要があります。
生成ファイルが提出先のソースコードのサイズ制限に収まることも確認してください。
Spinel が対応していない Ruby の機能や gem は使用できません。

```sh
nanacl binary main.rb submission.rb
# 出力先を省略すると標準出力へ出力
nanacl binary main.rb > submission.rb
# 追加のライブラリ検索パス
nanacl binary -I ./lib main.rb submission.rb
```

## ライセンス

CC0 で公開します。詳しくは [LICENSE.txt](./LICENSE.txt) を参照。
