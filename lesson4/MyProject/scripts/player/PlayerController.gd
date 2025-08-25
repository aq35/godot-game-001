extends CharacterBody3D
class_name PlayerController

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera: Camera3D
var is_mouse_captured: bool = false

func _ready():
    camera = get_node("Camera3D")
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    is_mouse_captured = true

func _input(event):
    if event is InputEventMouseMotion and is_mouse_captured:
        rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
        camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
        camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
    
    if event.is_action_pressed("ui_cancel"):
        toggle_mouse_capture()

func _physics_process(delta):
    # 重力適用
    if not is_on_floor():
        velocity.y -= gravity * delta
    
    # ジャンプ処理
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY
    
    # 移動処理
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    
    move_and_slide()
    
    # 位置同期送信
    _sync_position()

func toggle_mouse_capture():
    if is_mouse_captured:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
        is_mouse_captured = false
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        is_mouse_captured = true

func _sync_position():
    # 位置情報をネットワークに送信
    var player_id = Game.current_user.get("id", "unknown")
    var message = NetworkMessages.create_player_position_message(player_id, global_position, rotation)
    Net.send_message(message)
