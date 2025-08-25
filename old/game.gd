extends Node

# このスクリプトはNodeを継承しています
# Godotのシーンツリーに追加されたとき、Nodeのライフサイクルが始まります
# 1. ユーザーの入力イベントが発生すると、この関数が呼ばれます
# 2. "toggle_fullscreen" アクションが押された場合、下記の処理が実行されます
# 3. ウィンドウモードがフルスクリーンとウィンドウ表示で切り替わります

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		get_viewport().mode = (
			Window.MODE_FULLSCREEN if
			get_viewport().mode != Window.MODE_FULLSCREEN else
			Window.MODE_WINDOWED
		)
