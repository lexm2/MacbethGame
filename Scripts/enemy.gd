extends Node2D

@onready var timer: Timer = $AttackArea/AttackHit
@onready var detection: Area2D = $Detection

enum State {
	IDLE,
	HOSTILE,
	ATTACK
}

var player: Node2D = null
var current_state = State.IDLE
var player_detection_area: Area2D
var speed: int = 200

func _process(delta):
	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.HOSTILE:
			_process_hostile(delta)
		State.ATTACK:
			_process_attack(delta)

func _process_idle(delta):
	# Idle state logic
	pass

func _process_hostile(delta):
	timer.stop()
	if player:
		var direction = (player.global_position - global_position).normalized()
		var danger_avoidance = Vector2.ZERO

		for body in detection.get_overlapping_bodies():
			if body is PhysicsBody2D and body != player:
				var danger_direction = (global_position - body.global_position).normalized()
				danger_avoidance += danger_direction

		if danger_avoidance != Vector2.ZERO:
			direction += danger_avoidance.normalized() * 5 # Adjust the weight as needed
			direction = direction.normalized()

		position += direction * speed * delta
	pass

func _process_attack(delta):
	timer.start(3)
	pass

func _on_detection_body_entered(body):
	if body.has_method("player"):
		player = body
	current_state = State.HOSTILE

func _on_attack_area_area_exited(body):
	current_state = State.ATTACK

func _on_attack_area_body_entered(body):
	current_state = State.HOSTILE

func _on_attack_hit_timeout():
	get_tree().reload_current_scene()