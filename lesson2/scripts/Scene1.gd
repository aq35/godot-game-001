extends Control

var my_data = "重要なデータ"

func _ready():
    print("Scene1 が生まれました! データ:", my_data)

func _exit_tree():
    print("Scene1 が死にます...データも一緒に:", my_data)

func _on_NextButton_pressed():
    print("Scene2 へ切り替えます")
    get_tree().change_scene_to_file("res://scenes/Scene2.tscn")
