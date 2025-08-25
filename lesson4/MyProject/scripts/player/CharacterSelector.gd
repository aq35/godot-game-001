extends Node
class_name CharacterSelector

var character_data: Array[Dictionary] = []
var selected_character_id: String = ""
var preview_node: Node3D

signal character_selected(character_id: String)
signal character_loaded(character_data: Dictionary)

func _ready():
    load_character_data()

func load_character_data():
    var file = FileAccess.open("res://data/config/character_list.json", FileAccess.READ)
    if file == null:
        print("Character list not found")
        return
    
    var json_string = file.get_as_text()
    file.close()
    
    var json = JSON.new()
    var parse_result = json.parse(json_string)
    
    if parse_result == OK:
        character_data = json.data.get("characters", [])
        print("Loaded ", character_data.size(), " characters")
    else:
        print("Failed to parse character list")

func get_character_list() -> Array[Dictionary]:
    return character_data

func select_character(character_id: String):
    for character in character_data:
        if character.id == character_id:
            selected_character_id = character_id
            character_selected.emit(character_id)
            character_loaded.emit(character)
            return
    
    print("Character not found: ", character_id)

func get_selected_character() -> Dictionary:
    for character in character_data:
        if character.id == selected_character_id:
            return character
    return {}

func load_character_model(character_id: String) -> PackedScene:
    for character in character_data:
        if character.id == character_id:
            var model_path = character.get("model_path", "")
            if model_path != "":
                return load(model_path) as PackedScene
    return null

func create_character_preview(character_id: String, parent_node: Node3D):
    var model_scene = load_character_model(character_id)
    if model_scene:
        var instance = model_scene.instantiate()
        parent_node.add_child(instance)
        preview_node = instance
        return instance
    return null

func clear_preview():
    if preview_node and is_instance_valid(preview_node):
        preview_node.queue_free()
        preview_node = null
