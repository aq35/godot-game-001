extends Node
class_name PlayerSync

@export var interpolation_speed: float = 10.0
@export var sync_threshold: float = 0.1

var target_position: Vector3
var target_rotation: Vector3
var last_update_time: float

var player_node: CharacterBody3D

func _ready():
    player_node = get_parent() as CharacterBody3D

func _process(delta):
    if player_node == null:
        return
    
    # 位置補間
    var current_pos = player_node.global_position
    var distance = current_pos.distance_to(target_position)
    
    if distance > sync_threshold:
        player_node.global_position = player_node.global_position.lerp(target_position, interpolation_speed * delta)
    
    # 回転補間
    player_node.rotation = player_node.rotation.lerp(target_rotation, interpolation_speed * delta)

func update_sync_data(position: Vector3, rotation: Vector3):
    target_position = position
    target_rotation = rotation
    last_update_time = Time.get_time_from_system()

func is_sync_data_recent(max_age: float = 1.0) -> bool:
    return Time.get_time_from_system() - last_update_time < max_age
