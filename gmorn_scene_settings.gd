extends RefCounted

## 検索ルートはプロジェクト設定の文字列1項目で管理する。
const ROOT_PATH_KEY := "gmorn_scene/root_path"
const DEFAULT_ROOT := "res://scenes/screens/"

static func register_settings() -> void:
	if not ProjectSettings.has_setting(ROOT_PATH_KEY):
		ProjectSettings.set_setting(ROOT_PATH_KEY, DEFAULT_ROOT)
	ProjectSettings.set_initial_value(ROOT_PATH_KEY, DEFAULT_ROOT)
	ProjectSettings.add_property_info({
		"name": ROOT_PATH_KEY,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR,
	})
	ProjectSettings.set_as_basic(ROOT_PATH_KEY, true)

static func root_path() -> String:
	return String(ProjectSettings.get_setting(ROOT_PATH_KEY, DEFAULT_ROOT))
