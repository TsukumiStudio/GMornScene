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
- ルートパスを `.tres` から読み込み、ファイルシステム変更時に一覧を更新

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
   検索範囲を変える場合は、プロジェクト側の `assets/gmorn_scene_settings.tres` の
   `root_path` を編集し、ドックを開き直してください。

5. 部品単体の検証はリポジトリ直下で `./verify.sh` を実行します。一時プロジェクト内の
   `addons/gmorn_scene/` にコピーして検証するため、ここには `project.godot` を置きません。

## License

[The Unlicense](UNLICENSE)
