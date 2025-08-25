extends Node
class_name NetworkMessages

enum MessageType {
    PLAYER_POSITION,
    PLAYER_ANIMATION,
    CHAT_MESSAGE,
    ROOM_JOIN,
    ROOM_LEAVE,
    ROOM_CREATE,
    SYSTEM_MESSAGE
}

static func create_player_position_message(player_id: String, position: Vector3, rotation: Vector3) -> Dictionary:
    return {
        "type": MessageType.PLAYER_POSITION,
        "player_id": player_id,
        "position": {"x": position.x, "y": position.y, "z": position.z},
        "rotation": {"x": rotation.x, "y": rotation.y, "z": rotation.z},
        "timestamp": Time.get_unix_time_from_system()
    }

static func create_player_animation_message(player_id: String, animation: String) -> Dictionary:
    return {
        "type": MessageType.PLAYER_ANIMATION,
        "player_id": player_id,
        "animation": animation,
        "timestamp": Time.get_unix_time_from_system()
    }

static func create_chat_message(room_id: String, user_id: String, message: String) -> Dictionary:
    return {
        "type": MessageType.CHAT_MESSAGE,
        "room_id": room_id,
        "user_id": user_id,
        "message": message,
        "timestamp": Time.get_unix_time_from_system()
    }

static func create_room_join_message(room_id: String, user_id: String) -> Dictionary:
    return {
        "type": MessageType.ROOM_JOIN,
        "room_id": room_id,
        "user_id": user_id,
        "timestamp": Time.get_unix_time_from_system()
    }

static func create_room_leave_message(room_id: String, user_id: String) -> Dictionary:
    return {
        "type": MessageType.ROOM_LEAVE,
        "room_id": room_id,
        "user_id": user_id,
        "timestamp": Time.get_unix_time_from_system()
    }
