# Rooms.gd - ルーム管理
extends Node

var rooms: Dictionary = {}
var current_room: Dictionary = {}

func _ready():
    print("Room Manager initialized")

func create_room(room_name: String, room_type: String = "public", max_members: int = 10) -> Dictionary:
    var room_id = _generate_room_id()
    var room_data = {
        "id": room_id,
        "name": room_name,
        "type": room_type,
        "owner_id": Game.current_user.get("id", "unknown"),
        "max_members": max_members,
        "current_members": [],
        "created_at": Time.get_unix_time_from_system()
    }
    
    rooms[room_id] = room_data
    print("Room created: ", room_name, " (ID: ", room_id, ")")
    return room_data

func join_room(room_id: String) -> bool:
    if not room_id in rooms:
        print("Room not found: ", room_id)
        return false
    
    var room = rooms[room_id]
    var user_id = Game.current_user.get("id", "unknown")
    
    if user_id in room.current_members:
        current_room = room
        return true
    
    if room.current_members.size() >= room.max_members:
        print("Room is full: ", room_id)
        return false
    
    room.current_members.append(user_id)
    current_room = room
    Chat.set_current_room(room_id)
    
    print("Joined room: ", room.name)
    return true

func leave_room():
    if current_room.is_empty():
        return
    
    var user_id = Game.current_user.get("id", "unknown")
    var room = current_room
    room.current_members.erase(user_id)
    
    print("Left room: ", room.name)
    current_room = {}

func get_room_list() -> Array[Dictionary]:
    var room_list: Array[Dictionary] = []
    for room in rooms.values():
        room_list.append(room)
    return room_list

func _generate_room_id() -> String:
    return "room_" + str(Time.get_unix_time_from_system()) + "_" + str(randi() % 10000)

func get_current_room() -> Dictionary:
    return current_room
