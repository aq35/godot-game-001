extends Node
class_name AnimationStates

enum State {
    IDLE,
    WALK,
    RUN,
    JUMP,
    FALL,
    LAND
}

const ANIMATION_NAMES = {
    State.IDLE: "idle",
    State.WALK: "walk",
    State.RUN: "run",
    State.JUMP: "jump",
    State.FALL: "fall",
    State.LAND: "land"
}

const ANIMATION_PRIORITIES = {
    State.IDLE: 0,
    State.WALK: 1,
    State.RUN: 1,
    State.JUMP: 2,
    State.FALL: 2,
    State.LAND: 2
}

static func get_animation_name(state: State) -> String:
    return ANIMATION_NAMES.get(state, "idle")

static func get_priority(state: State) -> int:
    return ANIMATION_PRIORITIES.get(state, 0)
