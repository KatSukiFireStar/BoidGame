extends CharacterBody2D

@export
var vitesse: int = 100

var maxX : float
var maxY : float

func _ready() -> void:
	var screenSize = get_tree().root.content_scale_size
	maxX = screenSize.x
	maxY = screenSize.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down") * vitesse
		
	if transform.origin.x <= 0 and velocity.x < 0:
		transform.origin.x = 0
	if transform.origin.x >= maxX and velocity.x > 0:
		transform.origin.x = maxX
	if transform.origin.y <= 0 and velocity.y < 0:
		transform.origin.y = 0
	if transform.origin.y >= maxY and velocity.y > 0:
		transform.origin.y = maxY
	
	move_and_slide()
