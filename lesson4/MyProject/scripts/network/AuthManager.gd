extends Node
class_name AuthManager

var jwt_token: String = ""
var refresh_token: String = ""
var user_data: Dictionary = {}

signal login_successful(user_data: Dictionary)
signal login_failed(error: String)
signal logout_completed()
signal token_refreshed()

func login(username: String, password: String):
    var request_data = {
        "username": username,
        "password": password
    }
    
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_login_response)
    
    var json = JSON.stringify(request_data)
    var headers = ["Content-Type: application/json"]
    http_request.request("http://localhost:8080/auth/login", headers, HTTPClient.METHOD_POST, json)

func logout():
    jwt_token = ""
    refresh_token = ""
    user_data = {}
    logout_completed.emit()

func refresh_auth_token():
    if refresh_token == "":
        login_failed.emit("No refresh token available")
        return
    
    var request_data = {"refresh_token": refresh_token}
    var http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_refresh_response)
    
    var json = JSON.stringify(request_data)
    var headers = ["Content-Type: application/json"]
    http_request.request("http://localhost:8080/auth/refresh", headers, HTTPClient.METHOD_POST, json)

func get_auth_headers() -> Array[String]:
    if jwt_token == "":
        return []
    return ["Authorization: Bearer " + jwt_token]

func _on_login_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
    var response_text = body.get_string_from_utf8()
    
    if response_code == 200:
        var json = JSON.new()
        var parse_result = json.parse(response_text)
        
        if parse_result == OK:
            var data = json.data
            jwt_token = data.get("access_token", "")
            refresh_token = data.get("refresh_token", "")
            user_data = data.get("user", {})
            
            login_successful.emit(user_data)
        else:
            login_failed.emit("Failed to parse login response")
    else:
        login_failed.emit("Login failed: " + str(response_code))

func _on_refresh_response(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
    var response_text = body.get_string_from_utf8()
    
    if response_code == 200:
        var json = JSON.new()
        var parse_result = json.parse(response_text)
        
        if parse_result == OK:
            var data = json.data
            jwt_token = data.get("access_token", "")
            token_refreshed.emit()
        else:
            login_failed.emit("Failed to parse refresh response")
    else:
        login_failed.emit("Token refresh failed: " + str(response_code))
