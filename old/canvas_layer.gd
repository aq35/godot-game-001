# res://canvas_layer.gd  (Godot 4.4)
extends CanvasLayer

@export var hud_layer: int = 1000 # 数字が大きいほど手前

func _ready() -> void:
    layer = hud_layer
    visible = true

    # 全画面オーバーレイ用の Control
    var overlay := Control.new()
    add_child(overlay)
    overlay.set_anchors_preset(Control.PRESET_FULL_RECT, true)

    # うっすら暗い背景（任意、要らなければ削除OK）
    var bg := ColorRect.new()
    bg.color = Color(0, 0, 0, 0.25)
    bg.set_anchors_preset(Control.PRESET_FULL_RECT, true)
    overlay.add_child(bg)

    # 画面中央に子を配置してくれるコンテナ
    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT, true)
    overlay.add_child(center)

    # 大きめのボタン
    var btn := Button.new()
    btn.text = "中央の大きなボタン"
    btn.custom_minimum_size = Vector2(360, 120)
    btn.add_theme_font_size_override("font_size", 28) # 文字も大きく
    center.add_child(btn)

    btn.pressed.connect(func():
        print("[HUD] 中央ボタン押下")
    )

    # どの Viewport 配下か簡易チェック（true ならメイン）
    print("[HUD] in main viewport? -> ", get_viewport() == get_tree().root)
