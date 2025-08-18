extends Control

@onready var button := Button.new()

func _ready():
    # ボタンを追加
    add_child(button)
    button.text = "押してね"

    # アンカーを右上に固定
    button.anchor_left = 1.0
    button.anchor_top = 0.0
    button.anchor_right = 1.0
    button.anchor_bottom = 0.0

    # オフセットで位置とサイズを指定
    button.offset_left = -120 # 右からの距離（負の値で左へ）
    button.offset_top = 20 # 上からの距離
    button.offset_right = -20 # 右端からの余白
    button.offset_bottom = 60 # 高さ分

    # 押された時のシグナル接続
    button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
    print("ボタンが押されました！")