extends Node
class_name GraphQLClient

var http_request: HTTPRequest
var base_url: String = "http://localhost:8080/graphql"

signal query_completed(result: Dictionary)
signal mutation_completed(result: Dictionary)
signal error_occurred(error: String)

func _ready():
    http_request = HTTPRequest.new()
    add_child(http_request)
    http_request.request_completed.connect(_on_request_completed)

func execute_query(query: String, variables: Dictionary = {}):
    var request_data = {
        "query": query,
        "variables": variables
    }
    _send_request(request_data, "query")

func execute_mutation(mutation: String, variables: Dictionary = {}):
    var request_data = {
        "query": mutation,
        "variables": variables
    }
    _send_request(request_data, "mutation")

func _send_request(data: Dictionary, type: String):
    var json = JSON.stringify(data)
    var headers = ["Content-Type: application/json"]
    
    http_request.request(base_url, headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
    var response_text = body.get_string_from_utf8()
    
    if response_code != 200:
        error_occurred.emit("HTTP Error: " + str(response_code))
        return
    
    var json = JSON.new()
    var parse_result = json.parse(response_text)
    
    if parse_result != OK:
        error_occurred.emit("Failed to parse JSON response")
        return
    
    var response_data = json.data
    
    if "errors" in response_data:
        error_occurred.emit(str(response_data.errors))
        return
    
    if "data" in response_data:
        query_completed.emit(response_data.data)
    else:
        mutation_completed.emit(response_data)
