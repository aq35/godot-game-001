# 📚 Week 2: シーンライフサイクル（生まれて死ぬ）

## 🌱 シーンのライフサイクル図

```
シーンの一生：

📄 .tscnファイル (設計図)
    ↓ 読み込み
👶 シーン誕生 (_ready実行)
    ↓
😊 シーン活動中 (ゲームプレイ)  
    ↓ 別シーンに切り替え
💀 シーン死亡 (_exit_tree実行)
    ↓
🗑️ メモリから完全削除
```

## 🧪 1. シーンの「生死」を目で見て確認する実習

### **実習1: 生まれる瞬間と死ぬ瞬間を観察**

#### **ステップ1: 観察用シーンを作る**

**LifeCycleScene.tscn を作成**
```
LifeCycleScene (Control)
├── Title (Label) "ライフサイクル観察"
├── Info (Label) "ここに情報表示"
└── NextButton (Button) "次のシーンへ"
```

#### **ステップ2: 観察用スクリプトを作成**

```gdscript
# LifeCycleScene.gd
extends Control

# このシーンのデータ
var scene_name = "ライフサイクル観察シーン"
var birth_time = 0.0
var important_data = "重要なデータ"

func _ready():
    birth_time = Time.get_time_dict_from_system()
    
    print("========================================")
    print("🎉 シーンが生まれました！")
    print("シーン名: ", scene_name)
    print("生まれた時刻: ", birth_time.hour, ":", birth_time.minute, ":", birth_time.second)
    print("データ作成: ", important_data)
    print("========================================")
    
    # UI更新
    $Info.text = "シーン名: " + scene_name + "\n" + "データ: " + important_data
    
    # ボタンイベント接続
    $NextButton.pressed.connect(_on_next_button_pressed)

func _exit_tree():
    print("========================================")
    print("💀 シーンが死にます...")
    print("シーン名: ", scene_name, " が削除されます")
    print("データ: ", important_data, " も一緒に消えます")
    print("さようなら...")
    print("========================================")

func _on_next_button_pressed():
    print("🚪 次のシーンに移動します")
    print("このシーン(", scene_name, ")は間もなく削除されます")
    
    # 次のシーンに切り替え（このシーンは削除される）
    get_tree().change_scene_to_file("res://SecondScene.tscn")
```

#### **ステップ3: 次のシーンも作成**

**SecondScene.tscn を作成**
```
SecondScene (Control)  
├── Title (Label) "2番目のシーン"
├── Info (Label) "前のシーンのデータは？"
└── BackButton (Button) "戻る"
```

```gdscript
# SecondScene.gd
extends Control

func _ready():
    print("========================================")
    print("🎉 2番目のシーンが生まれました！")
    print("前のシーンのデータにアクセスしてみます...")
    print("========================================")
    
    # 前のシーンのデータを取得しようとする（できない！）
    # var prev_data = ??? # 前のシーンのimportant_dataが欲しい
    
    $Info.text = "前のシーンのデータ: 取得できません！"
    $BackButton.pressed.connect(_on_back_button_pressed)

func _exit_tree():
    print("========================================")  
    print("💀 2番目のシーンが死にます...")
    print("========================================")

func _on_back_button_pressed():
    print("🔄 最初のシーンに戻ります")
    get_tree().change_scene_to_file("res://LifeCycleScene.tscn")
```

#### **ステップ4: 実行して観察**

**F5で実行して以下を観察：**
1. コンソール出力を見る
2. 「次のシーンへ」ボタンを押す
3. 「戻る」ボタンを押す
4. 何度か行き来してみる

**期待される出力：**
```
🎉 シーンが生まれました！
シーン名: ライフサイクル観察シーン
データ作成: 重要なデータ
🚪 次のシーンに移動します
💀 シーンが死にます...
データ: 重要なデータ も一緒に消えます
さようなら...

🎉 2番目のシーンが生まれました！
前のシーンのデータにアクセスしてみます...
前のシーンのデータ: 取得できません！
```

## 😱 2. データが消える瞬間を体験する実習

### **実習2: 「あれ？データが消えた！」体験**

#### **ステップ1: データ入力シーンを作る**

**InputScene.tscn を作成**
```
InputScene (Control)
├── Title (Label) "データ入力画面"
├── NameInput (LineEdit) 
├── ScoreLabel (Label) "スコア: 0"
├── AddScoreButton (Button) "スコア+10"
└── NextButton (Button) "結果画面へ"
```

```gdscript
# InputScene.gd  
extends Control

# 大切なデータ
var player_name = ""
var player_score = 0
var play_time = 0.0

func _ready():
    print("📝 データ入力画面が開始されました")
    $AddScoreButton.pressed.connect(_on_add_score_pressed)
    $NextButton.pressed.connect(_on_next_pressed)
    
    # スコアを自動で増やす（時間経過でプレイしている感じ）
    var timer = Timer.new()
    timer.wait_time = 1.0
    timer.autostart = true
    timer.timeout.connect(_on_timer_timeout)
    add_child(timer)

func _on_add_score_pressed():
    player_score += 10
    $ScoreLabel.text = "スコア: " + str(player_score)
    print("スコア更新: ", player_score)

func _on_timer_timeout():
    play_time += 1.0
    print("プレイ時間: ", play_time, "秒")

func _on_next_pressed():
    player_name = $NameInput.text
    
    print("=== データ確認 ===")
    print("プレイヤー名: ", player_name)
    print("最終スコア: ", player_score)  
    print("プレイ時間: ", play_time, "秒")
    print("このデータを結果画面で使いたい...")
    print("==================")
    
    # 結果画面に移動（データは消える）
    get_tree().change_scene_to_file("res://ResultScene.tscn")

func _exit_tree():
    print("💀 入力画面が削除されます")
    print("💀 player_name: '", player_name, "' も削除")
    print("💀 player_score: ", player_score, " も削除")
    print("💀 play_time: ", play_time, " も削除")
```

#### **ステップ2: 結果表示シーンを作る**

**ResultScene.tscn を作成**
```
ResultScene (Control)
├── Title (Label) "結果画面"  
├── ResultLabel (Label) "結果表示エリア"
└── RestartButton (Button) "最初から"
```

```gdscript
# ResultScene.gd
extends Control

func _ready():
    print("📊 結果画面が開始されました")
    
    # 前のシーンのデータを表示したい...でもできない！
    var result_text = "結果を表示したいのですが...\n"
    result_text += "プレイヤー名: ??? (取得できません)\n"
    result_text += "スコア: ??? (取得できません)\n"
    result_text += "プレイ時間: ??? (取得できません)\n"
    result_text += "\nデータが消えてしまいました😢"
    
    $ResultLabel.text = result_text
    $RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
    get_tree().change_scene_to_file("res://InputScene.tscn")
```

#### **ステップ3: 「困った感」を味わう**

**実行して以下を体験：**
1. 名前を入力（例：「太郎」）
2. 「スコア+10」を何度もクリック
3. スコアを100以上にする
4. 「結果画面へ」をクリック
5. **結果画面で何も表示されない悲しさを体験**

## 🔍 3. シーンの削除タイミングを正確に理解

### **実習3: 削除タイミングの詳細観察**

```gdscript
# TimingScene.gd
extends Control

var my_data = "大切なデータ"

func _ready():
    print("1️⃣ _ready: シーン生成完了")
    print("   データ作成: ", my_data)

func _on_button_pressed():
    print("2️⃣ ボタンが押されました")
    print("   現在のデータ: ", my_data)
    print("3️⃣ シーン切り替えを実行します...")
    
    # この瞬間まではデータが生きている
    get_tree().change_scene_to_file("res://NextScene.tscn")
    
    # この行は実行されない（シーンが削除されるため）
    print("この行は実行されません")

func _exit_tree():
    print("4️⃣ _exit_tree: シーンが削除される直前")
    print("   最後のデータ確認: ", my_data)
    print("5️⃣ この後、データは完全に消えます")
```

## 📊 削除タイミングの図解

```
ボタンクリック
    ↓
change_scene実行  
    ↓
現在のシーン削除開始
    ↓
_exit_tree() 実行 ← 最後のお別れ
    ↓
全データ削除
    ↓
新しいシーン読み込み
    ↓  
新しいシーンの_ready() 実行
```

## 💭 4. 初心者が体験する感情の変化

### **典型的な反応**
```
😊 「おお、データ入力できた！スコアも増えた！」
　↓
🤔 「結果画面でスコア表示したいな」
　↓
😕 「あれ？データが表示されない...」
　↓
😰 「え？なんで？入力したのに...」
　↓
😫 「これどうやって解決すればいいの？」
　↓
🔍 「何か方法があるはず...」
```

### **この感情が重要！**
**「困った！どうにかしたい！」**
この気持ちになった時が、AutoLoadの価値を理解する最適なタイミング。

## ✅ Week 2 理解度チェック

### **理解すべきポイント**
```
✅ シーンは「生まれて死ぬ」使い捨てプログラム
✅ シーン切り替え = 前のシーンの