extends Node
class_name InputHandler

var input_map: Dictionary = {}
var action_history: Array[Dictionary] = []
var max_history: int = 100

signal action_pressed(action_name: String)
signal action_released(action_name: String)

func _ready():
    load_input_bindings()

func _input(event):
    _record_input(event)
    _process_custom_actions(event)

func load_input_bindings():
    # デフォルトの入力バインド
    input_map = {
        "move_forward": "W",
        "move_backward": "S",
        "move_left": "A",
        "move_right": "D",
        "jump": "Space",
        "run": "Shift",
        "interact": "E",
        "chat": "T",
        "menu": "Escape"
    }

func save_input_bindings():
    Settings.set_setting("controls", "input_map", input_map)
    Settings.save_settings()

func bind_action(action_name: String, key: String):
    input_map[action_name] = key
    print("Bound ", action_name, " to ", key)

func get_action_key(action_name: String) -> String:
    return input_map.get(action_name, "")

func is_action_pressed(action_name: String) -> bool:
    var key = get_action_key(action_name)
    if key == "":
        return false
    
    return Input.is_key_pressed(_key_string_to_code(key))

func _key_string_to_code(key_string: String) -> Key:
    match key_string.to_upper():
        "W": return KEY_W
        "A": return KEY_A
        "S": return KEY_S
        "D": return KEY_D
        "SPACE": return KEY_SPACE
        "SHIFT": return KEY_SHIFT
        "E": return KEY_E
        "T": return KEY_T
        "ESCAPE": return KEY_ESCAPE
        _: return KEY_UNKNOWN

func _record_input(event: InputEvent):
    var input_record = {
        "timestamp": Time.get_time_from_system(),
        "type": event.get_class(),
        "pressed": false
    }
    
    if event is InputEventKey:
        input_record["key"] = event.keycode
        input_record["pressed"] = event.pressed
    
    action_history.append(input_record)
    
    if action_history.size() > max_history:
        action_history = action_history.slice(action_history.size() - max_history)

func _process_custom_actions(event: InputEvent):
    if event is InputEventKey and event.pressed:
        for action_name in input_map.keys():
            var key = get_action_key(action_name)
            if _key_string_to_code(key) == event.keycode:
                action_pressed.emit(action_name)
                break

func get_input_history() -> Array[Dictionary]:
    return action_history
