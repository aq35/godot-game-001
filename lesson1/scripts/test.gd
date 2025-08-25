# test.gd - ノードとシーンの概念をheadlessモードで学ぶ
extends SceneTree

func _init():
    print("=== Godot ノード・シーン学習プログラム ===")
    print("")
    
    # ステップ1: ノードの概念を理解
    learn_nodes()
    print("")
    
    # ステップ2: シーンの概念を理解
    learn_scenes()
    print("")
    
    # ステップ3: 実際にノードツリーを作成
    create_node_tree()
    print("")
    
    # ステップ4: 変数と関数の基本
    learn_variables_and_functions()
    
    # プログラム終了
    quit()

# ステップ1: ノードの概念
func learn_nodes():
    print("📦 【ステップ1】ノードとは何か？")
    print("ノード = ゲームの部品です")
    print("")
    
    # 異なる種類のノードを作成してみる
    var label_node = Label.new()
    label_node.name = "タイトル表示"
    print("✅ Labelノード「", label_node.name, "」を作成しました")
    print("   → 文字を表示するための部品")
    
    var button_node = Button.new()
    button_node.name = "スタートボタン"
    print("✅ Buttonノード「", button_node.name, "」を作成しました")
    print("   → クリックできるボタンの部品")
    
    var audio_node = AudioStreamPlayer.new()
    audio_node.name = "BGM再生"
    print("✅ AudioStreamPlayerノード「", audio_node.name, "」を作成しました")
    print("   → 音を鳴らすための部品")
    
    print("")
    print("💡 ノードはそれぞれ専門的な機能を持つ部品です")

# ステップ2: シーンの概念
func learn_scenes():
    print("🏠 【ステップ2】シーンとは何か？")
    print("シーン = ノード（部品）を組み合わせた完成品です")
    print("")
    
    # シーン（実際にはノード）を作成
    var main_scene = Control.new()
    main_scene.name = "メインシーン"
    print("✅ 「", main_scene.name, "」を作成しました（家の土台）")
    
    # シーンにノードを追加（子ノードとして）
    var title_label = Label.new()
    title_label.name = "ゲームタイトル"
    main_scene.add_child(title_label)
    print("  └── 「", title_label.name, "」を追加（看板を設置）")
    
    var start_button = Button.new()
    start_button.name = "開始ボタン"
    main_scene.add_child(start_button)
    print("  └── 「", start_button.name, "」を追加（ドアベルを設置）")
    
    var bgm_player = AudioStreamPlayer.new()
    bgm_player.name = "背景音楽"
    main_scene.add_child(bgm_player)
    print("  └── 「", bgm_player.name, "」を追加（音響設備を設置）")
    
    print("")
    print("💡 シーン = 親ノード + 複数の子ノード の組み合わせ")
    print("💡 子ノードの数:", main_scene.get_child_count(), "個")

# ステップ3: 実際のノードツリー作成
func create_node_tree():
    print("🌳 【ステップ3】ノードツリーを作ってみよう")
    print("ツリー構造 = 家族のような親子関係")
    print("")
    
    # ルートノード作成
    var root = Node.new()
    root.name = "ゲームルート"
    print("👑 親:", root.name)
    
    # 子ノードたちを作成
    var child1 = Node.new()
    child1.name = "プレイヤー管理"
    root.add_child(child1)
    
    var child2 = Node.new()
    child2.name = "敵管理"
    root.add_child(child2)
    
    var child3 = Node.new()
    child3.name = "UI管理"
    root.add_child(child3)
    
    # 孫ノードも作成
    var grandchild = Node.new()
    grandchild.name = "スコア表示"
    child3.add_child(grandchild)
    
    # ツリー構造を表示
    print_tree_structure(root, "")
    
    print("")
    print("💡 このような階層構造でゲームを整理します")

# ツリー構造を見やすく表示する関数
func print_tree_structure(node: Node, indent: String):
    print(indent, "├── ", node.name)
    var new_indent = indent + "│   "
    for child in node.get_children():
        print_tree_structure(child, new_indent)

# ステップ4: 変数と関数の基本
func learn_variables_and_functions():
    print("🔧 【ステップ4】変数と関数の基本")
    print("")
    
    # 変数 = データを保存する箱
    print("📦 変数（データ保存箱）の例:")
    var player_name = "勇者"
    var player_level = 5
    var player_hp = 100.0
    var is_alive = true
    
    print("  📝 player_name = \"", player_name, "\" (文字列)")
    print("  🔢 player_level = ", player_level, " (整数)")
    print("  💚 player_hp = ", player_hp, " (小数)")
    print("  ✅ is_alive = ", is_alive, " (真偽値)")
    print("")
    
    # 関数 = 処理をまとめた機械
    print("⚙️ 関数（処理する機械）の例:")
    show_player_status(player_name, player_level, player_hp)
    print("")
    
    # 関数を使ってデータを変更
    player_hp = take_damage(player_hp, 25.0)
    player_level = level_up(player_level)
    
    print("📊 変更後のステータス:")
    show_player_status(player_name, player_level, player_hp)

# プレイヤーステータス表示関数
func show_player_status(name: String, level: int, hp: float):
    print("  👤 名前: ", name)
    print("  🔺 レベル: ", level)
    print("  ❤️ HP: ", hp)

# ダメージを受ける関数
func take_damage(current_hp: float, damage: float) -> float:
    var new_hp = current_hp - damage
    print("  💥 ", damage, " のダメージを受けました！")
    print("  💔 HP: ", current_hp, " → ", new_hp)
    return new_hp

# レベルアップ関数
func level_up(current_level: int) -> int:
    var new_level = current_level + 1
    print("  🎉 レベルアップ！ ", current_level, " → ", new_level)
    return new_level