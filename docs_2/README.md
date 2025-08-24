## 🏠 ルーム機能の要件整理

### **ルームの種類**
1. **個人ルーム（プライベートルーム）**
   - オーナーが1人
   - 招待制で他ユーザーを入室させられる
   - 装飾・配置をカスタマイズ可能

2. **パブリックルーム** 
   - 誰でも入室可能
   - メインタウンの各エリア
   - 研修ルーム、チャット広場など

3. **グループルーム**
   - 複数人で共有
   - 友達同士、チーム用

### **ルーム機能要件**
- ルーム作成・削除
- 招待/キック機能
- ルーム一覧・検索
- 入室時の権限チェック
- ルーム内でのチャット分離
- ルーム設定（公開/非公開）

## 🔧 技術的実現方法## 🔄 ルームシステム統合

**AutoLoad設定更新:**
```
Game    - scripts/singletons/Game.gd
Net     - scripts/singletons/Net.gd  
Chat    - scripts/singletons/Chat.gd
Audio   - scripts/singletons/Audio.gd
Rooms   - scripts/singletons/Rooms.gd  # ← 新規追加
```

## 📱 UI実装例## 🚀 実装の流れ

**段階的実装順序:**

1. **基本ルーム機能** (3-4時間)
   - `Rooms.gd` シングルトン実装
   - パブリックルーム入退室
   - 基本的なネットワーク通信

2. **ルーム一覧UI** (2時間)
   - `RoomListPanel.gd` 実装
   - ルーム検索・フィルタリング

3. **プライベートルーム** (3時間)
   - 作成・招待機能
   - パスワード保護
   - 権限管理

4. **ルーム内機能** (2-3時間)
   - メンバー一覧表示
   - チャット分離
   - 装飾システム（オプション）

## 🔄 サーバー側（Go）との連携

**GraphQLスキーマ例:**
```graphql
type Room {
  room_id: String!
  room_name: String!
  room_type: RoomType!
  owner_id: String!
  current_players: Int!
  max_players: Int!
}

type Query {
  rooms: [Room!]!
  user_rooms(user_id: String!): [Room!]!
}

type Mutation {
  create_private_room(input: CreateRoomInput!): CreateRoomResult!
  join_room(room_id: String!, user_id: String!): JoinRoomResult!
}
```

**WebSocketメッセージ例:**
```json
{
  "type": "room_member_joined",
  "room_id": "room_123",
  "data": {
    "user_id": "user_456",
    "username": "Alice",
    "permission": "VISITOR"
  }
}
```

この構成で：
- ✅ **スケーラブル** - ルーム単位での通信分離
- ✅ **柔軟性** - パブリック/プライベート両対応
- ✅ **セキュア** - 権限管理とパスワード保護
- ✅ **リアルタイム** - WebSocketでの即座同期

どの部分から実装を始めますか？それとも特定の機能について詳しく知りたいでしょうか？