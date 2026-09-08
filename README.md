# GMornScene

## Overview

指定したルートパス配下の `.tscn` を一覧し、エディタから開く・再生する
GMornDebugMenu のセクションです。独自の `EditorPlugin`、`plugin.cfg`、autoload は持ちません。

## Requirements

- Godot 4.7 以降
- [GMornDebugMenu](https://github.com/TsukumiStudio/GMornDebugMenu)

このリポジトリ直下には `project.godot` を置きません。取り込むプロジェクト側の
`addons/gmorn_scene/` へ、そのまま submodule として置く構成です。

## Features

- 指定ルート下の `.tscn` を再帰走査し、パス順に表示
- 各シーンをエディタで開く、または個別に再生
- 一覧はドックの空き領域まで広がり、収まらない行だけ縦スクロール
- ルートパスはプロジェクト設定の文字列で指定し、設定・ファイル変更時に一覧を更新

## Usage

1. GMornDebugMenu とともに submodule として追加します。

   ```sh
   git submodule add https://github.com/TsukumiStudio/GMornDebugMenu.git addons/gmorn_debug_menu
   git submodule add https://github.com/TsukumiStudio/GMornScene.git addons/gmorn_scene
   ```

2. Godot の「プロジェクト設定 → プラグイン」で GMornDebugMenu を有効にします。GMornScene は
   `plugin.cfg` を持たないため、個別に有効化する手順はありません。

3. プロジェクト側に `assets/debug_sections/gmorn_scene.tres` を作成し、GMornScene を
   セクションとして登録します。GMornDebugMenu の既定の `section_dir`
   （`res://assets/debug_sections/`）へ置いてください。

   ```text
   [gd_resource type="Resource" load_steps=2 format=3]

   [ext_resource type="Script" path="res://addons/gmorn_scene/gmorn_scene_section.gd" id="1_section"]

   [resource]
   script = ExtResource("1_section")
   title = "GMorn Scene"
   section_id = &"gmorn_scene"
   ```

4. エディタを開き直すと GMornDebugMenu ドックに「GMorn Scene」が現れます。
   各行の「開く」または「再生」を使います。ルートパスの入力欄はありません。
   検索範囲は「プロジェクト設定 → GMorn Scene → Root Path」で指定します。
   文字列の入力またはフォルダー選択ができ、変更は一覧へ反映されます。
   値は `project.godot` の `gmorn_scene/root_path` に保存します（既定は `res://scenes/screens/`）。
   旧版の設定 `.tres` を使っているプロジェクトは、その `root_path` をこの項目へ移してください。

5. 部品単体の検証はリポジトリ直下で `./verify.sh` を実行します。一時プロジェクト内の
   `addons/gmorn_scene/` にコピーして検証するため、ここには `project.godot` を置きません。

## License

[The Unlicense](UNLICENSE)

一覧には設定したルートからの相対パスを表示する。たとえばルートが `res://scenes/screens` なら `novel_preview.tscn` と表示する。サブフォルダー名は保持し、ホバーで完全パスを確認できる。「開く」「再生」には元の完全パスを使う。
