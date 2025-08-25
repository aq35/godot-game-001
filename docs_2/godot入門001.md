# 📚 Godot初心者に「まず最初に」教えるべき基礎

## 🎯 前提となる重要概念（順序重要）

### **1. 最重要：「シーンは生き物」概念**

```gdscript
# まず「シーンは生まれて死ぬ」を理解してもらう

# シーン1が生まれる
get_tree().change_scene_to_file("res://Scene1.tscn")
# Scene1.tscn が読み込まれる = 生まれる

# シーン1が死ぬ  
get_tree().change_scene_to_file("res://Scene2.tscn") 
# Scene1.tscn が削除される = 死ぬ
# ↑ この瞬間にScene1の全てが消える
```

**初心者によくある勘違い：**
```
❌「シーン切り替え = ページ切り替え」
⭕「シーン切り替え = プログラム終了 → 新しいプログラム開始」
```

### **2. 変数の「生存期間」概念**

```gdscript
# Scene1.gd
extends Control

var my_data = "重要なデータ"  # シーンと一緒に生まれる

func _ready():
    print("データ作成: ", my_data)

# シーン切り替え時
func go_to_scene2():
    get_tree().change_scene_to_file("res://Scene2.tscn")
    # この瞬間に my_data は消滅する
```

```gdscript
# Scene2.gd  
extends Control

func _ready():
    print(my_data)  # エラー！my_dataは存在しない
    # Scene1で作られた変数はもう無い
```

### **3. 「独立したプログラム」概念**

```gdscript
# 初心者に理解してもらう例え

# Scene1.tscn = 電卓アプリ
var calculator_result = 123

# Scene2.tscn = メモ帳アプリ  
var note_text = "メモ内容"

# 電卓アプリからメモ帳アプリの変数は見えない
# 別々のプログラムだから当然
```

## 🛠️ 実際の教育手順

### **Step 1: 単一シーンの変数実験**

```gdscript
# 初心者に実際にやってもらう

# TestScene.gd
extends Control

var counter = 0

func _on_button_pressed():
    counter += 1
    label.text = str(counter)
    print("カウンター: ", counter)

# ここでは何の問題もない
# 変数は期待通りに動作する
```

### **Step 2: シーン削除の視覚化**

```gdscript
# DebugScene.gd - デバッグ出力で理解してもらう
extends Control

var important_data = "大切なデータ"

func _ready():
    print("シーンが生まれました！データ:", important_data)

func _exit_tree():
    print("シーンが死にます...データも一緒に:", important_data)
    print("さようなら...")

func _on_next_scene_pressed():
    print("次のシーンに移動します")
    get_tree().change_scene_to_file("res://NextScene.tscn")
    # ここでこのシーンが削除される
```

### **Step 3: 「データが消える瞬間」を体験**

```gdscript
# ExperimentScene.gd
extends Control

var user_input = ""

func _on_input_finished():
    user_input = text_input.text
    print("入力されたデータ: ", user_input)
    
    # 5秒後に次のシーンへ
    await get_tree().create_timer(5.0).timeout
    print("データを持って次のシーンへ...")
    get_tree().change_scene_to_file("res://ReceiveScene.tscn")
```

```gdscript
# ReceiveScene.gd  
extends Control

func _ready():
    print("前のシーンのデータは: ", ???)
    # 何も取得できない！
    label.text = "データが消えました..."
```

## 💡 初心者が「困る瞬間」を作る

### **予測と現実のギャップ**

```gdscript
# 初心者の期待
"入力したデータが次の画面でも使えるはず"

# 実際の結果  
"あれ？データが消えた..."

# この瞬間が重要！
"なんで？どうして？"
```

### **身近な例で説明**

```markdown
# 初心者向けの例え

❌ 悪い例え：「変数がスコープから外れる」
  → 初心者には難しい

⭕ 良い例え：
  「スマホで電卓アプリを使った後、メモアプリに切り替えたら
   電卓の計算結果はメモアプリでは見えないですよね？
   Godotのシーンも同じです」
```

## 🎯 教育順序（推奨）

### **Week 1: 基礎概念**
1. ノード・シーンとは何か
2. 単一シーンでのスクリプト作成
3. 変数・関数の基本

### **Week 2: シーンライフサイクル**
1. シーンが「生まれて死ぬ」概念
2. `_ready()`, `_exit_tree()` の理解
3. デバッグ出力での確認

### **Week 3: 複数シーンの操作**
1. `change_scene_to_file()` の使い方
2. 複数シーン間の移動実験
3. **データが消える現象の体験**

### **Week 4: 問題認識**
1. 「データを引き継ぎたい」欲求の発生
2. 様々な解決方法の模索
3. AutoLoad への導入準備完了

## 🧪 実際の教材例

### **「データ消失実験キット」**

```
Phase0_基礎.zip
├── SingleScene.tscn        # 変数が正常に動作
└── DebugOutput.tscn        # シーンの生死を確認

Phase1_問題発見.zip  
├── InputScene.tscn         # データ入力
├── DisplayScene.tscn       # データ表示（できない）
└── README.txt              # 「なぜできないのか？」
```

## 💭 初心者の心理状態管理

### **感情の変化を想定**
```
😊 Godot楽しい！
　↓
🤔 複数画面作りたい
　↓  
😕 あれ？データが消える...
　↓
😰 これ、どうすればいいの？
　↓
🔍 解決方法を探したい ← この状態が重要
```

**この「解決方法を探したい」状態になってから AutoLoad を教える**

## 🎯 最重要ポイント

**「困ってから解決策」の順序を守る**

1. **基礎理解** → 変数・シーンの基本
2. **現象体験** → データが消える体験  
3. **問題認識** → これは困った
4. **解決欲求** → どうにかしたい
5. **解決提示** → AutoLoadがあります ← ここで初めて登場

この順序でいけば、初心者も確実にAutoLoadの価値を理解できます！

どの段階を重視したいか、具体的な教材作成について、さらに詳しく決めていきますか？