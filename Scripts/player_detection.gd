extends Area2D

# Assuming other necessary variables and setup are already defined

# Signal to detect when a body enters the area
signal body_entered_signal(body)

func _ready():


func _on_body_entered(body: Node) -> void:
    # Check if the entered body is of type CharacterBody2D
    if body is CharacterBody2D:
        print("CharacterBody2D entered the detection area.")
        emit_signal("body_entered_signal", body)
        # Assuming runnable is passed somehow, e.g., via a signal or directly as a parameter
        # Here we expect a callable to be passed with the signal or set as a member variable
        if callable(runnable):
            runnable.call(body)
        else:
            print("Provided runnable is not callable.")
    else:
        print("The entered body is not a CharacterBody2D.")
