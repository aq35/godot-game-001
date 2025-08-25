extends Control

func _ready():
    print("Scene2 が生まれました")
    # Scene1 の my_data はもう存在しない
    $Label.text = "Scene1のデータは消えました!"