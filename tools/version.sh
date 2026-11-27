#!/bin/sh
# レンダリングの前に、いまのコミットの番号と日付を _variables.yml に書き出す。
# ページ下部の「版」の表示に使う（_quarto.yml の page-footer）。
hash=$(git rev-parse --short=7 HEAD 2>/dev/null || echo "unknown")
date=$(git log -1 --format=%cs 2>/dev/null || echo "")
# コミットしていない変更があるときは、番号の後ろに + を付ける
if [ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]; then
  mark="+"
else
  mark=""
fi
cat > _variables.yml <<YAML
commit: "$hash"
commit-mark: "$mark"
commit-date: "$date"
YAML
