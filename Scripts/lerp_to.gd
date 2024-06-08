extends Object

var player: Node2D = null
var camera: Camera2D = null
var target_position: Vector2 = Vector2()
var lerp_duration: float = 1.0  # Duration of the lerp in seconds
var lerp_time: float

signal proceed_with_lerp_back()
signal move_to_coordinates_finished()

enum State {
    LERP_TO_TARGET,
    WAIT,
    LERP_BACK,
    FOLLOW_PLAYER
}

var state: State = State.FOLLOW_PLAYER

# Moves the player to a specified position on a tilemap with a smooth lerp transition.
# @param body: The player node.
# @param tilemap: The tilemap where the target position is located.
# @param tilePos: The tile position to move to.
# @param lerpDuration: Duration of the lerp to the target position.
# @param waitDuration: Duration to wait before lerping back.
func move_to_coordinates(body: Node2D, currentCamera: Camera2D, tilemap: TileMap, tilePos: Vector2, _waitFor : bool = true, lerpDuration: float = 1.0) -> void:
    print("Moving to coordinates: " + str(tilePos))
    player = body
    camera = currentCamera
    target_position = tilemap.map_to_local(tilePos)
    lerp_time = 0.0
    lerp_time = lerpDuration
    state = State.LERP_TO_TARGET
    print("LERP_TO_TARGET")
    player.disable_movement()
    connect("proceed_with_lerp_back", Callable(self, "_proceed_with_lerp_back"))

func _process(delta: float) -> void:
    if not player or not camera:
        return

    match state:
        State.LERP_TO_TARGET:
            lerp_time += delta
            var t: float = lerp_time / lerp_duration
            if t > 1.0:
                t = 1.0
                state = State.WAIT
                print("WAIT")
            camera.global_position = camera.global_position.lerp(target_position, t)
            print(camera.global_position)
            print(camera.global_position.lerp(target_position, t))

        State.WAIT:
            pass

        State.LERP_BACK:
            lerp_time += delta
            var t: float = lerp_time / lerp_duration
            if t > 1.0:
                t = 1.0
                state = State.FOLLOW_PLAYER
                print("FOLLOW_PLAYER")
                player.enable_movement()
                emit_signal("move_to_coordinates_finished")
            camera.global_position = camera.global_position.lerp(player.global_position, t)

        State.FOLLOW_PLAYER:
            camera.global_position = player.global_position
            
func _proceed_with_lerp_back():
    state = State.LERP_BACK
