# Scene1.gd
extends Control

var my_data = "重要なデータ"  # シーンと一緒に生まれる

func _ready():
    print("データ作成: ", my_data)

# シーン切り替え時
func go_to_scene2():
    get_tree().change_scene_to_file("res://Scene2.tscn")
    # この瞬間に my_data は消滅する