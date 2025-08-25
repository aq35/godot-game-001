extends Node
class_name WebSocketClient

var websocket: WebSocketPeer
var connection_url: String = ""
var reconnect_attempts: int = 0
var max_reconnect_attempts: int = 3
var reconnect_delay: float = 5.0

signal connected()
signal disconnected()
signal message_received(message: Dictionary)
signal error_occurred(error: String)

func _ready():
    websocket = WebSocketPeer.new()

func connect_to_server(url: String):
    connection_url = url
    print("Connecting to: ", url)
    
    var error = websocket.connect_to_url(url)
    if error != OK:
        error_occurred.emit("Failed to connect: " + str(error))
        _attempt_reconnect()

func disconnect_from_server():
    websocket.close()
    disconnected.emit()

func send_message(message: Dictionary):
    if websocket.get_ready_state() != WebSocketPeer.STATE_OPEN:
        error_occurred.emit("WebSocket not connected")
        return
    
    var json_string = JSON.stringify(message)
    websocket.send_text(json_string)

func _process(_delta):
    if websocket:
        websocket.poll()
        
        var state = websocket.get_ready_state()
        match state:
            WebSocketPeer.STATE_OPEN:
                while websocket.get_available_packet_count() > 0:
                    var packet = websocket.get_packet()
                    var message_text = packet.get_string_from_utf8()
                    _handle_message(message_text)
            
            WebSocketPeer.STATE_CLOSED:
                var code = websocket.get_close_code()
                var reason = websocket.get_close_reason()
                print("WebSocket closed: ", code, " - ", reason)
                disconnected.emit()
                _attempt_reconnect()

func _handle_message(message_text: String):
    var json = JSON.new()
    var parse_result = json.parse(message_text)
    
    if parse_result != OK:
        error_occurred.emit("Failed to parse message: " + message_text)
        return
    
    message_received.emit(json.data)

func _attempt_reconnect():
    if reconnect_attempts >= max_reconnect_attempts:
        error_occurred.emit("Max reconnect attempts reached")
        return
    
    reconnect_attempts += 1
    print("Reconnect attempt ", reconnect_attempts, "/", max_reconnect_attempts)
    
    await get_tree().create_timer(reconnect_delay).timeout
    connect_to_server(connection_url)
