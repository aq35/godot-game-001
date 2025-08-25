# Audio.gd - 音声システム
extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var master_volume: float = 1.0
var bgm_volume: float = 0.7
var sfx_volume: float = 0.8

var bgm_list: Dictionary = {
    "menu": "res://assets/audio/bgm/menu_theme.ogg",
    "town": "res://assets/audio/bgm/town_theme.ogg",
    "forest": "res://assets/audio/bgm/forest_theme.ogg"
}

func _ready():
    print("Audio Manager initialized")
    _setup_audio_players()

func _setup_audio_players():
    bgm_player = AudioStreamPlayer.new()
    sfx_player = AudioStreamPlayer.new()
    
    add_child(bgm_player)
    add_child(sfx_player)
    
    bgm_player.bus = "Master"
    sfx_player.bus = "Master"

func play_bgm(bgm_name: String):
    if bgm_name in bgm_list:
        var stream = load(bgm_list[bgm_name])
        if stream:
            bgm_player.stream = stream
            bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)
            bgm_player.play()
            print("Playing BGM: ", bgm_name)
    else:
        print("BGM not found: ", bgm_name)

func stop_bgm():
    bgm_player.stop()

func play_sfx(sfx_path: String):
    var stream = load(sfx_path)
    if stream:
        sfx_player.stream = stream
        sfx_player.volume_db = linear_to_db(sfx_volume * master_volume)
        sfx_player.play()

func set_master_volume(volume: float):
    master_volume = clamp(volume, 0.0, 1.0)
    _update_volumes()

func set_bgm_volume(volume: float):
    bgm_volume = clamp(volume, 0.0, 1.0)
    _update_volumes()

func set_sfx_volume(volume: float):
    sfx_volume = clamp(volume, 0.0, 1.0)
    _update_volumes()

func _update_volumes():
    if bgm_player:
        bgm_player.volume_db = linear_to_db(bgm_volume * master_volume)
    if sfx_player:
        sfx_player.volume_db = linear_to_db(sfx_volume * master_volume)
