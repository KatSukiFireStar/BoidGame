extends Node2D

@export
var nbBoids : int

@export
var boidPrefab : PackedScene

@export
var distDog : int

var maxX : float
var maxY : float
var boids : Array
var rng : RandomNumberGenerator
var foreground : TileMapLayer
var player : Node2D

var indToRemove : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	foreground = get_node("Foreground")
	player = get_node("Player")

	var screenSize = get_tree().root.content_scale_size
	rng = RandomNumberGenerator.new()
	
	maxX = screenSize.x
	maxY = screenSize.y
	
	var used_cells = foreground.get_used_cells()
	
	for i in range(0, nbBoids):
		var boid : Node2D = boidPrefab.instantiate()
		
		var posX : int 
		var posY : int 
		
		var spawn : bool = false
		var spawnPos : Vector2i
		while not spawn:
			spawn = true
			
			posX = rng.randi_range(0, maxX)
			posY = rng.randi_range(0, maxY) 
			
			spawnPos = Vector2i(posX, posY)
			for cells in used_cells:
				var newCells = cells * 16
				if spawnPos.x >= newCells.x && spawnPos.x <= newCells.x + 16 && \
				 spawnPos.y >= newCells.y && spawnPos.y <= newCells.y + 16:
					spawn = false
					
					
		boid.transform.origin.x = spawnPos.x
		boid.transform.origin.y = spawnPos.y
		
		boid.maxX = maxX
		boid.maxY = maxY
			
		boids.append(boid)
		add_child(boid)
		

func distance(player: Node2D, boid: Node2D) -> float:
	var distX = player.transform.origin.x - boid.transform.origin.x
	var distY = player.transform.origin.y - boid.transform.origin.y
	return sqrt(distX * distX + distY * distY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in indToRemove:
		boids.remove_at(i)
	
	indToRemove = []
	for i in range(0, len(boids)):
		var boid = boids[i]
		var move : bool = true
		var closeBoids : Array
		for otherBoid in boids:
			if boid == otherBoid:
				continue
			var distance = boid.distance(otherBoid)
			if distance < 200:
				closeBoids.append(otherBoid)
		
		if boid.transform.origin.x > 0 and boid.transform.origin.x < 17 * 16 \
		and boid.transform.origin.y > 0 and boid.transform.origin.y < 9 * 16:
			move = false
		
		if move:
			boid.moveCloser(closeBoids)
			boid.moveWith(closeBoids)
			boid.moveAway(closeBoids, 50)
			
			if distance(player, boid) < distDog:
				boid.orientedMove(player, distDog)
			
			var space_state = get_world_2d().direct_space_state
			# use global coordinates, not local to node
			var query = PhysicsRayQueryParameters2D.create(boid.transform.origin, boid.transform.origin + (boid.velocity).normalized())
			var result = space_state.intersect_ray(query)
						
			var wall : bool = false
			if len(result) >= 1:
				if result.collider == foreground:
					wall = true
					
			if wall:
				boid.velocity *= -1
		
			var border = 25
			if boid.transform.origin.x <= border and boid.velocity.x < 0:
				boid.velocity.x = - boid.velocity.x * rng.randf()
			if boid.transform.origin.x >= maxX - border and boid.velocity.x > 0:
				boid.velocity.x = - boid.velocity.x * rng.randf()
			if boid.transform.origin.y <= border and boid.velocity.y < 0:
				boid.velocity.y = - boid.velocity.y * rng.randf()
			if boid.transform.origin.y >= maxY - border and boid.velocity.y > 0:
				boid.velocity.y = - boid.velocity.y * rng.randf()
		else:
			boid.velocity = (Vector2(9*16, 16) - boid.transform.origin)
			
			if boid.transform.origin.x >= (8*16) and boid.transform.origin.x <= (10*16) and boid.transform.origin.y <= 60:
				indToRemove.append(i)
				boid.destroy()
			
		boid.move()
