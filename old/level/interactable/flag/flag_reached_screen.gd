# ゲーム終了時の綺麗な演出
# CanvasLayer を継承したクラス
# UI要素やエフェクトを画面に重ねて表示するのに使用
extends CanvasLayer

# ノードの参照取得
# 1.%AnimationPlayer でユニークネームのAnimationPlayerノードを取得
# 2.@onready でノードが準備完了してから実行
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

# 処理の流れ

# シグナル接続: Events.flag_reached イベントに匿名関数を接続
# フラグ到達時の動作:

# 2秒待機 (await get_tree().create_timer(2.0).timeout)
# フェードインアニメーション開始 (_animation_player.play("fade_in"))
# アニメーション完了まで待機 (await _animation_player.animation_finished)
# ゲーム終了 (get_tree().quit())

func _ready() -> void:
	Events.flag_reached.connect(func on_flag_reached() -> void:
		await get_tree().create_timer(2.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		get_tree().quit()
	)
