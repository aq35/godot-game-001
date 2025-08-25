# Game.gd - ゲーム全体の状態管理
extends Node

# 現在のユーザー情報
var current_user: Dictionary = {}

# ゲーム状態
var game_state: String = "menu"
var current_scene_name: String = ""

# プレイヤーデータ
var player_data: Dictionary = {}

func _ready():
    print("Game Manager initialized")

func set_current_user(user_info: Dictionary):
    current_user = user_info
    print("Current user set: ", user_info.get("name", "Unknown"))

func change_scene(scene_path: String):
    print("Changing scene to: ", scene_path)
    current_scene_name = scene_path
    get_tree().change_scene_to_file(scene_path)

func set_game_state(new_state: String):
    var old_state = game_state
    game_state = new_state
    print("Game state changed: ", old_state, " -> ", new_state)
