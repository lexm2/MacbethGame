extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
const MAX_SPEED: float = 100.0
var input: Vector2 = Vector2()

enum State {
    IDLE,
    MOVING,
    DISABLED
}

var state: State = State.IDLE

func _physics_process(delta: float) -> void:
    match state:
        State.IDLE:
            handle_idle_state(delta)
        State.MOVING:
            handle_moving_state(delta)
        State.DISABLED:
            handle_disabled_state()

func handle_idle_state(delta: float) -> void:
        input = get_input()
        if input != Vector2.ZERO:
            state = State.MOVING
            handle_moving_state(delta)

func handle_moving_state(delta: float) -> void:
        input = get_input()
        if input != Vector2.ZERO:
            velocity = input * MAX_SPEED * delta * 100  # Set velocity in the direction of input
        else:
            velocity = Vector2.ZERO  # Stop moving when there is no input
            state = State.IDLE
        move_and_slide()  # Move the player

func handle_disabled_state() -> void:
    # No movement or actions allowed in this state
    pass

func get_input() -> Vector2:
    # Get directional input from the keyboard
    input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
    return input.normalized()

func disable_movement():
    state = State.DISABLED

func enable_movement():
    state = State.IDLE


func player():
    pass