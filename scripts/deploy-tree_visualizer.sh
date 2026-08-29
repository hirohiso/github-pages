#!/usr/bin/env bash
#
# tree_visualizer をビルドして、このリポジトリの tree_visualizer/ 配下に配置する。
#
# 公開先: https://hirohiso.github.io/github-pages/tree_visualizer/
#
# tree_visualizer は独立したローカルリポジトリなので、このスクリプトは
# 「ソースを持つ側」ではなく「公開する側」に置いている。
# ベースパス (BASE_PATH) はホスティングの都合で決まる値であり、
# tree_visualizer 側の vite.config.ts には持たせず、ここからビルド時に渡す。
#
# 使い方:
#   ./scripts/deploy-tree_visualizer.sh
#   TREE_VISUALIZER_DIR=/path/to/tree_visualizer ./scripts/deploy-tree_visualizer.sh
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 既定ではこのリポジトリと同階層の tree_visualizer を参照する
SRC_DIR="${TREE_VISUALIZER_DIR:-$(dirname "$REPO_ROOT")/tree_visualizer}"
DEST_DIR="$REPO_ROOT/tree_visualizer"
BASE_PATH="/github-pages/tree_visualizer/"

WEB_DIR="$SRC_DIR/apps/web"
CRATE_DIR="$SRC_DIR/crates/tree_core"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

if [[ ! -d "$WEB_DIR" || ! -d "$CRATE_DIR" ]]; then
  echo "エラー: tree_visualizer が見つかりません: $SRC_DIR" >&2
  echo "  TREE_VISUALIZER_DIR 環境変数でパスを指定してください。" >&2
  exit 1
fi

for cmd in wasm-pack pnpm; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "エラー: $cmd が見つかりません。" >&2; exit 1; }
done

log "WASM をビルド (wasm-pack)"
(cd "$CRATE_DIR" && wasm-pack build --target web --out-dir pkg)

log "依存をインストール (pnpm)"
(cd "$WEB_DIR" && pnpm install --frozen-lockfile)

log "Web をビルド (base=$BASE_PATH)"
# pnpm run は追加引数を script の末尾に付与するため、--base は vite build に渡る
(cd "$WEB_DIR" && pnpm run build --base="$BASE_PATH")

log "成果物を $DEST_DIR へ配置"
rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"
cp -R "$WEB_DIR/dist/." "$DEST_DIR/"

log "完了。差分を確認してコミットしてください:"
echo "  git -C \"$REPO_ROOT\" add tree_visualizer && git -C \"$REPO_ROOT\" commit -m 'deploy: tree_visualizer'"
