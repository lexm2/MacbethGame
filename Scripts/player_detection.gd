extends Area2D

@export var tilemap: TileMap
@export var tile_pos: Vector2 = Vector2()

var started: bool = false
var player: Node2D = null
var target_position: Vector2 = Vector2()
var lerp_duration: float = 1.0  # Duration of the lerp in seconds
var lerp_time: float = 0.0
var wait_time: float = 2.0  # Time to wait after reaching the target position
var current_wait_time: float = 0.0

enum State {
    LERP_TO_TARGET,
    WAIT,
    LERP_BACK,
    FOLLOW_PLAYER
}

var state: State = State.FOLLOW_PLAYER

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("player"):
        player = body

        if not started:
            started = true
            target_position = tilemap.map_to_local(tile_pos)
            lerp_time = 0.0  # Reset the lerp time
            state = State.LERP_TO_TARGET
            player.disable_movement()

func _process(delta: float) -> void:
    if not started or not player:
        return

    match state:
        State.LERP_TO_TARGET:
            lerp_time += delta
            var t: float = lerp_time / lerp_duration
            if t > 1.0:
                t = 1.0
                state = State.WAIT
                current_wait_time = 0.0
            player.camera.global_position = player.camera.global_position.lerp(target_position, t)

        State.WAIT:
            current_wait_time += delta
            if current_wait_time >= wait_time:
                lerp_time = 0.0
                state = State.LERP_BACK

        State.LERP_BACK:
            lerp_time += delta
            var t: float = lerp_time / lerp_duration
            if t > 1.0:
                t = 1.0
                state = State.FOLLOW_PLAYER
                player.enable_movement()
            player.camera.global_position = player.camera.global_position.lerp(player.global_position, t)

        State.FOLLOW_PLAYER:
            # Normal behavior, e.g., following the player
            player.camera.global_position = player.global_position
