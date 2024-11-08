extends Node2D

@export
var nbBoids : int

@export
var boidPrefab : PackedScene

var maxX : float
var maxY : float
var boids : Array
var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var foreground : TileMapLayer = get_node("Foreground")

	var screenSize = get_tree().root.content_scale_size
	rng = RandomNumberGenerator.new()
	
	maxX = screenSize.x
	maxY = screenSize.y
	
	for i in range(0, nbBoids):
		var boid : Node2D = boidPrefab.instantiate()
		
		var posX : float 
		var posY : float 
		
		posX = rng.randf_range(0, maxX)
		posY = rng.randf_range(0, maxY) 
		
		#Check the spawn position and change it if in wall
		
		boid.transform.origin = Vector2(posX, posY)
		
		boid.maxX = maxX
		boid.maxY = maxY
		
		boids.append(boid)
		add_child(boid)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for boid in boids:
		var closeBoids : Array
		for otherBoid in boids:
			if boid == otherBoid:
				continue
			var distance = boid.distance(otherBoid)
			if distance < 200:
				closeBoids.append(otherBoid)
		
		boid.moveCloser(closeBoids)
		boid.moveWith(closeBoids)
		boid.moveAway(closeBoids, 20)
		
		var border = 25
		if boid.transform.origin.x < border and boid.velocity.x < 0:
			boid.velocity.x = - boid.velocity.x * rng.randf()
		if boid.transform.origin.x > maxX - border and boid.velocity.x > 0:
			boid.velocity.x = - boid.velocity.x * rng.randf()
		if boid.transform.origin.y < border and boid.velocity.y < 0:
			boid.velocity.y = - boid.velocity.y * rng.randf()
		if boid.transform.origin.y > maxY - border and boid.velocity.y > 0:
			boid.velocity.y = - boid.velocity.y * rng.randf()
			
		boid.move()
		
