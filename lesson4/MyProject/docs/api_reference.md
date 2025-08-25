# API Reference

## Autoload Classes

### Game
Global game state manager.

#### Methods
- `set_current_user(user_info: Dictionary)`
- `change_scene(scene_path: String)`
- `set_game_state(new_state: String)`

### Net
Network communication manager.

#### Methods
- `connect_to_server(url: String) -> bool`
- `send_message(message: Dictionary)`

#### Signals
- `connected()`
- `disconnected()`
- `message_received(message: Dictionary)`

## Core Classes

### PlayerController
Handles local player movement and input.

### NetworkMessages
Static methods for creating network messages.

### Utils
Utility functions for common operations.
