extends CharacterBody2D

@onready var timer: Timer = $AttackArea/AttackHit
@onready var detection: Area2D = $Detection

enum State {
	IDLE,
	HOSTILE,
	ATTACK
}

var player: Node2D = null
var current_state = State.IDLE
var speed: int = 200

func _process(delta):
	match current_state:
		State.IDLE:
			_process_idle(delta)
		State.HOSTILE:
			_process_hostile(delta)
		State.ATTACK:
			_process_attack(delta)

func _process_idle(_delta):
	# Idle state logic
	velocity = Vector2.ZERO
	move_and_slide()

func _process_hostile(_delta):
	timer.stop()
	if player:
		var direction = (player.global_position - global_position).normalized()
		var danger_avoidance = Vector2.ZERO

		for body in detection.get_overlapping_bodies():
			if body is PhysicsBody2D and body != player:
				var danger_direction = (global_position - body.global_position).normalized()
				danger_avoidance += danger_direction

		if danger_avoidance != Vector2.ZERO:
			direction += danger_avoidance.normalized() * 2 # Adjust the weight as needed
			direction = direction.normalized()

		velocity = direction * speed

	move_and_slide()

func _process_attack(_delta):
	velocity = Vector2.ZERO
	move_and_slide()

func _on_detection_body_entered(body: Node2D):
	if body.has_method("player"):
		print("_on_detection_body_entered")
		player = body
	current_state = State.HOSTILE

func _on_attack_area_body_exited(_body:Node2D):
	print("_on_attack_area_body_exited")
	current_state = State.HOSTILE

func _on_attack_area_body_entered(_body:Node2D):
	print("_on_attack_area_body_entered")
	current_state = State.ATTACK
	timer.start(3)

func _on_attack_hit_timeout():
	print("_on_attack_hit_timeout")
	get_tree().reload_current_scene()
