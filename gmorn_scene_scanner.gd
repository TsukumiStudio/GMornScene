extends RefCounted

## 指定ルート配下の `.tscn` を再帰走査する。
##
## 走査は `addons/tscn_inheritance_tree/tscn_inheritance_scanner.gd` の
## `_find_scene_files` と同じ形（`DirAccess` で子ファイル→子ディレクトリの順に集め、
## ドット始まりのディレクトリは飛ばす）にしてある。この部品専用の走査方式を
## 新しく作らない。

## `root_path` 以下の `.tscn` をパス昇順で返す。`root_path` が開けない場合は空配列。
static func find_scenes(root_path: String) -> PackedStringArray:
	var results := PackedStringArray()
	var directory := DirAccess.open(root_path)
	if directory == null:
		return results
	for file_name: String in directory.get_files():
		if file_name.get_extension() == "tscn":
			results.append(root_path.path_join(file_name))
	for child_name: String in directory.get_directories():
		if child_name.begins_with("."):
			continue
		results.append_array(find_scenes(root_path.path_join(child_name)))
	results.sort()
	return results
