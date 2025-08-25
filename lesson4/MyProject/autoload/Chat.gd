# Chat.gd - チャット機能
extends Node

var chat_history: Array[Dictionary] = []
var current_room_id: String = ""
var banned_words: Array[String] = ["spam"]

func _ready():
    print("Chat Manager initialized")

func send_message(message: String, room_id: String = ""):
    if room_id == "":
        room_id = current_room_id
    
    var filtered_message = _filter_message(message)
    
    var chat_message = {
        "type": "chat_message",
        "room_id": room_id,
        "user_id": Game.current_user.get("id", "unknown"),
        "user_name": Game.current_user.get("name", "Anonymous"),
        "message": filtered_message,
        "timestamp": Time.get_unix_time_from_system()
    }
    
    add_to_history(chat_message)
    Net.send_message(chat_message)
    print("Chat message sent: ", filtered_message)

func receive_message(message_data: Dictionary):
    add_to_history(message_data)

func add_to_history(message: Dictionary):
    chat_history.append(message)
    if chat_history.size() > 1000:
        chat_history = chat_history.slice(100)

func _filter_message(message: String) -> String:
    var filtered = message
    for banned_word in banned_words:
        filtered = filtered.replace(banned_word, "***")
    return filtered

func get_chat_history(room_id: String = "") -> Array[Dictionary]:
    if room_id == "":
        return chat_history
    
    var room_history: Array[Dictionary] = []
    for message in chat_history:
        if message.get("room_id", "") == room_id:
            room_history.append(message)
    return room_history

func set_current_room(room_id: String):
    current_room_id = room_id
