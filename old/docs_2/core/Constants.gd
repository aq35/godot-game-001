# ============================================================================
# scripts/core/Constants.gd  
# アプリケーション全体で使用する定数定義
# ============================================================================
class_name GameConstants

# ============================================================================
# ゲーム基本定数
# ============================================================================

# アプリケーション情報
const APP_NAME: String = "3D Multiplayer Game"
const APP_VERSION: String = "0.1.0"
const BUILD_TYPE: String = "development"  # development, production

# ネットワーク設定
const DEFAULT_SERVER_TIMEOUT: float = 30.0
const MAX_RECONNECT_ATTEMPTS: int = 5
const RECONNECT_DELAY: float = 2.0

# プレイヤー関連
const MAX_PLAYERS_PER_ROOM: int = 20
const DEFAULT_PLAYER_SPEED: float = 5.0
const PLAYER_SYNC_RATE: int = 10  # 10Hz (100ms間隔)

# キャラクター関連
const MAX_CHARACTERS: int = 10
const DEFAULT_CHARACTER_ID: int = 1

# チャット関連  
const MAX_CHAT_MESSAGE_LENGTH: int = 200
const CHAT_HISTORY_LIMIT: int = 100
const CHAT_BUBBLE_DURATION: float = 5.0

# UI関連
const UI_FADE_DURATION: float = 0.3
const NOTIFICATION_DURATION: float = 3.0
const LOADING_MIN_DURATION: float = 1.0

# ============================================================================
# パス定数
# ============================================================================

# シーンパス
const SCENE_MAIN: String = "res://scenes/main/Main.tscn"
const SCENE_LOGIN: String = "res://scenes/ui/screens/LoginScreen.tscn"
const SCENE_CHARACTER_SELECT: String = "res://scenes/ui/screens/CharacterSelect.tscn"
const SCENE_LOADING: String = "res://scenes/ui/screens/LoadingScreen.tscn"
const SCENE_SETTINGS: String = "res://scenes/ui/screens/SettingsScreen.tscn"

# ワールドシーンパス
const SCENE_MAIN_TOWN: String = "res://scenes/worlds/MainTown.tscn"
const SCENE_FOREST_AREA: String = "res://scenes/worlds/ForestArea.tscn"
const SCENE_BEACH_AREA: String = "res://scenes/worlds/BeachArea.tscn"

# アセットパス
const ASSETS_CHARACTERS: String = "res://assets/characters/"
const ASSETS_UI: String = "res://assets/ui/"
const ASSETS_AUDIO: String = "res://assets/audio/"

# 設定ファイルパス
const CONFIG_SERVER: String = "res://data/config/server_config.json"
const CONFIG_GAME: String = "res://data/config/game_settings.json"
const CONFIG_CHARACTERS: String = "res://data/config/character_list.json"

# ============================================================================
# 入力アクション名
# ============================================================================

const INPUT_MOVE_FORWARD: String = "move_forward"
const INPUT_MOVE_BACKWARD: String = "move_backward"
const INPUT_MOVE_LEFT: String = "move_left"
const INPUT_MOVE_RIGHT: String = "move_right"
const INPUT_JUMP: String = "jump"
const INPUT_RUN: String = "run"

const INPUT_CAMERA_UP: String = "camera_up"
const INPUT_CAMERA_DOWN: String = "camera_down"
const INPUT_CAMERA_LEFT: String = "camera_left"
const INPUT_CAMERA_RIGHT: String = "camera_right"

const INPUT_CHAT: String = "open_chat"
const INPUT_MENU: String = "open_menu"
const INPUT_SETTINGS: String = "open_settings"

const INPUT_ACTION_WAVE: String = "action_wave"
const INPUT_ACTION_DANCE: String = "action_dance"
const INPUT_ACTION_SIT: String = "action_sit"

# ============================================================================
# カラー定数
# ============================================================================

const COLOR_UI_PRIMARY: Color = Color("#4A90E2")
const COLOR_UI_SECONDARY: Color = Color("#7ED321")
const COLOR_UI_ACCENT: Color = Color("#F5A623")
const COLOR_UI_ERROR: Color = Color("#D0021B")
const COLOR_UI_WARNING: Color = Color("#F8E71C")
const COLOR_UI_SUCCESS: Color = Color("#7ED321")

const COLOR_CHAT_USER: Color = Color("#FFFFFF")
const COLOR_CHAT_SYSTEM: Color = Color("#CCCCCC")
const COLOR_CHAT_ERROR: Color = Color("#FF6B6B")
const COLOR_CHAT_NOTIFICATION: Color = Color("#4ECDC4")

# ============================================================================
# レイヤー・グループ定数
# ============================================================================

# 衝突レイヤー
const LAYER_PLAYER: int = 1
const LAYER_ENVIRONMENT: int = 2
const LAYER_INTERACT: int = 3
const LAYER_UI: int = 4

# ノードグループ
const GROUP_PLAYERS: String = "players"
const GROUP_REMOTE_PLAYERS: String = "remote_players"
const GROUP_INTERACTABLES: String = "interactables"
const GROUP_UI_ELEMENTS: String = "ui_elements"

# ============================================================================
# scripts/core/GameTypes.gd
# ゲームで使用するデータ型・構造体の定義
# ============================================================================
class_name GameTypes

# ============================================================================
# 基本データ構造
# ============================================================================

# ユーザーデータ
class UserData:
	var user_id: String
	var username: String
	var email: String
	var character_id: int
	var created_at: String
	var last_login: String
	var is_online: bool
	
	func _init(id: String = "", name: String = "", char_id: int = 1):
		user_id = id
		username = name
		character_id = char_id
		email = ""
		created_at = ""
		last_login = ""
		is_online = false
	
	func to_dict() -> Dictionary:
		return {
			"user_id": user_id,
			"username": username,
			"email": email,
			"character_id": character_id,
			"created_at": created_at,
			"last_login": last_login,
			"is_online": is_online
		}
	
	func from_dict(data: Dictionary):
		user_id = data.get("user_id", "")
		username = data.get("username", "")
		email = data.get("email", "")
		character_id = data.get("character_id", 1)
		created_at = data.get("created_at", "")
		last_login = data.get("last_login", "")
		is_online = data.get("is_online", false)

# キャラクター情報
class CharacterData:
	var id: int
	var name: String
	var model_path: String
	var preview_texture_path: String
	var description: String
	var is_available: bool
	
	func _init(char_id: int = 1, char_name: String = ""):
		id = char_id
		name = char_name
		model_path = ""
		preview_texture_path = ""
		description = ""
		is_available = true
	
	func to_dict() -> Dictionary:
		return {
			"id": id,
			"name": name,
			"model_path": model_path,
			"preview_texture_path": preview_texture_path,
			"description": description,
			"is_available": is_available
		}

# プレイヤー位置データ
class PlayerPositionData:
	var user_id: String
	var username: String
	var position: Vector3
	var rotation: Vector3
	var velocity: Vector3
	var animation_state: int
	var timestamp: float
	var room_id: String
	
	func _init():
		user_id = ""
		username = ""
		position = Vector3.ZERO
		rotation = Vector3.ZERO
		velocity = Vector3.ZERO
		animation_state = 0
		timestamp = 0.0
		room_id = ""
	
	func to_dict() -> Dictionary:
		return {
			"user_id": user_id,
			"username": username,
			"position": {"x": position.x, "y": position.y, "z": position.z},
			"rotation": {"x": rotation.x, "y": rotation.y, "z": rotation.z},
			"velocity": {"x": velocity.x, "y": velocity.y, "z": velocity.z},
			"animation_state": animation_state,
			"timestamp": timestamp,
			"room_id": room_id
		}

# チャットメッセージ
class ChatMessageData:
	var message_id: String
	var user_id: String
	var username: String
	var message: String
	var room_id: String
	var message_type: String  # "normal", "system", "private", "notification"
	var timestamp: int
	var is_read: bool
	
	func _init():
		message_id = ""
		user_id = ""
		username = ""
		message = ""
		room_id = ""
		message_type = "normal"
		timestamp = Time.get_unix_time_from_system()
		is_read = false
	
	func to_dict() -> Dictionary:
		return {
			"message_id": message_id,
			"user_id": user_id,
			"username": username,
			"message": message,
			"room_id": room_id,
			"message_type": message_type,
			"timestamp": timestamp,
			"is_read": is_read
		}

# ============================================================================
# 列挙型
# ============================================================================

# ネットワーク接続状態
enum NetworkState {
	DISCONNECTED,    # 未接続
	CONNECTING,      # 接続中
	CONNECTED,       # 接続済み
	RECONNECTING,    # 再接続中
	ERROR           # エラー状態
}

# アニメーション状態
enum AnimationState {
	IDLE = 0,        # 待機
	WALK = 1,        # 歩行
	RUN = 2,         # 走行
	JUMP = 3,        # ジャンプ
	LAND = 4,        # 着地
	WAVE = 5,        # 手振り
	SIT = 6,         # 座る
	DANCE = 7,       # ダンス
	CHAT = 8         # チャット中
}

# ルーム種類
enum RoomType {
	PUBLIC,          # パブリック
	PRIVATE,         # プライベート
	GROUP           # グループ
}

# ルーム権限
enum RoomPermission {
	VISITOR,         # 訪問者
	MEMBER,          # メンバー
	MODERATOR,       # モデレーター
	OWNER           # オーナー
}

# メッセージタイプ
enum MessageType {
	NORMAL,          # 通常メッセージ
	SYSTEM,          # システムメッセージ
	PRIVATE,         # プライベートメッセージ
	NOTIFICATION,    # 通知
	ERROR           # エラーメッセージ
}

# ============================================================================
# ユーティリティ関数
# ============================================================================

# Vector3を辞書に変換
static func vector3_to_dict(vec: Vector3) -> Dictionary:
	return {"x": vec.x, "y": vec.y, "z": vec.z}

# 辞書をVector3に変換
static func dict_to_vector3(dict: Dictionary) -> Vector3:
	return Vector3(
		dict.get("x", 0.0),
		dict.get("y", 0.0), 
		dict.get("z", 0.0)
	)

# Unix時刻を読みやすい形式に変換
static func timestamp_to_string(timestamp: int) -> String:
	var datetime = Time.get_datetime_dict_from_unix_time(timestamp)
	return "%04d-%02d-%02d %02d:%02d:%02d" % [
		datetime.year, datetime.month, datetime.day,
		datetime.hour, datetime.minute, datetime.second
	]

# ランダムなUUID生成（簡易版）
static func generate_uuid() -> String:
	var uuid = ""
	for i in range(32):
		if i == 8 or i == 12 or i == 16 or i == 20:
			uuid += "-"
		uuid += "%x" % (randi() % 16)
	return uuid

# ============================================================================
# scripts/core/Utils.gd  
# 汎用ユーティリティ関数集
# ============================================================================
class_name GameUtils

# ============================================================================
# ファイル・IO関連
# ============================================================================

# JSONファイルを読み込み
static func load_json_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		print("[Utils] File not found: ", file_path)
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("[Utils] Failed to open file: ", file_path)
		return {}
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		print("[Utils] JSON parse error in ", file_path, ": ", json.error_string)
		return {}
	
	return json.data if json.data is Dictionary else {}

# JSONファイルに保存
static func save_json_file(file_path: String, data: Dictionary) -> bool:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if not file:
		print("[Utils] Failed to create file: ", file_path)
		return false
	
	var json_text = JSON.stringify(data, "\t")
	file.store_string(json_text)
	file.close()
	
	print("[Utils] JSON saved to: ", file_path)
	return true

# ============================================================================
# 文字列関連
# ============================================================================

# 文字列を指定長で切り詰める
static func truncate_string(text: String, max_length: int) -> String:
	if text.length() <= max_length:
		return text
	return text.substr(0, max_length - 3) + "..."

# HTMLタグを除去
static func strip_html_tags(text: String) -> String:
	var regex = RegEx.new()
	regex.compile("<[^>]*>")
	return regex.sub(text, "", true)

# 文字列をサニタイズ（基本的なエスケープ）
static func sanitize_string(text: String) -> String:
	return text.replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;")

# ============================================================================
# 数値・計算関連
# ============================================================================

# 値を指定範囲内にクランプ
static func clamp_float(value: float, min_val: float, max_val: float) -> float:
	return max(min_val, min(max_val, value))

# 線形補間（カスタム）
static func lerp_custom(from: float, to: float, weight: float) -> float:
	return from + (to - from) * clamp_float(weight, 0.0, 1.0)

# Vector3の線形補間
static func lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3:
	return Vector3(
		lerp_custom(from.x, to.x, weight),
		lerp_custom(from.y, to.y, weight),
		lerp_custom(from.z, to.z, weight)
	)

# 角度の補間（-180〜180度の範囲で）
static func lerp_angle_degrees(from: float, to: float, weight: float) -> float:
	var diff = fmod(to - from, 360.0)
	if diff > 180.0:
		diff -= 360.0
	elif diff < -180.0:
		diff += 360.0
	return from + diff * clamp_float(weight, 0.0, 1.0)

# ============================================================================
# 色・UI関連
# ============================================================================

# 色をHTML形式に変換
static func color_to_html(color: Color) -> String:
	return "#%02x%02x%02x%02x" % [
		int(color.r * 255),
		int(color.g * 255),
		int(color.b * 255),
		int(color.a * 255)
	]

# HTML形式を色に変換
static func html_to_color(html: String) -> Color:
	if html.length() < 7 or not html.begins_with("#"):
		return Color.WHITE
	
	var r = html.substr(1, 2).hex_to_int() / 255.0
	var g = html.substr(3, 2).hex_to_int() / 255.0  
	var b = html.substr(5, 2).hex_to_int() / 255.0
	var a = 1.0
	
	if html.length() >= 9:
		a = html.substr(7, 2).hex_to_int() / 255.0
	
	return Color(r, g, b, a)

# ============================================================================
# 配列・辞書関連
# ============================================================================

# 配列からランダム要素を取得
static func get_random_element(array: Array):
	if array.is_empty():
		return null
	return array[randi() % array.size()]

# 辞書を安全に複製（深いコピー）
static func deep_duplicate_dict(dict: Dictionary) -> Dictionary:
	var result = {}
	for key in dict:
		var value = dict[key]
		if value is Dictionary:
			result[key] = deep_duplicate_dict(value)
		elif value is Array:
			result[key] = value.duplicate(true)
		else:
			result[key] = value
	return result

# ============================================================================
# シーン・ノード関連
# ============================================================================

# ノードが有効かチェック
static func is_node_valid(node: Node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()

# 子ノードを名前で検索（再帰）
static func find_child_recursive(parent: Node, child_name: String) -> Node:
	if not is_node_valid(parent):
		return null
	
	for child in parent.get_children():
		if child.name == child_name:
			return child
		
		var found = find_child_recursive(child, child_name)
		if found:
			return found
	
	return null

# ノードを安全に削除
static func safe_free_node(node: Node):
	if is_node_valid(node):
		node.queue_free()

# ============================================================================
# デバッグ関連
# ============================================================================

# デバッグメッセージ出力（条件付き）
static func debug_print(message: String, condition: bool = true):
	if condition and OS.is_debug_build():
		print("[DEBUG] ", message)

# パフォーマンス計測開始
static func start_performance_timer() -> int:
	return Time.get_ticks_msec()

# パフォーマンス計測終了・結果表示
static func end_performance_timer(start_time: int, operation_name: String = "Operation"):
	var elapsed = Time.get_ticks_msec() - start_time
	debug_print("%s took %d ms" % [operation_name, elapsed])

# ============================================================================
# プラットフォーム関連
# ============================================================================

# 現在のプラットフォームを取得
static func get_platform_name() -> String:
	var platform = OS.get_name()
	match platform:
		"Windows": return "windows"
		"macOS": return "macos"
		"Linux": return "linux"
		"Android": return "android"
		"iOS": return "ios"
		_: return "unknown"

# モバイルプラットフォームかチェック
static func is_mobile_platform() -> bool:
	var platform = get_platform_name()
	return platform in ["android", "ios"]

# デスクトッププラットフォームかチェック
static func is_desktop_platform() -> bool:
	var platform = get_platform_name()
	return platform in ["windows", "macos", "linux"]