HUD として画面右上に固定されるボタン（UI系）

了解。HUD（画面固定）の右上にボタンを出す最小コードです。`CanvasLayer` にこのスクリプトを付けてください。

```gdscript
# HUDTopRightButton.gd (Godot 4.4)
extends CanvasLayer

@export var button_text: String = "押してね"
@export var margin_top: int = 16
@export var margin_right: int = 16
@export var button_size: Vector2 = Vector2(120, 44)

@onready var button := Button.new()

func _ready() -> void:
    # Button を生成して CanvasLayer に追加
    add_child(button)
    button.text = button_text
    button.custom_minimum_size = button_size

    # レイアウト：右上固定
    # （解像度が変わっても右上キープ）
    button.set_anchors_preset(Control.PRESET_TOP_RIGHT, true)
    button.offset_top = margin_top
    button.offset_right = -margin_right
    button.offset_left = button.offset_right - button_size.x
    button.offset_bottom = button.offset_top + button_size.y

    # クリック時の処理
    button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
    print("HUDボタンが押されました！")
```

### 使い方

1. シーンに **CanvasLayer** を追加（名前例：`HUD`）。
2. 上の `HUDTopRightButton.gd` を `HUD` にアタッチして再生。

> `CanvasLayer` を使うことで、3Dカメラが動いてもボタンは画面右上に固定表示されます。必要なら `margin_*` と `button_size` をエクスポート変数で調整してください。

シーンのルート（または 3D シーンと並列）に置くのが正解です。