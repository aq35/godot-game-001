extends Control
class_name UIController

var current_screen: String = ""
var screen_history: Array[String] = []
var ui_elements: Dictionary = {}

signal screen_changed(screen_name: String)

func _ready():
    EventBus.ui_screen_changed.connect(_on_screen_changed)

func show_screen(screen_name: String):
    if current_screen != "":
        screen_history.append(current_screen)
    
    current_screen = screen_name
    screen_changed.emit(screen_name)
    EventBus.ui_screen_changed.emit(screen_name)

func go_back():
    if screen_history.size() > 0:
        var previous_screen = screen_history.pop_back()
        show_screen(previous_screen)

func _on_screen_changed(screen_name: String):
    print("Screen changed to: ", screen_name)
