extends Node

# UI関連シグナル
signal ui_screen_changed(screen_name: String)
signal ui_dialog_opened(dialog_name: String)
signal ui_dialog_closed(dialog_name: String)
signal ui_notification_shown(message: String, type: String)

# ネットワーク関連シグナル
signal network_connected()
signal network_disconnected()
signal network_error(error_message: String)
signal message_received(message: Dictionary)

# プレイヤー関連シグナル
signal player_spawned(player_id: String)
signal player_despawned(player_id: String)
signal player_moved(player_id: String, position: Vector3)
signal player_animation_changed(player_id: String, animation: String)

# チャット関連シグナル
signal chat_message_received(message: Dictionary)
signal chat_room_changed(room_id: String)

# ルーム関連シグナル
signal room_created(room_data: Dictionary)
signal room_joined(room_id: String)
signal room_left(room_id: String)
signal room_member_joined(room_id: String, user_id: String)
signal room_member_left(room_id: String, user_id: String)

# システム関連シグナル
signal settings_changed(category: String, key: String, value)
signal scene_changed(scene_name: String)

func _ready():
    print("EventBus initialized")
