extends SceneTree

## ルートパス設定（プロジェクト設定への登録・保存）と走査（再帰・拡張子絞り込み・ドット除外）を確かめる。
##
## `Window`/`EditorPlugin` はエディタ本体が無いと意味を持たない実行系なので、
## ここではポップアップは開かない。`gmorn_window/verify.gd` も同じ理由で
## 画面そのものは動かさず、判定ロジックだけを確かめている。
##
## セクション定義（`gmorn_scene_section.gd`）は `gmorn_debug_menu_section.gd` を継承しており、
## `GMornDebugMenu` が無いこの検証用プロジェクトでは読み込めないため、ここではロードしない。

const SCANNER_PATH := "res://addons/gmorn_scene/gmorn_scene_scanner.gd"
const SETTINGS_PATH := "res://addons/gmorn_scene/gmorn_scene_settings.gd"
const SECTION_PATH := "res://addons/gmorn_scene/gmorn_scene_section.gd"
const FIXTURE_ROOT := "res://gmorn_scene_verify_scenes"
const SETTINGS_SAVE_PATH := "res://gmorn_scene_verify_settings.godot"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var section_script: GDScript = load(SECTION_PATH)
	assert(section_script.is_tool(), "GMornSceneSection は Editor で実行できる @tool スクリプトである必要がある")
	var section: Resource = section_script.new()
	var control: Control = section.create_control()
	assert(is_instance_valid(control), "GMornSceneSection.create_control() が Control を返さない")
	control.free()

	var settings_script: GDScript = load(SETTINGS_PATH)
	settings_script.register_settings()
	assert(settings_script.root_path() == "res://scenes/screens/", "既定のルートパスが違う")
	var property_found := false
	for info: Dictionary in ProjectSettings.get_property_list():
		if info.name == settings_script.ROOT_PATH_KEY:
			property_found = true
			assert(info.type == TYPE_STRING and info.hint == PROPERTY_HINT_DIR,
				"検索ルートがフォルダー選択可能な文字列でない")
			assert(info.usage & PROPERTY_USAGE_EDITOR_BASIC_SETTING, "詳細設定を開かないと見えない")
	assert(property_found, "プロジェクト設定に検索ルートが登録されていない")
	ProjectSettings.set_setting(settings_script.ROOT_PATH_KEY, FIXTURE_ROOT)
	settings_script.register_settings()
	assert(settings_script.root_path() == FIXTURE_ROOT, "再登録で既存の設定値が消えた")
	assert(ProjectSettings.save_custom(SETTINGS_SAVE_PATH) == OK, "設定を保存できない")
	var reloaded := ConfigFile.new()
	assert(reloaded.load(SETTINGS_SAVE_PATH) == OK, "設定を読み戻せない")
	assert(reloaded.get_value("gmorn_scene", "root_path") == FIXTURE_ROOT, "検索ルートが保存されていない")

	# 走査: 再帰・.tscn以外の除外・ドット始まりディレクトリの除外・パス昇順。
	var root_abs := ProjectSettings.globalize_path(FIXTURE_ROOT)
	DirAccess.make_dir_recursive_absolute(root_abs.path_join("sub"))
	DirAccess.make_dir_recursive_absolute(root_abs.path_join(".hidden"))
	_write_empty(root_abs.path_join("b.tscn"))
	_write_empty(root_abs.path_join("a.tscn"))
	_write_empty(root_abs.path_join("note.txt"))
	_write_empty(root_abs.path_join("sub/c.tscn"))
	_write_empty(root_abs.path_join(".hidden/d.tscn"))

	var scanner_script: GDScript = load(SCANNER_PATH)
	var scene_paths: PackedStringArray = scanner_script.find_scenes(FIXTURE_ROOT)
	assert(scene_paths.size() == 3, "見つかった.tscn数が %d" % scene_paths.size())
	assert(scene_paths[0] == FIXTURE_ROOT.path_join("a.tscn"), "1件目が %s" % scene_paths[0])
	assert(scene_paths[1] == FIXTURE_ROOT.path_join("b.tscn"), "2件目が %s" % scene_paths[1])
	assert(scene_paths[2] == FIXTURE_ROOT.path_join("sub/c.tscn"), "3件目が %s" % scene_paths[2])

	# ルートが開けない場合は空配列を返す（落とさない）。
	var missing: PackedStringArray = scanner_script.find_scenes("res://not_found_dir")
	assert(missing.is_empty(), "存在しないルートで %d 件返った" % missing.size())

	DirAccess.remove_absolute(root_abs.path_join("a.tscn"))
	DirAccess.remove_absolute(root_abs.path_join("b.tscn"))
	DirAccess.remove_absolute(root_abs.path_join("note.txt"))
	DirAccess.remove_absolute(root_abs.path_join("sub/c.tscn"))
	DirAccess.remove_absolute(root_abs.path_join("sub"))
	DirAccess.remove_absolute(root_abs.path_join(".hidden/d.tscn"))
	DirAccess.remove_absolute(root_abs.path_join(".hidden"))
	DirAccess.remove_absolute(root_abs)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SETTINGS_SAVE_PATH))

	print("走査件数=%d 既定ルート=%s" % [scene_paths.size(), "res://scenes/screens/"])
	print("GMORN SCENE VERIFY: PASS")
	quit(0)

func _write_empty(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.close()
