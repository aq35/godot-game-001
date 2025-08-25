extends Node
class_name SaveSystem

const SAVE_FILE = "user://savegame.save"
const BACKUP_FILE = "user://savegame.backup"

static func save_data(data: Dictionary) -> bool:
    # バックアップ作成
    if FileAccess.file_exists(SAVE_FILE):
        var dir = DirAccess.open("user://")
        dir.copy(SAVE_FILE, BACKUP_FILE)
    
    var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
    if file == null:
        print("Failed to open save file")
        return false
    
    var json_string = JSON.stringify(data)
    file.store_string(json_string)
    file.close()
    
    print("Data saved successfully")
    return true

static func load_data() -> Dictionary:
    if not FileAccess.file_exists(SAVE_FILE):
        print("Save file not found")
        return {}
    
    var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
    if file == null:
        print("Failed to open save file")
        return {}
    
    var json_string = file.get_as_text()
    file.close()
    
    var json = JSON.new()
    var parse_result = json.parse(json_string)
    
    if parse_result != OK:
        print("Failed to parse save file")
        return _load_backup()
    
    print("Data loaded successfully")
    return json.data

static func _load_backup() -> Dictionary:
    if not FileAccess.file_exists(BACKUP_FILE):
        return {}
    
    var file = FileAccess.open(BACKUP_FILE, FileAccess.READ)
    var json_string = file.get_as_text()
    file.close()
    
    var json = JSON.new()
    var parse_result = json.parse(json_string)
    
    return json.data if parse_result == OK else {}

static func delete_save():
    var dir = DirAccess.open("user://")
    dir.remove(SAVE_FILE)
    dir.remove(BACKUP_FILE)
    print("Save files deleted")
