extends CharacterBody2D

@export
var vitesse: int = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * vitesse
	move_and_slide()
