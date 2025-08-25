# ============================================================================
# scenes/main/Main.gd
# メインシーン - ゲーム起動時の最初のシーン
# ============================================================================
extends Control

# UI要素（Phase 5で本格実装）
@onready var startup_label: Label = $StartupLabel
@onready var version_label: Label = $VersionLabel

# 起動状態
var is_initialized: bool = false

# ============================================================================
# 初期化
# ============================================================================

func _ready():
	print("[Main] Starting game initialization...")
	
	# 基本UI設定
	_setup_ui()
	
	# 初期化開始
	_initialize_game()

func _setup_ui():
	# 起動中メッセージ表示
	if startup_label:
		startup_label.text = "ゲーム起動中..."
		startup_label.modulate = Color.WHITE
	
	# バージョン情報表示
	if version_label:
		version_label.text = "Version " + GameConstants.APP_VERSION
		version_label.modulate = Color(1.0, 1.0, 1.0, 0.7)

# ============================================================================
# ゲーム初期化
# ============================================================================

func _initialize_game():
	print("[Main] Initializing game systems...")
	
	# Phase 1では基本的な初期化のみ
	await _run_initialization_sequence()
	
	# 初期化完了後の処理
	_on_initialization_complete()

# 初期化シーケンス実行
func _run_initialization_sequence():
	# 各システムの初期化（段階的に表示更新）
	
	_update_startup_message("設定を読み込み中...")
	await get_tree().process_frame
	
	# 設定システム確認（既にAutoLoadで初期化済み）
	if not Settings.validate_settings():
		_update_startup_message("設定の初期化に失敗しました")
		return
	
	_update_startup_message("キャラクターデータを確認中...")
	await get_tree().create_timer(0.5).timeout  # 表示のための短い待機
	
	# Phase 3で実装予定のネットワーク初期化の準備
	_update_startup_message("ネットワーク設定を確認中...")
	await get_tree().create_timer(0.5).timeout
	
	# 初期化完了
	_update_startup_message("初期化完了")
	await get_tree().create_timer(0.5).timeout

# 起動メッセージ更新
func _update_startup_message(message: String):
	if startup_label:
		startup_label.text = message
	print("[Main] ", message)

# 初期化完了時の処理
func _on_initialization_complete():
	print("[Main] Game initialization completed")
	is_initialized = true
	
	# Phase 1では単純にテストメッセージ表示
	_show_phase1_complete_message()

# Phase 1完了メッセージ表示
func _show_phase1_complete_message():
	_update_startup_message("Phase 1: 基盤セットアップ完了！")
	
	# デバッグ情報表示
	if OS.is_debug_build():
		Game.print_debug_info()
	
	# Phase 2実装まではここで待機
	await get_tree().create_timer(2.0).timeout
	_update_startup_message("Phase 2の実装をお待ちください...")

# ============================================================================
# 入力処理（テスト用）
# ============================================================================

func _input(event):
	if not is_initialized:
		return
	
	# Phase 1テスト用のキー入力
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1:
				_run_phase1_tests()
			KEY_F2:
				Settings.print_debug_info() if Settings.has_method("print_debug_info") else print("Settings debug not available")
			KEY_F3:
				Game.print_debug_info()
			KEY_ESCAPE:
				_quit_game()

# ============================================================================
# Phase 1テスト機能
# ============================================================================

func _run_phase1_tests():
	print("\n=== Phase 1 Tests ===")
	
	# AutoLoadテスト
	print("1. AutoLoad Test:")
	print("   Game singleton: ", Game != null)
	print("   Settings singleton: ", Settings != null)
	print("   EventBus singleton: ", EventBus != null)
	
	# 設定システムテスト
	print("\n2. Settings Test:")
	var test_value = "phase1_test_" + str(randi())
	Settings.set_setting("test_key", test_value)
	var loaded_value = Settings.get_setting("test_key")
	print("   Set/Get test: ", test_value == loaded_value)
	
	# イベントシステムテスト
	print("\n3. Event System Test:")
	EventBus.emit_notification("テスト", "Phase 1動作確認", "info")
	
	# ユーティリティテスト
	print("\n4. Utils Test:")
	var test_dict = {"test": "value", "number": 123}
	var json_path = "user://test_phase1.json"
	var save_result = GameUtils.save_json_file(json_path, test_dict)
	var loaded_dict = GameUtils.load_json_file(json_path)
	print("   JSON save/load test: ", save_result and test_dict.test == loaded_dict.get("test", ""))
	
	print("===================\n")

# ============================================================================
# 終了処理
# ============================================================================

func _quit_game():
	print("[Main] Quitting game...")
	
	# 設定保存
	Settings.save_settings()
	
	# 終了
	get_tree().quit()

# ============================================================================
# デバッグ用ヘルパー
# ============================================================================

func _notification(what):
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			_quit_game()
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if is_initialized:
				print("[Main] Application lost focus")
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if is_initialized:
				print("[Main] Application gained focus")