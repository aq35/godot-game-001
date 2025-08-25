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
