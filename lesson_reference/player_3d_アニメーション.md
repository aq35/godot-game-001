いいね、ここは **アニメーション駆動の設計**を一度“型”で覚えると一気に楽になります。
ポイントは「プレイヤーの物理状態 → `SophiaSkin` に“命令”する」層分離です。

# 全体像

* **Player.gd**（物理・入力）
  → 速度・接地・ジャンプなどを判断して **`_skin.move()/idle()/jump()/fall()`** を呼ぶ（今のコードがコレ）
* **SophiaSkin.gd**（見た目）
  → 受け取った命令で **AnimationTree** のパラメータやステートを切り替える

---

# AnimationTree のセットアップ例

シーン構成（例）：

```
SophiaSkin (Node3D)  ← このノードに SophiaSkin.gd を付与
├─ AnimationTree
├─ AnimationPlayer
└─ Skeleton3D
```

AnimationTree の中身（よく使う形）：

* **StateMachine** ノードでステート管理

  * States: `Idle`, `Move`, `Jump`, `Fall`, `Land`
* `Move` の中は **BlendSpace1D**（速度に応じた歩き/走りのブレンド）

  * 0.0 = Walk、1.0 = Run（任意で設定）

※ StateMachine の再生制御は `parameters/playback`（`AnimationNodeStateMachinePlayback`）を使います。

---

# SophiaSkin.gd（最小実装）

```gdscript
# SophiaSkin.gd
extends Node3D

@onready var _tree: AnimationTree = $AnimationTree
@onready var _playback := _tree.get("parameters/playback") # AnimationNodeStateMachinePlayback
var _move_blend := 0.0

func _ready() -> void:
	_tree.active = true

# 速度に応じて Move ステートのブレンド値を更新
# speed_ratio: 0.0(歩かない) ～ 1.0(全力走り)
func move(speed_ratio: float = 1.0) -> void:
	_move_blend = lerp(_move_blend, clamp(speed_ratio, 0.0, 1.0), 0.2)
	_tree.set("parameters/Move/blend_position", _move_blend)
	if _playback.get_current_node() != "Move":
		_playback.travel("Move")

func idle() -> void:
	_playback.travel("Idle")

func jump() -> void:
	_playback.travel("Jump")

func fall() -> void:
	_playback.travel("Fall")

func land() -> void:
	# 任意：着地モーションを短く再生 → Idle/Move へ戻る遷移を StateMachine 側で設定
	_playback.travel("Land")
```

> メモ
>
> * `parameters/Move/blend_position` は **BlendSpace1D のパラメータ名**。
>   2D ブレンドなら `blend_position` が `Vector2` になります。
> * `travel("StateName")` でステートを切り替えます。遷移アローに条件や自動戻り（Auto Advance）を設定しておくと自然。

---

# Player 側：速度をブレンド値に変換

あなたの既存コードに “速度→アニメ Blend 値” の一行を足すだけで連携が完成します。

```gdscript
var ground_speed := Vector2(velocity.x, velocity.z).length()
var is_just_jumping := Input.is_action_just_pressed("jump") and is_on_floor()

if is_just_jumping:
	velocity.y += jump_impulse
	_skin.jump()
	_jump_sound.play()
elif not is_on_floor() and velocity.y < 0:
	_skin.fall()
elif is_on_floor():
	if ground_speed > 0.0:
		# ★ 追加：実速度 / 最大速度 を 0..1 へ正規化して渡す
		_skin.move(clamp(ground_speed / move_speed, 0.0, 1.0))
	else:
		_skin.idle()
```

---

# 着地（Landing）を綺麗にする

今は SE 再生だけですが、**着地モーション**も入れるなら：

1. `SophiaSkin.gd` の `land()` を呼ぶ
2. AnimationTree の `Land` ステートから **自動で Idle/Move に戻る遷移**を設定

```gdscript
if is_on_floor() and not _was_on_floor_last_frame:
	_landing_sound.play()
	_skin.land()    # ← 追加
```

---

# 足音・砂埃と同期（任意の発展）

* \*\*AnimationPlayer の通知（Notifies）\*\*に `footstep` キーを入れて、アニメの踏み込みフレームで通知
* `AnimationPlayer.animation_finished` や `tree.animation_node_start/finish` シグナルでも可
* 受け側で `FootstepSound.play()` / `DustParticles.emitting = true` を一瞬だけ ON など

```gdscript
func _on_animation_player_animation_event(anim_name: StringName, track: int, key: String, value):
	if key == "footstep":
		# 足音や砂埃をここで鳴らす/出す
		# _footstep_sound.play()
		# _dust_particles.restart()
		pass
```

---

# ありがちなハマりポイント

* **ステート名/パラメータ名のtypo**
  `parameters/Move/blend_position` などは **正確なパス**が必要。エディタでコピー推奨。
* **BlendSpace の範囲**
  0..1 を前提に配置しておくとコードがシンプル（走りは 1.0 に置く）。
* **`AnimationTree.active = true` 忘れ**
  動かないときはまずここを疑う。
* **ルートモーション**
  使う場合は **物理移動と二重にならない**ようにどちらかへ寄せる。

---

必要なら、あなたのプロジェクト構造（`AnimationTree` のノード名やブレンドの実際のパス）に合わせて **ピンポイント修正版**を書き換えます。スクショやツリー構造（ノード名）を教えてくれたら、それに合わせて完全連携版を出します。
