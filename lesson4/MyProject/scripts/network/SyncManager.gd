extends Node
class_name SyncManager

var sync_interval: float = 0.1  # 10 FPS
var last_sync_time: float = 0.0
var position_threshold: float = 0.1
var rotation_threshold: float = 0.05

var remote_players: Dictionary = {}

signal player_synced(player_id: String, position: Vector3, rotation: Vector3)

func _ready():
    set_process(false)

func start_sync():
    set_process(true)

func stop_sync():
    set_process(false)

func _process(delta):
    var current_time = Time.get_time_from_system()
    
    if current_time - last_sync_time >= sync_interval:
        _sync_local_player()
        _interpolate_remote_players(delta)
        last_sync_time = current_time

func _sync_local_player():
    # ローカルプレイヤーの位置同期
    if not Game.current_user.has("id"):
        return
    
    var player_id = Game.current_user.id
    # TODO: 実際のプレイヤーノードから位置を取得
    var position = Vector3.ZERO
    var rotation = Vector3.ZERO
    
    var message = NetworkMessages.create_player_position_message(player_id, position, rotation)
    Net.send_message(message)

func _interpolate_remote_players(delta):
    # リモートプレイヤーの補間処理
    for player_id in remote_players.keys():
        var player_data = remote_players[player_id]
        # TODO: 実際の補間処理を実装
        pass

func update_remote_player(player_id: String, position: Vector3, rotation: Vector3):
    if not remote_players.has(player_id):
        remote_players[player_id] = {}
    
    remote_players[player_id]["target_position"] = position
    remote_players[player_id]["target_rotation"] = rotation
    remote_players[player_id]["last_update"] = Time.get_time_from_system()
    
    player_synced.emit(player_id, position, rotation)

func remove_remote_player(player_id: String):
    remote_players.erase(player_id)
