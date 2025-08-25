# Settings.gd - 設定管理
extends Node

const SETTINGS_FILE = "user://settings.save"

var default_settings = {
    "audio": {
        "master_volume": 1.0,
        "bgm_volume": 0.7,
        "sfx_volume": 0.8
    },
    "graphics": {
        "fullscreen": false,
        "resolution": "1920x1080",
        "vsync": true
    },
    "controls": {
        "mouse_sensitivity": 1.0,
        "invert_y": false
    },
    "network": {
        "auto_connect": true,
        "server_url": "ws://localhost:8080"
    }
}

var current_settings: Dictionary = {}

func _ready():
    print("Settings Manager initialized")
    load_settings()

func load_settings():
    if FileAccess.file_exists(SETTINGS_FILE):
        var file = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
        var json_string = file.get_as_text()
        file.close()
        
        var json = JSON.new()
        var parse_result = json.parse(json_string)
        
        if parse_result == OK:
            current_settings = json.data
            print("Settings loaded from file")
        else:
            current_settings = default_settings.duplicate(true)
    else:
        current_settings = default_settings.duplicate(true)
    
    apply_settings()

func save_settings():
    var file = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
    file.store_string(JSON.stringify(current_settings, "\t"))
    file.close()

func apply_settings():
    Audio.set_master_volume(current_settings.audio.master_volume)
    Audio.set_bgm_volume(current_settings.audio.bgm_volume)
    Audio.set_sfx_volume(current_settings.audio.sfx_volume)
    
    if current_settings.graphics.fullscreen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func get_setting(category: String, key: String, default_value = null):
    if category in current_settings and key in current_settings[category]:
        return current_settings[category][key]
    return default_value

func set_setting(category: String, key: String, value):
    if not category in current_settings:
        current_settings[category] = {}
    current_settings[category][key] = value

func set_volume(volume_type: String, value: float):
    set_setting("audio", volume_type, value)
    match volume_type:
        "master_volume": Audio.set_master_volume(value)
        "bgm_volume": Audio.set_bgm_volume(value)
        "sfx_volume": Audio.set_sfx_volume(value)
