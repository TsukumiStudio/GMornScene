@tool
extends HBoxContainer

## 一覧の1行。パスラベルと「開く」「再生」ボタンを持つ。

@onready var path_label: Label = %PathLabel
@onready var open_button: Button = %OpenButton
@onready var play_button: Button = %PlayButton

## `open_scene_from_path` はエディタでそのシーンを開く。`play_custom_scene` は現在編集中の
## シーンを問わずそのシーンを実行する（`EditorInterface` のカスタムシーン再生と同じ経路）。
func setup(scene_path: String, editor_interface: EditorInterface) -> void:
	path_label.text = scene_path
	open_button.pressed.connect(func() -> void:
		if editor_interface != null:
			editor_interface.open_scene_from_path(scene_path)
	)
	play_button.pressed.connect(func() -> void:
		if editor_interface != null:
			editor_interface.play_custom_scene(scene_path)
	)
