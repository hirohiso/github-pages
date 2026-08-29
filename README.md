# github-pages

個人的なツール類を GitHub Pages で公開するためのリポジトリ。

公開先: https://hirohiso.github.io/github-pages/

## 構成

| パス | 内容 |
| --- | --- |
| `index.html` | トップページ（作品一覧） |
| `tree_visualizer/` | Tree Visualizer のビルド成果物（自動生成・直接編集しない） |
| `scripts/` | 各アプリをビルドして配置するデプロイスクリプト |
| `.nojekyll` | Jekyll による処理を無効化する |

ビルド成果物をリポジトリにコミットし、GitHub Pages の
「Deploy from a branch: `main` / `(root)`」で配信する方式をとっている。

## GitHub Pages の設定

リポジトリの Settings → Pages で以下を設定する（初回のみ）。

- Source: **Deploy from a branch**
- Branch: **main** / **/ (root)**

## Tree Visualizer のデプロイ

ソースは別リポジトリ（このリポジトリと同階層の `../tree_visualizer`）にある。
ビルドに `wasm-pack` と `pnpm` が必要。

```bash
./scripts/deploy-tree_visualizer.sh

# ソースが別の場所にある場合
TREE_VISUALIZER_DIR=/path/to/tree_visualizer ./scripts/deploy-tree_visualizer.sh
```

成果物が `tree_visualizer/` に配置されるので、確認してコミット・push する。

```bash
git add tree_visualizer && git commit -m "deploy: tree_visualizer" && git push
```

公開 URL: https://hirohiso.github.io/github-pages/tree_visualizer/
