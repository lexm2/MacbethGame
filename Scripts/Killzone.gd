extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D):
	if body.has_method("player"):
		print("died")
		body.disable_movement()
		timer.start()

func _on_timer_timeout():
	get_tree().reload_current_scene()
