@tool
extends HBoxContainer

## 一覧の1行。パスラベルと「開く」「再生」ボタンを持つ。

## **`@onready` で持たない。** 書き出し（ヘッドレスのエディタ）では、ドックが木に入る前に
## `refresh_scenes()` が走って `setup()` が呼ばれることがあり、`@onready` の変数が
## null のまま落ちていた（取り込み先の check_export で実測）。呼ばれた時点で引く。
var path_label: Label:
	get: return get_node("%PathLabel")
var open_button: Button:
	get: return get_node("%OpenButton")
var play_button: Button:
	get: return get_node("%PlayButton")

## `open_scene_from_path` はエディタでそのシーンを開く。`play_custom_scene` は現在編集中の
## シーンを問わずそのシーンを実行する（`EditorInterface` のカスタムシーン再生と同じ経路）。
func setup(scene_path: String, editor_interface: EditorInterface, root_path := "") -> void:
	path_label.text = scene_path.trim_prefix(root_path.trim_suffix("/") + "/") if not root_path.is_empty() else scene_path
	path_label.tooltip_text = scene_path
	open_button.pressed.connect(func() -> void:
		if editor_interface != null:
			editor_interface.open_scene_from_path(scene_path)
	)
	play_button.pressed.connect(func() -> void:
		if editor_interface != null:
			editor_interface.play_custom_scene(scene_path)
	)
