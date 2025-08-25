# scripts/test.gd
extends SceneTree

# 1フレーム待ってから実行する小ヘルパー
func _wait_a_bit(frames := 1) -> void:
    for i in frames:
        await process_frame

func _initialize() -> void:
    print("[TEST] Headless Scene Test Start")

    # --- Scene1 をロード（current_scene をセットする正攻法）---
    print("[TEST] change_scene_to_file -> Scene1")
    change_scene_to_file("res://scenes/Scene1.tscn")
    await _wait_a_bit(2) # シーン切り替えは次フレームで反映される

    # --- Scene1 のボタンを「押す」をシミュレート ---
    if current_scene:
        var btn := current_scene.get_node_or_null("NextButton")
        if btn:
            print("[TEST] Simulate: NextButton.pressed")
            btn.emit_signal("pressed")
        else:
            push_warning("[TEST] NextButton が見つかりませんでした（パスを確認）")
    else:
        push_error("[TEST] current_scene がありません")

    # --- 切替完了待ち ---
    await _wait_a_bit(3)

    # --- いまの状態を出力して終了 ---
    if current_scene:
        print("[TEST] Current scene name:", current_scene.name)
    print("[TEST] Done. Quit.")
    quit()
