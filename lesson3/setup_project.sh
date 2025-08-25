#!/bin/bash

# 最小限Godotプロジェクト構造セットアップスクリプト
# Usage: ./setup_project.sh [project_name]

PROJECT_NAME=${1:-"GodotProject"}

echo "Creating Godot project: ${PROJECT_NAME}"

# プロジェクトディレクトリ作成
mkdir -p "${PROJECT_NAME}"
cd "${PROJECT_NAME}"

# ディレクトリ構造作成
echo "Creating directory structure..."
mkdir -p autoload
mkdir -p assets/{characters,environments,ui,audio}
mkdir -p scenes/{main,player,worlds,ui}
mkdir -p scripts/{core,network,player,ui}
mkdir -p data/config

# project.godot作成
echo "Creating project.godot..."
cat > project.godot << EOF
[application]

config/name="${PROJECT_NAME}"
run/main_scene="res://scenes/main/Main.tscn"

[autoload]

Game="*res://autoload/Game.gd"
Net="*res://autoload/Net.gd"
Audio="*res://autoload/Audio.gd"

[display]

window/size/viewport_width=1920
window/size/viewport_height=1080

[input]

move_forward={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":87,"key_label":0,"unicode":119,"echo":false,"script":null)]
}
move_backward={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":83,"key_label":0,"unicode":115,"echo":false,"script":null)]
}
move_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":97,"echo":false,"script":null)]
}
move_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":68,"key_label":0,"unicode":100,"echo":false,"script":null)]
}
EOF

# .gitignore作成
cat > .gitignore << EOF
.import/
export.cfg
export_presets.cfg
.import
*.tmp
*.log
.DS_Store
Thumbs.db
EOF

# 空のAutoload gdファイル作成
echo "Creating autoload scripts..."
cat > autoload/Game.gd << 'EOF'
extends Node

var current_user: Dictionary = {}
var game_state: String = "menu"

func _ready():
    print("Game Manager initialized")
EOF

cat > autoload/Net.gd << 'EOF'
extends Node

var connected: bool = false
var websocket: WebSocketPeer

func _ready():
    print("Network Manager initialized")
    websocket = WebSocketPeer.new()
EOF

cat > autoload/Audio.gd << 'EOF'
extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
    print("Audio Manager initialized")
EOF

# 空のコアスクリプト作成
echo "Creating core scripts..."
cat > scripts/core/Constants.gd << 'EOF'
extends Node

const SERVER_URL = "ws://localhost:8080"
const PLAYER_SPEED = 5.0
EOF

cat > scripts/core/Utils.gd << 'EOF'
extends Node

func format_time(seconds: float) -> String:
    return str(seconds)
EOF

cat > scripts/player/PlayerController.gd << 'EOF'
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
        
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    if input_dir != Vector2.ZERO:
        velocity.x = input_dir.x * SPEED
        velocity.z = input_dir.y * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()
EOF

cat > scripts/ui/MainMenu.gd << 'EOF'
extends Control

func _ready():
    pass

func _on_start_button_pressed():
    Game.change_scene("res://scenes/worlds/MainWorld.tscn")
EOF

# 基本シーンファイル作成
echo "Creating scene files..."

# Main.tscn (メインシーン)
cat > scenes/main/Main.tscn << 'EOF'
[gd_scene load_steps=2 format=3 uid="uid://main_scene"]

[ext_resource type="Script" path="res://scripts/ui/MainMenu.gd" id="1"]

[node name="Main" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource("1")

[node name="CenterContainer" type="CenterContainer" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0

[node name="VBoxContainer" type="VBoxContainer" parent="CenterContainer"]
layout_mode = 2

[node name="Title" type="Label" parent="CenterContainer/VBoxContainer"]
layout_mode = 2
text = "Godot Virtual Space"
horizontal_alignment = 1

[node name="StartButton" type="Button" parent="CenterContainer/VBoxContainer"]
layout_mode = 2
text = "Start"

[connection signal="pressed" from="CenterContainer/VBoxContainer/StartButton" to="." method="_on_start_button_pressed"]
EOF

# Player.tscn (プレイヤーシーン)
cat > scenes/player/Player.tscn << 'EOF'
[gd_scene load_steps=3 format=3 uid="uid://player_scene"]

[ext_resource type="Script" path="res://scripts/player/PlayerController.gd" id="1"]

[sub_resource type="CapsuleShape3D" id="CapsuleShape3D_1"]

[node name="Player" type="CharacterBody3D"]
script = ExtResource("1")

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)
shape = SubResource("CapsuleShape3D_1")

[node name="Camera3D" type="Camera3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 0.866025, 0.5, 0, -0.5, 0.866025, 0, 2, 3)
EOF

# MainWorld.tscn (メインワールドシーン)
cat > scenes/worlds/MainWorld.tscn << 'EOF'
[gd_scene load_steps=4 format=3 uid="uid://world_scene"]

[ext_resource type="PackedScene" uid="uid://player_scene" path="res://scenes/player/Player.tscn" id="1"]

[sub_resource type="BoxShape3D" id="BoxShape3D_1"]
size = Vector3(20, 1, 20)

[sub_resource type="BoxMesh" id="BoxMesh_1"]
size = Vector3(20, 1, 20)

[node name="MainWorld" type="Node3D"]

[node name="Ground" type="StaticBody3D" parent="."]

[node name="CollisionShape3D" type="CollisionShape3D" parent="Ground"]
shape = SubResource("BoxShape3D_1")

[node name="MeshInstance3D" type="MeshInstance3D" parent="Ground"]
mesh = SubResource("BoxMesh_1")

[node name="Player" parent="." instance=ExtResource("1")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2, 0)

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(0.707107, -0.5, 0.5, 0, 0.707107, 0.707107, -0.707107, -0.5, 0.5, 0, 5, 0)
EOF

# 設定ファイル作成
cat > data/config/settings.json << 'EOF'
{
  "server_url": "ws://localhost:8080",
  "default_volume": 0.8,
  "fullscreen": false
}
EOF

# プレースホルダーファイル作成
find . -type d -empty -exec touch {}/.gitkeep \;

echo "Project setup complete!"
echo ""
echo "Structure created:"
echo "  project.godot     - Main project file"
echo "  autoload/         - Global scripts (Game.gd, Net.gd, Audio.gd)"
echo "  scenes/           - Scene files (Main.tscn, Player.tscn, MainWorld.tscn)"
echo "  scripts/          - Logic scripts"
echo "  assets/           - Resource files"
echo "  data/             - Configuration files"
echo ""
echo "To open the project:"
echo "  cd ${PROJECT_NAME}"
echo "  godot project.godot"