@tool
extends Control

## シーン一覧ドック本体。
##
## 一覧はルートパス配下を都度走査する（`gmorn_scene_scanner.gd`）。ファイルシステム変更時に
## 自分で `EditorInterface.get_resource_filesystem()` を監視して `refresh_scenes()` を呼ぶので、
## シーンを追加/削除してもエディタ再起動なしで反映される。ルートパスは編集すると即
## `res://assets/gmorn_scene_settings.tres` へ保存される。
##
## `EditorPlugin` を介さず `EditorInterface` を直接使う（`gmorn_scene_section.gd` の
## `create_control()` から素の `Control` として作られるため。Godot 4.1 以降 `EditorInterface` は
## グローバルシングルトンとして `@tool` スクリプトから直接呼べる）。

const SCANNER_SCRIPT := preload("res://addons/gmorn_scene/gmorn_scene_scanner.gd")
const SETTINGS_SCRIPT := preload("res://addons/gmorn_scene/gmorn_scene_settings.gd")
const ROW_SCENE := preload("res://addons/gmorn_scene/gmorn_scene_row.tscn")
const SETTINGS_PATH := "res://assets/gmorn_scene_settings.tres"

@onready var root_path_edit: LineEdit = %RootPathEdit
@onready var rows_container: VBoxContainer = %RowsContainer

var _settings: Resource
var _resource_filesystem: EditorFileSystem

func _ready() -> void:
	root_path_edit.text_submitted.connect(_on_root_path_committed)
	root_path_edit.focus_exited.connect(_on_root_path_focus_exited)
	_settings = _load_settings()
	root_path_edit.text = _settings.root_path
	refresh_scenes()
	_resource_filesystem = EditorInterface.get_resource_filesystem()
	_resource_filesystem.filesystem_changed.connect(_on_filesystem_changed)
	tree_exiting.connect(_on_tree_exiting)

func _on_tree_exiting() -> void:
	if is_instance_valid(_resource_filesystem) and _resource_filesystem.filesystem_changed.is_connected(_on_filesystem_changed):
		_resource_filesystem.filesystem_changed.disconnect(_on_filesystem_changed)

func _on_filesystem_changed() -> void:
	call_deferred("refresh_scenes")

func _on_root_path_committed(_new_text: String) -> void:
	_commit_root_path()

func _on_root_path_focus_exited() -> void:
	_commit_root_path()

## ルートパスが変わっていれば保存し、一覧を走査し直す。
func _commit_root_path() -> void:
	var value := root_path_edit.text
	if value == _settings.root_path:
		return
	_settings.root_path = value
	ResourceSaver.save(_settings, SETTINGS_PATH)
	refresh_scenes()

func refresh_scenes() -> void:
	if _settings == null:
		return
	var scene_paths := SCANNER_SCRIPT.find_scenes(_settings.root_path)
	for child in rows_container.get_children():
		child.queue_free()
	for scene_path: String in scene_paths:
		var row: HBoxContainer = ROW_SCENE.instantiate()
		rows_container.add_child(row)
		row.setup(scene_path, EditorInterface)

static func _load_settings() -> Resource:
	if ResourceLoader.exists(SETTINGS_PATH):
		return load(SETTINGS_PATH)
	return SETTINGS_SCRIPT.new()
