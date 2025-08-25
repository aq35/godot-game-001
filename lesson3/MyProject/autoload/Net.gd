extends Node

var connected: bool = false
var websocket: WebSocketPeer

func _ready():
    print("Network Manager initialized")
    websocket = WebSocketPeer.new()
