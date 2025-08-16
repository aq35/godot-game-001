extends Node

# このスクリプトはNodeを継承しています
# Godotのシーンツリーに追加されたとき、Nodeのライフサイクルが始まります

func _input(event: InputEvent) -> void:
# 1. ユーザーの入力イベントが発生すると、この関数が呼ばれます
	if event.is_action_pressed("toggle_fullscreen"):
# 2. "toggle_fullscreen" アクションが押された場合、下記の処理が実行されます
		get_viewport().mode = (
			Window.MODE_FULLSCREEN if
			get_viewport().mode != Window.MODE_FULLSCREEN else
			Window.MODE_WINDOWED
		)
# 3. ウィンドウモードがフルスクリーンとウィンドウ表示で切り替わります
