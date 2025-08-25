# ✨ Week 4: AutoLoad - 魔法のような問題解決

## 🌟 1. AutoLoad シングルトンの作成

### **魔法の解決策：グローバルデータ置き場**

**Step 1: GameData.gd (AutoLoad) を作成**

```gdscript
# GameData.gd - 全てのシーンからアクセス可能なデータ保管庫
extends Node

# ========================================
# プレイヤー情報（タイトル画面→全画面で使用）
# ========================================
var player_name: String = "無名プレイヤー"
var total_play_count: int = 0
var player_level: int = 1

# ========================================  
# ゲーム設定（設定画面→全画面で使用）
# ========================================
var master_volume: float = 50.0
var difficulty: String = "Normal"
var player_color: String = "青"
var sound_enabled: bool = true
var auto_save: bool = true

# ========================================
# ゲーム統計（ゲーム画面→結果画面で使用）
# ========================================
var current_score: int = 0
var high_score: int = 0
var last_play_time: float = 0.0
var total_games: int = 0
var total_score: int = 0
var average_score: float = 0.0

# ========================================
# ゲーム進行状況
# ========================================
var current_session_score: int = 0
var current_session_time: float = 0.0
var current_session_clicks: int = 0

func _ready():
    print("🎮 GameData AutoLoad 初期化完了")
    print("これで全てのシーンからデータにアクセス可能！")
    
    # 起動時にデータを読み込み（今は仮データ）
    _load_saved_data()

# ========================================
# ゲーム開始時の処理
# ========================================
func start_new_game():
    print("🎯 新しいゲーム開始")
    print("プレイヤー: ", player_name)
    print("難易度: ", difficulty)
    
    # セッションデータリセット
    current_session_score = 0
    current_session_time = 0.0
    current_session_clicks = 0
    
    total_play_count += 1
    print("通算プレイ回数: ", total_play_count, "回目")

# ========================================
# ゲーム終了時の処理  
# ========================================
func finish_game():
    print("🏆 ゲーム終了処理")
    
    # 統計更新
    current_score = current_session_score
    last_play_time = current_session_time
    total_games += 1
    total_score += current_score
    
    # ハイスコア更新チェック
    if current_score > high_score:
        high_score = current_score
        print("🎉 ハイスコア更新！: ", high_score)
    
    # 平均スコア計算
    average_score = float(total_score) / float(total_games)
    
    print("=== ゲーム結果 ===")
    print("今回スコア: ", current_score)
    print("ハイスコア: ", high_score)
    print("平均スコア: ", average_score)
    
    # データ保存
    _save_data()

# ========================================
# スコア加算
# ========================================
func add_score(points: int):
    # 難易度に応じてスコア倍率適用
    var multiplier = 1.0
    match difficulty:
        "Easy": multiplier = 1.0
        "Normal": multiplier = 1.2  
        "Hard": multiplier = 1.5
    
    var actual_points = int(points * multiplier)
    current_session_score += actual_points
    
    print("スコア +", actual_points, " (倍率: x", multiplier, ")")
    print("現在スコア: ", current_session_score)

# ========================================
# 設定適用
# ========================================  
func apply_settings():
    print("⚙️ 設定を適用中...")
    
    # 音量設定を実際のオーディオに適用
    var volume_db = linear_to_db(master_volume / 100.0)
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
    
    print("音量設定: ", master_volume)
    print("難易度設定: ", difficulty)
    print("設定適用完了")

# ========================================
# データ保存・読込（簡易版）
# ========================================
func _save_data():
    print("💾 データ保存中...")
    # 実際のゲームならファイル保存
    # 今回は保存をシミュレーション
    print("全てのデータが保存されました")

func _load_saved_data():
    print("📂 保存データ読み込み中...")
    # 実際のゲームならファイル読み込み
    # 今回は仮データ設定
    if total_play_count == 0:
        print("初回起動です")
    else:
        print("前回データ復元: プレイ回数 ", total_play_count)

# ========================================
# デバッグ用情報表示
# ========================================
func print_all_data():
    print("=== GameData 全データ ===")
    print("プレイヤー名: ", player_name)
    print("音量: ", master_volume)
    print("難易度: ", difficulty)
    print("現在スコア: ", current_session_score)
    print("ハイスコア: ", high_score)
    print("プレイ回数: ", total_play_count)
    print("========================")
```

### **Step 2: AutoLoad に登録**

```
1. Project → Project Settings
2. AutoLoad タブ
3. Path: GameData.gd を選択  
4. Name: GameData
5. Add ボタンクリック
```

## 🔧 2. Week 3のシーンを魔法のように修正

### **TitleScreen.gd の修正版**

```gdscript
# TitleScreen.gd (修正版)
extends Control

func _ready():
    print("🎮 タイトル画面開始")
    
    # 魔法！前回データが取得できる！
    print("前回のスコア: ", GameData.high_score)
    print("プレイ回数: ", GameData.total_play_count)
    
    # UIに実際のデータを表示
    var info_text = "ようこそ " + GameData.player_name + "！\n"
    info_text += "ハイスコア: " + str(GameData.high_score) + "\n"
    info_text += "プレイ回数: " + str(GameData.total_play_count) + "回"
    
    # 前回の名前を入力欄にセット  
    $PlayerNameInput.text = GameData.player_name
    
    print("✨ AutoLoadのおかげでデータが使える！")
    
    $StartButton.pressed.connect(_on_start_pressed)
    $SettingsButton.pressed.connect(_on_settings_pressed)
    $QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
    # プレイヤー名をAutoLoadに保存
    GameData.player_name = $PlayerNameInput.text
    if GameData.player_name == "":
        GameData.player_name = "無名プレイヤー"
    
    print("=== ゲーム開始 ===")
    print("プレイヤー名をGameDataに保存: ", GameData.player_name)
    
    # ゲーム開始処理
    GameData.start_new_game()
    
    get_tree().change_scene_to_file("res://GameScreen.tscn")

func _on_settings_pressed():
    print("設定画面へ（データは保持される）")
    get_tree().change_scene_to_file("res://SettingsScreen.tscn")

func _on_quit_pressed():
    GameData._save_data()  # 終了時にデータ保存
    get_tree().quit()

# _exit_tree() でのデータ削除メッセージはもう不要！
# AutoLoadのデータは削除されない！
```

### **SettingsScreen.gd の修正版**

```gdscript
# SettingsScreen.gd (修正版)
extends Control

func _ready():
    print("⚙️ 設定画面開始")
    
    # 魔法！前回の設定が復元できる！
    print("前回の音量: ", GameData.master_volume)
    print("前回の難易度: ", GameData.difficulty)
    
    # 保存されている設定値をUIに復元
    $VolumeSlider.value = GameData.master_volume
    
    $DifficultyOption.add_item("Easy")
    $DifficultyOption.add_item("Normal")
    $DifficultyOption.add_item("Hard")
    
    # 保存されている難易度を選択状態にする
    match GameData.difficulty:
        "Easy": $DifficultyOption.selected = 0
        "Normal": $DifficultyOption.selected = 1
        "Hard": $DifficultyOption.selected = 2
    
    $ColorInput.text = GameData.player_color
    
    print("✨ 前回の設定が完全復元！")
    
    $SaveButton.pressed.connect(_on_save_pressed)
    $BackButton.pressed.connect(_on_back_pressed)

func _on_save_pressed():
    # 設定をAutoLoadに保存（永続的に残る！）
    GameData.master_volume = $VolumeSlider.value
    GameData.difficulty = $DifficultyOption.get_item_text($DifficultyOption.selected)
    GameData.player_color = $ColorInput.text
    
    print("=== 設定保存 ===")
    print("音量: ", GameData.master_volume)
    print("難易度: ", GameData.difficulty)
    print("好きな色: ", GameData.player_color)
    
    # 設定を実際に適用
    GameData.apply_settings()
    
    print("✨ 設定がAutoLoadに永続保存されました！")

func _on_back_pressed():
    print("タイトルに戻ります（設定は永続保持されています）")
    get_tree().change_scene_to_file("res://TitleScreen.tscn")

# もう設定が消える心配なし！
```

### **GameScreen.gd の修正版**

```gdscript
# GameScreen.gd (修正版) 
extends Control

var game_timer: Timer
var is_paused = false

func _ready():
    print("🎯 ゲーム画面開始")
    
    # 魔法！他の画面のデータが全部使える！
    print("プレイヤー名: ", GameData.player_name)
    print("設定難易度: ", GameData.difficulty)
    print("音量設定: ", GameData.master_volume)
    
    # プレイヤー情報を正しく表示
    $PlayerInfo.text = "プレイヤー: " + GameData.player_name
    $ScoreLabel.text = "スコア: " + str(GameData.current_session_score)
    
    # 設定を適用
    GameData.apply_settings()
    
    # 難易度表示
    var difficulty_color = Color.GREEN
    match GameData.difficulty:
        "Easy": difficulty_color = Color.GREEN
        "Normal": difficulty_color = Color.YELLOW  
        "Hard": difficulty_color = Color.RED
    
    print("✨ 全てのデータが正常に取得できています！")
    
    # ゲームタイマー
    game_timer = Timer.new()
    game_timer.wait_time = 0.1
    game_timer.autostart = true
    game_timer.timeout.connect(_on_timer_timeout)
    add_child(game_timer)
    
    $ClickButton.pressed.connect(_on_click_button_pressed)
    $PauseButton.pressed.connect(_on_pause_pressed)
    $FinishButton.pressed.connect(_on_finish_pressed)

func _on_click_button_pressed():
    GameData.current_session_clicks += 1
    
    # AutoLoadのadd_score()で難易度倍率適用
    GameData.add_score(10)
    
    # UI更新
    $ScoreLabel.text = "スコア: " + str(GameData.current_session_score)
    $ClickButton.text = "クリック! (" + str(GameData.current_session_clicks) + "回)"

func _on_timer_timeout():
    if not is_paused:
        GameData.current_session_time += 0.1
        $TimeLabel.text = "時間: " + str(int(GameData.current_session_time)) + "秒"

func _on_pause_pressed():
    is_paused = !is_paused
    $PauseButton.text = "再開" if is_paused else "一時停止"

func _on_finish_pressed():
    print("=== ゲーム終了 ===")
    print("最終スコア: ", GameData.current_session_score)
    print("プレイ時間: ", GameData.current_session_time)
    print("クリック回数: ", GameData.current_session_clicks)
    
    # ゲーム終了処理（統計更新）
    GameData.finish_game()
    
    print("✨ データが結果画面に完璧に引き継がれます！")
    
    get_tree().change_scene_to_file("res://ResultScreen.tscn")
```

### **ResultScreen.gd の修正版**

```gdscript
# ResultScreen.gd (修正版)
extends Control

func _ready():
    print("🏆 結果画面開始")
    
    # 魔法！全てのデータが完璧に取得できる！
    print("プレイヤー名: ", GameData.player_name)
    print("最終スコア: ", GameData.current_score)
    print("プレイ時間: ", GameData.last_play_time)
    print("クリック数: ", GameData.current_session_clicks)
    
    # 結果表示（今度は全てのデータが正常表示）
    var result_text = "[font_size=24][color=gold]🏆 ゲーム結果 🏆[/color][/font_size]\n\n"
    result_text += "プレイヤー: " + GameData.player_name + "\n"
    result_text += "スコア: " + str(GameData.current_score) + " 点\n"
    result_text += "プレイ時間: " + str(int(GameData.last_play_time)) + " 秒\n"
    result_text += "クリック数: " + str(GameData.current_session_clicks) + " 回\n"
    result_text += "難易度: " + GameData.difficulty + "\n\n"
    
    # 統計情報も表示可能
    result_text += "[font_size=18]📊 統計情報[/font_size]\n"
    result_text += "ハイスコア: " + str(GameData.high_score) + " 点\n"
    result_text += "平均スコア: " + str(int(GameData.average_score)) + " 点\n"
    result_text += "総プレイ数: " + str(GameData.total_games) + " 回\n"
    
    # ハイスコア更新チェック
    if GameData.current_score == GameData.high_score:
        result_text += "\n[color=yellow]🎉 ハイスコア更新！おめでとう！[/color]"
    
    $ResultDisplay.text = result_text
    $HighScoreLabel.text = "最高記録: " + str(GameData.high_score) + " 点"
    
    print("✨ 全てのデータが完璧に表示されています！")
    
    $PlayAgainButton.pressed.connect(_on_play_again_pressed)
    $TitleButton.pressed.connect(_on_title_pressed)

func _on_play_again_pressed():
    print("ゲーム画面に戻ります（今度はデータ継続）")
    GameData.start_new_game()  # 新しいセッション開始
    get_tree().change_scene_to_file("res://GameScreen.tscn")

func _on_title_pressed():
    print("タイトル画面に戻ります（全てのデータが保持されています）")
    get_tree().change_scene_to_file("res://TitleScreen.tscn")

# もうデータが消失する心配は一切なし！
```

## 🎉 3. 魔法の瞬間を体験する

### **実行して体験する劇的変化**

**🎮 体験シナリオ：**

1. **タイトル画面**
   ```
   ✨ 前回データが表示される
   「ハイスコア: 0, プレイ回数: 0回」（初回）
   ```

2. **設定画面**
   ```
   ✨ 音量を80に設定、難易度をHardに変更→保存
   「設定がAutoLoadに永続保存されました！」
   ```

3. **タイトルに戻る→再度設定画面**
   ```
   🎉 魔法の瞬間！設定が保持されている！
   音量80、難易度Hard のまま
   ```

4. **ゲーム開始**
   ```
   ✨ プレイヤー名が正しく表示
   ✨ 難易度Hard倍率でスコア1.5倍
   スコア150点獲得（10点×15回×1.5倍）
   ```

5. **結果画面**
   ```
   🎉 魔法の瞬間！全データが表示される！
   「プレイヤー: 太郎, スコア: 150点, 時間: 30秒」
   「ハイスコア更新！おめでとう！」
   ```

6. **タイトルに戻る**
   ```
   ✨ 前回データが更新されている
   「ハイスコア: 150, プレイ回数: 1回」
   ```

### **学習者の感情変化**

```
Week 3: 😫 「データが消えて困る...」
　↓ AutoLoad導入
Week 4: 😮 「え？なにこれ？魔法？」
　↓ 実際に動作確認
　　: 🎉 「すごい！全部解決してる！」
　↓ 数回テスト
　　: 😍 「これは便利すぎる！」
```

## 🔍 4. AutoLoadの威力を実感

### **Before vs After 比較**

```
❌ Week 3 (AutoLoad なし)
- 設定画面: 毎回デフォルト値から設定
- ゲーム画面: プレイヤー名 "???"
- 結果画面: スコア "不明"
- タイトル画面: ハイスコア "不明"

✅ Week 4 (AutoLoad あり) 
- 設定画面: 前回設定値が自動復元
- ゲーム画面: プレイヤー名完璧表示
- 結果画面: 全データ完璧表示
- タイトル画面: 統計データ完璧表示
```

## ✅ Week 4 理解度チェック

### **体験すべき「魔法の瞬間」**
```
✅ 設定が画面移動しても保持される驚き
✅ プレイヤー名がどの画面でも表示される感動
✅ スコアが結果画面で完璧表示される安堵
✅ 統計データが蓄積される満足感
✅ 「これでゲームらしくなった！」という達成感
```

### **技術的理解ポイント**
```
✅ AutoLoadは全シーンからアクセス可能
✅ AutoLoadのデータは画面移動で消えない
✅ 複雑なデータ管理が簡単になる
✅ GameData.変数名 でどこからでもアクセス
✅ 関数も共有可能 (GameData.add_score等)
```

## 🎯 Week 4 まとめ

**今週の体験:**
- **全ての問題が一気に解決** する爽快感
- **魔法のような便利さ** への驚き  
- **実用的なゲーム** が作れる満足感
- **AutoLoadの威力** を完全理解

**学習者の心境変化:**
```
😫 Week 3: 「困った、解決策が欲しい」
😮 Week 4: 「こんな簡単に解決するの？」
🎉 実感後: 「AutoLoad最高！」
💡 理解後: 「これがないとゲーム開発は無理」
```

**習得した技術:**
- AutoLoadの基本概念と使い方
- グローバルデータ管理の手法
- シーン間データ共有の実装
- 実用的なゲーム設計パターン

## 🚀 これで AutoLoad 完全習得！

**おめでとうございます！**
AutoLoadの基本概念から実用的な活用まで、完全に習得されました。

**この知識で実現できること:**
- 本格的なゲームの設定システム
- プレイヤー進行状況の管理
- マルチシーンゲームの開発
- 統計・実績システムの実装

---

**感想はいかがですか？**
- AutoLoadの便利さを実感できましたか？
- Week 3の困り体験から解決への道筋は明確でしたか？
- 他にも学びたいGodotの機能はありますか？

この流れで学習すれば、初心者でもAutoLoadの価値と使い方を完全に理解できますね！🎉