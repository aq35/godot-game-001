extends Node
class_name AnimationController

@export var speed_walk_threshold: float = 1.0
@export var speed_run_threshold: float = 4.0

var animation_player: AnimationPlayer
var character_body: CharacterBody3D
var current_state: AnimationStates.State = AnimationStates.State.IDLE

signal animation_changed(new_animation: String)

func _ready():
    animation_player = get_node("../AnimationPlayer")
    character_body = get_parent() as CharacterBody3D

func _process(_delta):
    if character_body == null or animation_player == null:
        return
    
    var new_state = _calculate_animation_state()
    
    if new_state != current_state:
        _change_animation_state(new_state)

func _calculate_animation_state() -> AnimationStates.State:
    var velocity = character_body.velocity
    var speed = Vector2(velocity.x, velocity.z).length()
    
    if not character_body.is_on_floor():
        if velocity.y > 0:
            return AnimationStates.State.JUMP
        else:
            return AnimationStates.State.FALL
    
    if speed < speed_walk_threshold:
        return AnimationStates.State.IDLE
    elif speed < speed_run_threshold:
        return AnimationStates.State.WALK
    else:
        return AnimationStates.State.RUN

func _change_animation_state(new_state: AnimationStates.State):
    var old_priority = AnimationStates.get_priority(current_state)
    var new_priority = AnimationStates.get_priority(new_state)
    
    if new_priority >= old_priority:
        current_state = new_state
        var animation_name = AnimationStates.get_animation_name(new_state)
        
        if animation_player.has_animation(animation_name):
            animation_player.play(animation_name)
            animation_changed.emit(animation_name)

func play_action_animation(animation_name: String, priority: int = 3):
    if AnimationStates.get_priority(current_state) <= priority:
        animation_player.play(animation_name)
        animation_changed.emit(animation_name)

func force_animation(animation_name: String):
    if animation_player.has_animation(animation_name):
        animation_player.play(animation_name)
        animation_changed.emit(animation_name)
