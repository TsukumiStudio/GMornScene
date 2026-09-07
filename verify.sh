#!/bin/sh
# この部品だけを確かめる。
#
# リポジトリ直下に project.godot は置けない。ここは submodule 化していないが、
# 将来 submodule 化しても同じ手順で確かめられるよう、gmorn_window/verify.sh と
# 同じ形にしておく（一時の置き場へ最小のプロジェクトを作って、この部品を写して回す）。
set -eu

addon_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
godot_bin=${GODOT_BIN:-$(command -v godot 2>/dev/null || echo /Applications/Godot.app/Contents/MacOS/Godot)}
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

mkdir -p "$work_dir/addons/gmorn_debug_menu"
mkdir -p "$work_dir/addons/gmorn_scene"
cp "$addon_dir"/*.gd "$addon_dir"/*.gd.uid "$addon_dir"/*.tscn "$work_dir/addons/gmorn_scene/"
cp "${addon_dir%/gmorn_scene}/gmorn_debug_menu/gmorn_debug_menu_section.gd" "$work_dir/addons/gmorn_debug_menu/"
cp "$addon_dir/verify.gd" "$work_dir/verify.gd"

cat > "$work_dir/project.godot" <<'PROJECT'
config_version=5

[application]

config/name="GMornScene Verify"
config/features=PackedStringArray("4.7")
PROJECT

"$godot_bin" --headless --path "$work_dir" --script verify.gd
