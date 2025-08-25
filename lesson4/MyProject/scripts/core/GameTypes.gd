extends Node
class_name GameTypes

class PlayerData:
    var id: String
    var name: String
    var character_id: String
    var position: Vector3
    var rotation: Vector3
    
    func _init(p_id: String = "", p_name: String = ""):
        id = p_id
        name = p_name
        character_id = "character_01"
        position = Vector3.ZERO
        rotation = Vector3.ZERO

class RoomInfo:
    var id: String
    var name: String
    var type: String
    var owner_id: String
    var max_members: int
    var current_members: Array[String]
    var created_at: float
    
    func _init():
        current_members = []
        max_members = 10

class ChatMessage:
    var type: String
    var room_id: String
    var user_id: String
    var user_name: String
    var message: String
    var timestamp: float
    
    func _init():
        type = "chat_message"
        timestamp = Time.get_unix_time_from_system()

class TrainingData:
    var id: String
    var title: String
    var description: String
    var url: String
    var category: String
    var progress: float
    var completed: bool
    
    func _init():
        progress = 0.0
        completed = false
