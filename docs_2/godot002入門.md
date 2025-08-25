# 📚 Week 1: Godot基礎概念（初心者向け）

## 🏗️ 1. ノード・シーンとは何か

### **ノードツリーの例**
```
Main (Control)                    ← 親ノード（家の土台）
├── Title (Label)                ← 子ノード（看板）
├── StartButton (Button)         ← 子ノード（ドアベル）
├── Background (ColorRect)       ← 子ノード（壁）
└── Audio (AudioStreamPlayer)    ← 子ノード（BGM）
```

### **実際に作ってみよう！**

#### 🎯 **最初のシーン作成実習**

**ステップ1: 新しいシーンを作る**
```
1. Godot を開く
2. 「新しいシーン」をクリック
3. 「Control」を選択 → 「作成」
4. ノード名を「Main」に変更
```

**ステップ2: ノードを追加してみる**
```
1. 「Main」を右クリック → 「子を追加」
2. 「Label」を検索して選択 → 「作成」
3. もう一度 「Main」を右クリック → 「子を追加」  
4. 「Button」を検索して選択 → 「作成」
```

**ステップ3: 内容を設定**
```
1. Label を選択
2. 右側の「Inspector」で「Text」を「ようこそ！」に変更
3. Button を選択  
4. 「Inspector」で「Text」を「スタート」に変更
```

**ステップ4: シーンを保存**
```
1. Ctrl+S (または File → Save Scene)
2. 「MainScene.tscn」として保存
```

## 📝 2. 単一シーンでのスクリプト作成

### **スクリプトの役割**

```
ノード = 部品（見た目）
スクリプト = 動作（機能）

Button（部品） + スクリプト = 押したら何かが起こるボタン
Label（部品） + スクリプト = 文字が変わるラベル
```

### **実際にスクリプトを作ってみよう**

#### 🎯 **初めてのスクリプト実習**

**ステップ1: スクリプトをアタッチ**
```
1. 「Main」ノードを選択
2. 上部の「アタッチスクリプト」アイコンをクリック
3. そのまま「作成」をクリック
4. スクリプトエディタが開く
```

**ステップ2: 基本スクリプト作成**
```gdscript
# Main.gd
extends Control

# ゲーム開始時に一回だけ実行される
func _ready():
    print("ゲームが開始されました！")
    print("こんにちは、Godotの世界へ！")
```

**ステップ3: 実行して確認**
```
1. F5キー を押す（またはプレイボタン）
2. 「このシーンを実行しますか？」→「このシーンを選択」
3. 下部の「出力」タブでメッセージを確認
```

**期待される結果:**
```
ゲームが開始されました！
こんにちは、Godotの世界へ！
```

## 🔧 3. 変数・関数の基本

### **変数 = データを保存する箱**

```gdscript
# いろいろな箱（変数）を作ってみる

# 文字を保存する箱
var player_name = "太郎"

# 数字を保存する箱  
var score = 100

# True/Falseを保存する箱
var is_game_over = false

# 小数を保存する箱
var health = 75.5
```

### **関数 = 処理をまとめた機械**

```gdscript
# 挨拶する機械
func say_hello():
    print("こんにちは！")

# 計算する機械
func add_score(points):
    score = score + points
    print("スコアが ", points, " 増えました！")
    print("現在のスコア: ", score)
```

### **実際に動作させてみよう**

#### 🎯 **変数・関数実習**

**完成版スクリプト:**
```gdscript
# Main.gd
extends Control

# 変数（データを保存する箱）
var player_name = "プレイヤー"
var score = 0
var level = 1

# ゲーム開始時に実行
func _ready():
    print("=== ゲーム開始 ===")
    show_player_info()
    add_score(50)
    level_up()
    show_player_info()

# プレイヤー情報を表示する機械
func show_player_info():
    print("プレイヤー名: ", player_name)
    print("スコア: ", score)
    print("レベル: ", level)
    print("---")

# スコアを増やす機械
func add_score(points):
    score = score + points
    print("スコアが ", points, " 増えました！")

# レベルアップする機械
func level_up():
    level = level + 1
    print("レベルアップ！ レベル ", level, " になりました！")
```

**期待される実行結果:**
```
=== ゲーム開始 ===
プレイヤー名: プレイヤー
スコア: 0  
レベル: 1
---
スコアが 50 増えました！
レベルアップ！ レベル 2 になりました！
プレイヤー名: プレイヤー
スコア: 50
レベル: 2
---
```

## 🎮 ボーナス実習：ボタンを押して変数を変更

### **インタラクティブな例**

```gdscript
# Main.gd
extends Control

# 変数
var click_count = 0

func _ready():
    print("ボタンクリックゲーム開始！")
    
    # ボタンのシグナルに接続
    var button = $Button  # Buttonノードを取得
    button.pressed.connect(_on_button_pressed)

# ボタンが押された時に呼ばれる
func _on_button_pressed():
    click_count = click_count + 1
    print("ボタンが ", click_count, " 回押されました！")
    
    # ラベルも更新
    var label = $Label
    label.text = "クリック回数: " + str(click_count)
    
    # 10回押されたら特別メッセージ
    if click_count == 10:
        print("🎉 10回達成！おめでとう！")
        label.text = "🎉 10回達成！おめでとう！"
```

## ✅ Week 1 理解度チェック

### **確認項目**
```
✅ ノードとシーンの違いが分かる
✅ シーンにスクリプトをアタッチできる
✅ _ready() 関数が何のためにあるか分かる
✅ 変数でデータを保存できる
✅ 関数で処理をまとめられる  
✅ print() でメッセージを出力できる
✅ ボタンクリックで変数を変更できる
```

### **実際に作ったもの**
```
📁 MainScene.tscn
  ├── Main (Control) + Main.gd
  ├── Label (文字表示)
  ├── Button (クリック可能)
  └── AudioStreamPlayer (音声・オプション)
```

## 🎯 Week 1 まとめ

**覚えたこと:**
- **ノード** = LEGOブロック（部品）
- **シーン** = LEGOの完成品（ノードの集合）
- **スクリプト** = 動作を与える設計図
- **変数** = データを保存する箱
- **関数** = 処理をまとめた機械

**次回予告（Week 2）:**
- シーンが「生まれて死ぬ」概念
- `_exit_tree()` の使い方
- シーンの寿命を目で見て確認

**宿題（任意）:**
```
今日作ったシーンをベースに：
1. 新しい変数を追加してみる
2. 新しい関数を作ってみる  
3. ボタンを増やして違う動作をさせる
4. 色や位置を変えてみる
```

## 💡 よくある質問

**Q: なぜ `extends Control` と書くの？**
A: 「Controlノードにスクリプトをアタッチしますよ」という宣言です。

**Q: `$Button` の `$` は何？**
A: 子ノードを簡単に取得する記号です。`get_node("Button")` と同じ意味。

**Q: `func _ready():` の `_` は何？**
A: Godotが用意してくれている特別な関数の印です。

**Q: 変数の値を変えたのに画面に反映されない**
A: `label.text = str(変数名)` のように、UIに反映する処理を書く必要があります。

---

これでWeek 1の基礎概念は完了！実際に手を動かして理解できましたか？