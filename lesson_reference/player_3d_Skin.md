はい、これは **ほぼ定型で使う書き方** です 👍

---

## 🔹 なぜ「定型」なのか

* `AnimationTree` は **必ずシーン内に 1 つ置く**（キャラのアニメ制御用）
* その中で「StateMachine」を使う場合、**必ず `"parameters/playback"` から `AnimationNodeStateMachinePlayback` を取得する**必要がある

  ```gdscript
  _tree.get("parameters/playback")
  ```

  これは「現在どのステートにいるか？」「別のステートへ移動するか？」を操作するハンドル。

なので、多くのキャラ制御スクリプトでこの 2 行はそのまま定型文として出てきます。

---

## 🔹 定型パターン例

```gdscript
@onready var _tree: AnimationTree = $AnimationTree
@onready var _playback := _tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

func _ready() -> void:
    _tree.active = true   # ← これも忘れず定型
```

これで `playback.travel("StateName")` を呼べるようになります。

---

## 🔹 注意すべきこと

* **AnimationTree 内に StateMachine が無い場合** → `"parameters/playback"` が存在せずエラーになる

  * その場合は BlendSpace を直接操作する（例: `parameters/Move/blend_position`）
* **ノード名が違う場合** → `$AnimationTree` の部分はシーンの構成に合わせて変更する必要がある
* **`active = true` を忘れると動かない**（これ地味にハマりポイント）

---

✅ 結論:
`@onready var _tree ...` と `@onready var _playback ...` は **StateMachine を使うなら定型**で書くのが基本。

---

質問ですが、あなたの `AnimationTree` のルートは **StateMachine** ですか？それとも **BlendSpace** メインですか？
それによって、この「定型」の後に書く処理が少し変わります。
