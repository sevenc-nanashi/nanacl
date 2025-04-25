# Nanacl

自分用AtCoder用ライブラリ。\
[nanacl.rbs](./sig/nanacl.rbs) を参照。

## 機能一覧

### CLI

#### ライブラリ展開機能

Nanacl はライブラリ展開機能を提供します。\
AtCoder で提供されているライブラリは展開されません。詳細は[./lib/nanacl/exe/expand/libraries.rb](./lib/nanacl/exe/expand/libraries.rb) を参照。\
この挙動は`-p`/`--preset`オプションで変更できます。\
また、展開と提出を同時に行うコマンドもあります。

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

main = -> do # =================================================================
# frozen_string_literal: true
# require "nanacl/logi" # (expanded: L14)
in_n = gets.chomp.to_i

puts Nanacl.logi(in_n, 2)

end # --------------------------------------------------------------------------

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


# ==============================================================================

main.call
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
  submit  Submit a solution

❯ nanacl expand -h
Usage: nanacl expand [options] FILE [OUTPUT]
    -h, --help                       Prints this help
    -m, --mode=MODE                  Specify MODE as expand mode. (blacklist or whitelist)
    -p, --preset=SERVICE             Specify SERVICE as preset. (atcoder or vanilla, default is atcoder)
    -i, --include=LIB                Specify LIB as include path.
    -e, --exclude=LIB                Specify LIB as exclude path.

❯ submit submit -h
Usage: nanacl submit [options] FILE [extra options]
    -h, --help                       Prints this help
    -m, --mode=MODE                  Specify MODE as expand mode. (blacklist or whitelist)
    -p, --preset=SERVICE             Specify SERVICE as preset. (atcoder or vanilla, default is atcoder)
    -i, --include=LIB                Specify LIB as include path.
    -e, --exclude=LIB                Specify LIB as exclude path.
    -c, --command=COMMAND            Specify COMMAND as submission command. (% for the expanded file path, or omit to get content from stdin)
```

## ライセンス

CC0 で公開します。詳しくは [LICENSE.txt](./LICENSE.txt) を参照。
