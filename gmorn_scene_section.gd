@tool
extends "../gmorn_debug_menu/gmorn_debug_menu_section.gd"

## `GMornDebugMenu` ドックへ「GMorn Scene」セクションとして差し込む。
##
## `class_name` は付けない（`gmorn_debug_menu_section.gd` と同じ理由）。このスクリプトを
## 付けた `.tres`（`assets/debug_sections/gmorn_scene.tres`）を
## `gmorn_debug_menu_section_scanner.gd` が拾い、`EditorPlugin` 無しでドックへ登録される
## （`GMornScene` はもう `plugin.gd`/`plugin.cfg` を持たない。プラグイン一覧から有効化する
## 手順は不要になった）。

const DOCK_SCENE := preload("res://addons/gmorn_scene/gmorn_scene_dock.tscn")

func create_control() -> Control:
	return DOCK_SCENE.instantiate()
