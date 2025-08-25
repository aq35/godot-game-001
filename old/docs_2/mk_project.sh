# プロジェクトルートディレクトリ作成
mkdir -p ./GodotMultiplayerGame
cd ./GodotMultiplayerGame

# Gitリポジトリ初期化
git init

# Godotプロジェクトファイル作成（後でGodotで設定）
touch project.godot

# AutoLoadシングルトン用
mkdir -p autoload

# メインシーン用
mkdir -p scenes/main
mkdir -p scenes/player

# コアスクリプト用
mkdir -p scripts/core
mkdir -p scripts/network
mkdir -p scripts/player

# 設定・データファイル用
mkdir -p data/config
mkdir -p data/cache

# アセット基本構造
mkdir -p assets/characters/models
mkdir -p assets/ui/icons
mkdir -p assets/ui/themes
mkdir -p assets/ui/fonts
mkdir -p assets/audio/bgm
mkdir -p assets/audio/sfx

# 開発用ファイル
mkdir -p docs
mkdir -p tools

# AutoLoadシングルトンファイル
touch autoload/Game.gd
touch autoload/Settings.gd
touch autoload/EventBus.gd

# メインシーンファイル  
touch scenes/main/Main.tscn
touch scenes/main/Main.gd

# コアスクリプトファイル
touch scripts/core/Constants.gd
touch scripts/core/GameTypes.gd
touch scripts/core/Utils.gd

# 設定ファイル
touch data/config/server_config.json
touch data/config/game_settings.json

# 開発用ファイル
touch .gitignore
touch README.md
touch docs/setup_guide.md

# キャッシュディレクトリ用（Git管理外）
touch data/cache/.gitkeep

### `.gitignore` ファイル
cat > .gitignore << 'EOF'
# Godotファイル
.godot/
.import/
export.cfg
export_presets.cfg
override.cfg

# 一時ファイル
*.tmp
.~*
*~

# ユーザー設定
user://
data/cache/*
!data/cache/.gitkeep

# ログファイル
*.log

# OS固有ファイル
.DS_Store
Thumbs.db

# IDE設定
.vscode/
.idea/
*.swp
*.swo

# ビルド出力
builds/
exports/
EOF

### `README.md` 基本内容
cat > README.md << 'EOF'
# 3D Multiplayer Game (Godot)

Gatherライクなマルチプレイヤー3Dゲーム

## 技術構成
- **Client**: Godot 4.4
- **Server**: Go + GraphQL 
- **Communication**: GraphQL + WebSocket

```bash
GodotMultiplayerGame/
├── .git/
├── .gitignore
├── README.md
├── project.godot                   # 空ファイル（Godotで設定）
│
├── autoload/                       # Phase 1で実装
│   ├── Game.gd                    # 空ファイル
│   ├── Settings.gd                # 空ファイル
│   └── EventBus.gd                # 空ファイル
│
├── scenes/
│   ├── main/
│   │   ├── Main.tscn              # 空ファイル  
│   │   └── Main.gd                # 空ファイル
│   └── player/
│       ├── Player.tscn            # 空ファイル
│       └── Player.gd              # 空ファイル
│
├── scripts/
│   └── core/
│       ├── Constants.gd           # 空ファイル
│       ├── GameTypes.gd           # 空ファイル
│       └── Utils.gd               # 空ファイル
│
├── data/
│   ├── config/
│   │   ├── server_config.json     # 設定済み
│   │   └── game_settings.json     # 設定済み
│   └── cache/
│       └── .gitkeep
│
└── assets/                         # 基本構造のみ
    ├── characters/models/
    ├── ui/
    └── audio/
```

## 開発状況
- [x] Phase 1: 基盤セットアップ（進行中）
- [ ] Phase 2: 単体プレイヤー
- [ ] Phase 3: ネットワーク基盤
- [ ] Phase 4: マルチプレイヤー基礎

## セットアップ
1. Godot 4.4をインストール
2. このプロジェクトをインポート
3. `docs/setup_guide.md`を参照

## プロジェクト構造
詳細は `docs/architecture.md` を参照
EOF


### 基本的な設定JSONファイル
bash
# サーバー設定
cat > data/config/server_config.json << 'EOF'
{
  "development": {
    "graphql_url": "http://localhost:8080/graphql",
    "websocket_url": "ws://localhost:8080/ws",
    "api_timeout": 30
  },
  "production": {
    "graphql_url": "https://api.yourgame.com/graphql", 
    "websocket_url": "wss://api.yourgame.com/ws",
    "api_timeout": 30
  }
}
EOF

# ゲーム基本設定
cat > data/config/game_settings.json << 'EOF'
{
  "game": {
    "title": "3D Multiplayer Game",
    "version": "0.1.0",
    "max_players_per_room": 20,
    "sync_rate": 10,
    "default_character_id": 1
  },
  "ui": {
    "chat_message_limit": 100,
    "notification_duration": 3.0
  }
}
EOF


## Step 5: Phase 1用追加構造（オプション）

bash
# UI関連（Phase 5で本格使用）
mkdir -p scenes/ui/screens
mkdir -p scenes/ui/dialogs
mkdir -p scenes/ui/components

# 基本UIファイルも作成（空ファイル）
touch scenes/ui/screens/LoginScreen.tscn
touch scenes/ui/screens/LoginScreen.gd

# ワールド関連（Phase 2-4で使用）
mkdir -p scenes/worlds
touch scenes/worlds/TestWorld.tscn
touch scenes/worlds/TestWorld.gd

# プレイヤー関連
touch scenes/player/Player.tscn
touch scenes/player/Player.gd
touch scripts/player/PlayerController.gd

