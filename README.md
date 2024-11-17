# Nanacl

自分用AtCoder用ライブラリ。
[nanacl.rbs](./sig/nanacl.rbs) を参照。

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
