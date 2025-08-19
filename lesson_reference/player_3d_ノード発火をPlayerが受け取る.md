いい視点です！✨
Godot の `_on_body_entered` は自分で呼ぶ関数ではなく、**Godot がシグナルを自動で呼んでくれる仕組み**です。

---

## 🔹 `_on_body_entered` とは？

* `Area3D` や `CollisionShape3D` などで **body\_entered シグナル** が発生すると Godot が呼び出す関数。
* プレイヤーや物理オブジェクトがそのエリアに入った瞬間に自動で発火する。

---

## 🔹 どこで結びついているの？

通常は **エディタ上でシグナルを接続**して結びつけています。

例：`KillPlane` シーン（Area3D）を開いて

1. ノードタブで `KillPlane` を選択
2. インスペクタ右上にある「⚡Signals」アイコンをクリック
3. `body_entered(PhysicsBody3D body)` を選んで「接続」
4. スクリプトに自動生成されるのが：

```gdscript
func _on_body_entered(body: PhysicsBody3D) -> void:
    Events.kill_plane_touched.emit(body)
```

👉 この関数は自分で直接呼んでいないけど、Godot が「接続されたシグナルが発火したら呼ぶよ」という約束になっている。

---

## 🔹 Player 側との違い

* **KillPlane.gd**: `_on_body_entered` で `Events.kill_plane_touched.emit(body)` を発火
* **Player.gd**: `_ready()` の中で `Events.kill_plane_touched.connect(...)` して受け取る

つまりこういう流れ👇

```
Player が KillPlane に入る
↓
KillPlane の body_entered シグナルが発火
↓
Godot が KillPlane.gd の _on_body_entered を呼ぶ
↓
Events.kill_plane_touched.emit(body) が発火
↓
Player.gd が Events.kill_plane_touched.connect(...) で受け取って処理
```

---

## 🔹 まとめ

* `_on_body_entered` は「自動で呼ばれるイベントハンドラ」
* **呼んでいるのは Godot 本体**（エンジン）
* 接続方法は主にエディタで「Signals」からつないでいる

---

👉 確認したいのですが、あなたの `KillPlane` や `Flag` のシーンは **`Area3D`** ですか？
もしそうなら `_on_body_entered` は **body\_entered シグナル**から自動で呼ばれています。
