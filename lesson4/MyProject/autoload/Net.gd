# Net.gd - ネットワーク通信統括
extends Node

var connected: bool = false
var server_url: String = "ws://localhost:8080"
var websocket: WebSocketPeer

func _ready():
    print("Network Manager initialized")
    websocket = WebSocketPeer.new()

func connect_to_server(url: String = ""):
    if url != "":
        server_url = url
    
    print("Connecting to server: ", server_url)
    var error = websocket.connect_to_url(server_url)
    
    if error != OK:
        print("Failed to connect to server: ", error)
        return false
    
    connected = true
    return true

func send_message(message: Dictionary):
    if not connected:
        print("Not connected to server")
        return
    
    var json_string = JSON.stringify(message)
    websocket.send_text(json_string)

func _process(_delta):
    if websocket:
        websocket.poll()
        while websocket.get_ready_state() == WebSocketPeer.STATE_OPEN and websocket.get_available_packet_count() > 0:
            var packet = websocket.get_packet()
            var message = JSON.parse_string(packet.get_string_from_utf8())
            _handle_message(message)

func _handle_message(message: Dictionary):
    print("Received message: ", message)
