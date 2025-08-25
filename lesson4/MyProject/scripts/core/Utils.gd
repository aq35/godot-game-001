extends Node
class_name Utils

static func format_time(seconds: float) -> String:
    var hours = int(seconds) / 3600
    var minutes = (int(seconds) % 3600) / 60
    var secs = int(seconds) % 60
    return "%02d:%02d:%02d" % [hours, minutes, secs]

static func validate_email(email: String) -> bool:
    var regex = RegEx.new()
    regex.compile("^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$")
    return regex.search(email) != null

static func clamp_vector3(vec: Vector3, min_val: Vector3, max_val: Vector3) -> Vector3:
    return Vector3(
        clamp(vec.x, min_val.x, max_val.x),
        clamp(vec.y, min_val.y, max_val.y),
        clamp(vec.z, min_val.z, max_val.z)
    )

static func lerp_angle(from: float, to: float, weight: float) -> float:
    var difference = fmod(to - from, TAU)
    var distance = fmod(2.0 * difference, TAU) - difference
    return from + distance * weight

static func safe_divide(a: float, b: float, default: float = 0.0) -> float:
    return a / b if b != 0.0 else default
