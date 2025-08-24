# ============================================================================
# autoload/EventBus.gd
# グローバルイベントバス - アプリケーション全体でのシグナル管理
# ============================================================================
extends Node

# ============================================================================
# ゲーム全体のシグナル定義
# ============================================================================

# --- システムイベント ---
signal game_started
signal game_paused
signal game_resumed
signal scene_changed(from_scene: String, to_scene: String)

# --- ネットワークイベント ---
signal network_connected
signal network_disconnected  
signal network_error(error_message: String)

# --- ユーザーイベント ---
signal user_logged_in(user_data: Dictionary)
signal user_logged_out
signal user_character_changed(character_id: int)

# --- ルームイベント ---
signal room_joined(room_data: Dictionary)
signal room_left(room_id: String)
signal room_member_added(user_id: String, username: String)
signal room_member_removed(user_id: String)

# --- チャットイベント ---
signal chat_message_received(message_data: Dictionary)
signal chat_message_sent(message: String)

# --- UIイベント ---
signal ui_screen_changed(screen_name: String)
signal notification_requested(title: String, message: String, type: String)

# --- 設定イベント ---
signal settings_changed(key: String, value)

# ============================================================================
# イベント発火用ヘルパーメソッド
# ============================================================================

func emit_network_error(message: String):
	network_error.emit(message)
	print("[EventBus] Network Error: ", message)

func emit_notification(title: String, message: String, type: String = "info"):
	notification_requested.emit(title, message, type)
	print("[EventBus] Notification: [%s] %s - %s" % [type, title, message])

func emit_scene_change(from_scene: String, to_scene: String):
	scene_changed.emit(from_scene, to_scene)
	print("[EventBus] Scene Changed: %s -> %s" % [from_scene, to_scene])

# ============================================================================
# autoload/Settings.gd  
# 設定管理システム - ユーザー設定の保存・読込・管理
# ============================================================================
extends Node

# ============================================================================
# 設定データの構造定義
# ============================================================================

# デフォルト設定値
const DEFAULT_SETTINGS = {
	# 音声設定
	"audio_master_volume": 1.0,
	"audio_bgm_volume": 0.8,
	"audio_sfx_volume": 0.9,
	"audio_voice_volume": 1.0,
	
	# グラフィック設定
	"graphics_fullscreen": false,
	"graphics_vsync": true,
	"graphics_quality": "medium",  # "low", "medium", "high"
	
	# ゲーム設定
	"game_selected_character": 1,
	"game_username": "",
	"game_auto_save": true,
	
	# UI設定
	"ui_chat_opacity": 0.9,
	"ui_hud_scale": 1.0,
	"ui_language": "ja",
	
	# ネットワーク設定
	"network_server_environment": "development"  # "development", "production"
}

# 現在の設定値
var current_settings: Dictionary = {}

# 設定ファイルパス
const SETTINGS_FILE_PATH = "user://game_settings.save"

# ============================================================================
# 初期化
# ============================================================================

func _ready():
	print("[Settings] Initializing settings system...")
	load_settings()
	_apply_initial_settings()
	
	# 設定変更時のイベント接続
	EventBus.settings_changed.connect(_on_settings_changed)
	
	print("[Settings] Settings system initialized")

# ============================================================================
# 設定の読み込み・保存
# ============================================================================

# 設定を読み込む
func load_settings():
	print("[Settings] Loading settings from: ", SETTINGS_FILE_PATH)
	
	# デフォルト設定をコピー
	current_settings = DEFAULT_SETTINGS.duplicate(true)
	
	# 保存された設定を読み込み
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
		if file:
			var json_text = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_text)
			
			if parse_result == OK:
				var saved_settings = json.data
				if saved_settings is Dictionary:
					# 保存された設定でデフォルト値を上書き
					for key in saved_settings:
						if key in current_settings:
							current_settings[key] = saved_settings[key]
					print("[Settings] Settings loaded successfully")
				else:
					print("[Settings] Invalid settings file format")
			else:
				print("[Settings] Failed to parse settings file: ", json.error_string)
		else:
			print("[Settings] Failed to open settings file")
	else:
		print("[Settings] No saved settings found, using defaults")

# 設定を保存する
func save_settings():
	print("[Settings] Saving settings to: ", SETTINGS_FILE_PATH)
	
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_text = JSON.stringify(current_settings, "\t")
		file.store_string(json_text)
		file.close()
		print("[Settings] Settings saved successfully")
		return true
	else:
		print("[Settings] Failed to save settings file")
		return false

# ============================================================================
# 設定値の取得・設定
# ============================================================================

# 設定値を取得
func get_setting(key: String, default_value = null):
	if key in current_settings:
		return current_settings[key]
	elif default_value != null:
		return default_value
	else:
		print("[Settings] Warning: Setting key not found: ", key)
		return null

# 設定値を設定
func set_setting(key: String, value) -> bool:
	if key in DEFAULT_SETTINGS:
		var old_value = current_settings.get(key)
		current_settings[key] = value
		
		# 設定変更イベント発火
		EventBus.settings_changed.emit(key, value)
		
		# 自動保存（重要な設定のみ）
		if _should_auto_save(key):
			save_settings()
		
		print("[Settings] Setting changed: %s = %s (was: %s)" % [key, value, old_value])
		return true
	else:
		print("[Settings] Warning: Unknown setting key: ", key)
		return false

# 複数設定を一括設定
func set_settings(settings_dict: Dictionary):
	var changed_keys = []
	
	for key in settings_dict:
		if key in DEFAULT_SETTINGS:
			current_settings[key] = settings_dict[key]
			changed_keys.append(key)
	
	# 一括でイベント発火
	for key in changed_keys:
		EventBus.settings_changed.emit(key, current_settings[key])
	
	# 保存
	save_settings()
	print("[Settings] Bulk settings updated: ", changed_keys)

# ============================================================================
# 設定適用
# ============================================================================

# 初期設定の適用
func _apply_initial_settings():
	print("[Settings] Applying initial settings...")
	
	# 音声設定適用
	_apply_audio_settings()
	
	# グラフィック設定適用  
	_apply_graphics_settings()
	
	print("[Settings] Initial settings applied")

# 音声設定の適用
func _apply_audio_settings():
	var master_bus = AudioServer.get_bus_index("Master")
	var bgm_bus = AudioServer.get_bus_index("BGM")
	var sfx_bus = AudioServer.get_bus_index("SFX")
	
	if master_bus >= 0:
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(get_setting("audio_master_volume")))
	
	if bgm_bus >= 0:
		AudioServer.set_bus_volume_db(bgm_bus, linear_to_db(get_setting("audio_bgm_volume")))
	
	if sfx_bus >= 0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(get_setting("audio_sfx_volume")))

# グラフィック設定の適用
func _apply_graphics_settings():
	# フルスクリーン設定
	var fullscreen = get_setting("graphics_fullscreen")
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# VSync設定
	var vsync = get_setting("graphics_vsync")
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)

# ============================================================================
# イベントハンドラー
# ============================================================================

func _on_settings_changed(key: String, value):
	# 設定変更時の即座適用
	match key:
		"audio_master_volume", "audio_bgm_volume", "audio_sfx_volume":
			_apply_audio_settings()
		"graphics_fullscreen", "graphics_vsync":
			_apply_graphics_settings()

# ============================================================================
# ユーティリティメソッド
# ============================================================================

# 自動保存が必要な設定かチェック
func _should_auto_save(key: String) -> bool:
	var auto_save_keys = [
		"audio_master_volume", "audio_bgm_volume", "audio_sfx_volume",
		"graphics_fullscreen", "graphics_vsync",
		"game_selected_character", "game_username"
	]
	return key in auto_save_keys

# 設定をデフォルトに戻す
func reset_to_defaults():
	current_settings = DEFAULT_SETTINGS.duplicate(true)
	_apply_initial_settings()
	save_settings()
	print("[Settings] Settings reset to defaults")

# 設定の妥当性チェック
func validate_settings() -> bool:
	for key in DEFAULT_SETTINGS:
		if not key in current_settings:
			print("[Settings] Missing setting: ", key)
			return false
	return true

# ============================================================================
# autoload/Game.gd
# ゲーム全体の状態管理 - ユーザー情報、シーン管理、ゲーム進行
# ============================================================================
extends Node

# ============================================================================
# 現在のゲーム状態
# ============================================================================

# ゲーム状態列挙
enum GameState {
	STARTUP,        # 起動中
	LOGIN,          # ログイン画面
	CHARACTER_SELECT, # キャラクター選択
	IN_GAME,        # ゲーム中
	SETTINGS,       # 設定画面
	LOADING         # ローディング中
}

# 現在の状態
var current_state: GameState = GameState.STARTUP
var previous_state: GameState = GameState.STARTUP

# ============================================================================
# ユーザーデータ
# ============================================================================

# 現在のユーザー情報
var current_user: Dictionary = {}
var is_logged_in: bool = false
var auth_token: String = ""

# 選択中のキャラクター
var selected_character_id: int = 1
var selected_character_data: Dictionary = {}

# ============================================================================
# シーン管理
# ============================================================================

# 現在のシーン情報
var current_scene_path: String = ""
var current_scene_name: String = ""
var previous_scene_path: String = ""

# シーン遷移中フラグ
var is_scene_changing: bool = false

# ============================================================================
# プレイヤー管理（マルチプレイヤー用）
# ============================================================================

# 現在の部屋にいるプレイヤー一覧
var connected_players: Dictionary = {}  # user_id -> player_data

# 自分のプレイヤーデータ
var my_player_data: Dictionary = {}

# ============================================================================
# 初期化
# ============================================================================

func _ready():
	print("[Game] Initializing game manager...")
	
	# 初期ユーザーデータ設定
	_initialize_user_data()
	
	# シーンの初期設定
	_initialize_scene_management()
	
	# イベント接続
	_connect_events()
	
	# ゲーム開始
	_start_game()
	
	print("[Game] Game manager initialized")

func _initialize_user_data():
	# 設定からユーザー情報を復元
	var saved_username = Settings.get_setting("game_username", "")
	var saved_character = Settings.get_setting("game_selected_character", 1)
	
	selected_character_id = saved_character
	
	if saved_username != "":
		current_user["username"] = saved_username
		print("[Game] Restored username: ", saved_username)

func _initialize_scene_management():
	# 現在のシーン情報を取得
	var scene = get_tree().current_scene
	if scene:
		current_scene_path = scene.scene_file_path
		current_scene_name = scene.name
		print("[Game] Current scene: ", current_scene_name, " (", current_scene_path, ")")

func _connect_events():
	# EventBusのシグナル接続
	EventBus.user_logged_in.connect(_on_user_logged_in)
	EventBus.user_logged_out.connect(_on_user_logged_out)
	EventBus.user_character_changed.connect(_on_character_changed)
	EventBus.scene_changed.connect(_on_scene_changed)

func _start_game():
	# ゲーム開始状態を決定
	if is_logged_in and current_user.has("user_id"):
		change_state(GameState.IN_GAME)
	else:
		change_state(GameState.LOGIN)
	
	EventBus.game_started.emit()

# ============================================================================
# 状態管理
# ============================================================================

# ゲーム状態を変更
func change_state(new_state: GameState):
	if new_state == current_state:
		return
	
	previous_state = current_state
	current_state = new_state
	
	print("[Game] State changed: %s -> %s" % [_state_to_string(previous_state), _state_to_string(current_state)])
	
	# 状態変更時の処理
	match current_state:
		GameState.LOGIN:
			_on_enter_login_state()
		GameState.CHARACTER_SELECT:
			_on_enter_character_select_state()
		GameState.IN_GAME:
			_on_enter_in_game_state()
		GameState.SETTINGS:
			_on_enter_settings_state()

# 状態を文字列に変換
func _state_to_string(state: GameState) -> String:
	match state:
		GameState.STARTUP: return "STARTUP"
		GameState.LOGIN: return "LOGIN"
		GameState.CHARACTER_SELECT: return "CHARACTER_SELECT"
		GameState.IN_GAME: return "IN_GAME"
		GameState.SETTINGS: return "SETTINGS"
		GameState.LOADING: return "LOADING"
		_: return "UNKNOWN"

# ============================================================================
# シーン管理
# ============================================================================

# シーンを変更
func change_scene(scene_path: String, loading_screen: bool = true):
	if is_scene_changing:
		print("[Game] Scene change already in progress")
		return false
	
	print("[Game] Changing scene to: ", scene_path)
	is_scene_changing = true
	
	# ローディング画面表示（オプション）
	if loading_screen:
		change_state(GameState.LOADING)
	
	# シーン変更前の処理
	var old_scene_path = current_scene_path
	previous_scene_path = current_scene_path
	
	# シーン変更実行
	var result = get_tree().change_scene_to_file(scene_path)
	
	if result == OK:
		current_scene_path = scene_path
		current_scene_name = scene_path.get_file().get_basename()
		
		# イベント発火
		EventBus.emit_scene_change(old_scene_path, scene_path)
		
		is_scene_changing = false
		print("[Game] Scene changed successfully")
		return true
	else:
		is_scene_changing = false
		print("[Game] Failed to change scene: ", result)
		return false

# メインゲームシーンに移動
func go_to_main_game():
	change_scene("res://scenes/worlds/MainTown.tscn")
	change_state(GameState.IN_GAME)

# ログイン画面に移動
func go_to_login():
	change_scene("res://scenes/ui/screens/LoginScreen.tscn")
	change_state(GameState.LOGIN)

# キャラクター選択画面に移動
func go_to_character_select():
	change_scene("res://scenes/ui/screens/CharacterSelect.tscn")
	change_state(GameState.CHARACTER_SELECT)

# ============================================================================
# ユーザー管理
# ============================================================================

# ユーザーログイン処理
func login_user(user_data: Dictionary, token: String = ""):
	current_user = user_data.duplicate()
	auth_token = token
	is_logged_in = true
	
	# キャラクター情報も設定
	if user_data.has("character_id"):
		selected_character_id = user_data["character_id"]
		Settings.set_setting("game_selected_character", selected_character_id)
	
	# ユーザー名を保存
	if user_data.has("username"):
		Settings.set_setting("game_username", user_data["username"])
	
	print("[Game] User logged in: ", current_user.get("username", "Unknown"))
	EventBus.user_logged_in.emit(current_user)

# ユーザーログアウト処理
func logout_user():
	print("[Game] User logged out: ", current_user.get("username", "Unknown"))
	
	current_user.clear()
	auth_token = ""
	is_logged_in = false
	connected_players.clear()
	
	EventBus.user_logged_out.emit()
	
	# ログイン画面に戻る
	go_to_login()

# キャラクター選択
func select_character(character_id: int, character_data: Dictionary = {}):
	selected_character_id = character_id
	selected_character_data = character_data.duplicate()
	
	# 設定に保存
	Settings.set_setting("game_selected_character", character_id)
	
	# ユーザーデータも更新
	if is_logged_in:
		current_user["character_id"] = character_id
	
	print("[Game] Character selected: ", character_id)
	EventBus.user_character_changed.emit(character_id)

# ============================================================================
# プレイヤー管理（マルチプレイヤー）
# ============================================================================

# プレイヤーを追加
func add_player(user_id: String, player_data: Dictionary):
	connected_players[user_id] = player_data.duplicate()
	print("[Game] Player added: ", player_data.get("username", "Unknown"), " (", user_id, ")")

# プレイヤーを削除
func remove_player(user_id: String):
	if user_id in connected_players:
		var username = connected_players[user_id].get("username", "Unknown")
		connected_players.erase(user_id)
		print("[Game] Player removed: ", username, " (", user_id, ")")

# プレイヤー情報を取得
func get_player(user_id: String) -> Dictionary:
	return connected_players.get(user_id, {})

# 全プレイヤー一覧を取得
func get_all_players() -> Dictionary:
	return connected_players.duplicate()

# ============================================================================
# イベントハンドラー
# ============================================================================

func _on_user_logged_in(user_data: Dictionary):
	# ログイン後はキャラクター選択またはゲーム画面へ
	if user_data.has("character_id") and user_data["character_id"] > 0:
		go_to_main_game()
	else:
		go_to_character_select()

func _on_user_logged_out():
	# ログアウト処理はlogout_user()で実行済み
	pass

func _on_character_changed(character_id: int):
	# キャラクター変更後はゲーム画面へ
	if current_state == GameState.CHARACTER_SELECT:
		go_to_main_game()

func _on_scene_changed(from_scene: String, to_scene: String):
	# シーン変更時の追加処理があればここに
	pass

# ============================================================================
# 状態別の処理
# ============================================================================

func _on_enter_login_state():
	print("[Game] Entering login state")

func _on_enter_character_select_state():
	print("[Game] Entering character select state")

func _on_enter_in_game_state():
	print("[Game] Entering in-game state")

func _on_enter_settings_state():
	print("[Game] Entering settings state")

# ============================================================================
# ユーティリティメソッド
# ============================================================================

# 現在の状態を取得
func get_current_state() -> GameState:
	return current_state

# ログイン状態を確認
func is_user_logged_in() -> bool:
	return is_logged_in and current_user.has("user_id")

# 現在のユーザーIDを取得
func get_current_user_id() -> String:
	return current_user.get("user_id", "")

# 現在のユーザー名を取得  
func get_current_username() -> String:
	return current_user.get("username", "")

# 認証トークンを取得
func get_auth_token() -> String:
	return auth_token

# デバッグ情報を出力
func print_debug_info():
	print("=== Game Debug Info ===")
	print("State: ", _state_to_string(current_state))
	print("Logged in: ", is_logged_in)
	print("User: ", current_user)
	print("Character: ", selected_character_id)
	print("Scene: ", current_scene_name)
	print("Players: ", connected_players.size())
	print("=======================")