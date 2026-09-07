extends Resource

## GMornScene の設定。`.tres` として保存し、git共有する。
##
## `class_name` は付けない。付けるとエディタが一度走査するまで名前を引けず、
## 取り込んだ直後にヘッドレスで走らせると読み込みごと失敗する
## （`gmorn_debug_menu_section.gd` と同じ理由）。使う側は `preload` で直に指す。
##
## 既定の保存先は `res://assets/gmorn_scene_settings.tres`
## （`gmorn_scene_dock.gd` の `SETTINGS_PATH`）。`ProjectSettings`
## （`project.godot`）ではなく専用の `.tres` に置くのは、この部品の設定を
## `project.godot` の肥大化・他部品との名前空間の衝突から切り離すため。

## シーン一覧のルートパス。画面単位のtscnだけを走査対象にする。
@export var root_path: String = "res://scenes/screens/"
