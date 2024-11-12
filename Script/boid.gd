extends CharacterBody2D

var maxX : int
var maxY : int

@export
var speedScale : float = 20

func move() -> void:
	if abs(velocity.x) > 10 or abs(velocity.y) > 10:
		var scaleFactor = 10 / max(abs(velocity.x), abs(velocity.y))
		
		velocity.x *= scaleFactor * speedScale
		velocity.y *= scaleFactor * speedScale
	
	move_and_slide()

func distance(boid: Node2D) -> float:
	var distX = transform.origin.x - boid.transform.origin.x
	var distY = transform.origin.y - boid.transform.origin.y
	return sqrt(distX * distX + distY * distY)


func moveCloser(boids: Array) -> void:
	if len(boids) < 1: return
	
	var avgX = 0
	var avgY = 0
	
	for boid in boids:
		if boid.transform.origin.x == transform.origin.x and boid.transform.origin.y == transform.origin.y:
			continue
			
		avgX += (transform.origin.x - boid.transform.origin.x)
		avgY += (transform.origin.y - boid.transform.origin.y)
		
	avgX /= len(boids)
	avgY /= len(boids)
	
	velocity = Vector2(velocity.x - (avgX / 10), velocity.y - (avgY / 10))
	
func moveWith(boids: Array) -> void:
	if len(boids) < 1: return
	
	var avgX = 0
	var avgY = 0
	
	for boid in boids:
		if boid.transform.origin.x == transform.origin.x and boid.transform.origin.y == transform.origin.y:
			continue
			
		avgX += (transform.origin.x - boid.transform.origin.x)
		avgY += (transform.origin.y - boid.transform.origin.y)
		
	avgX /= len(boids)
	avgY /= len(boids)
	
	velocity = Vector2(velocity.x + (avgX / 40), velocity.y + (avgY / 40))


func moveAway(boids: Array, minDist : float) -> void:
	if len(boids) < 1: return
	
	var distX = 0
	var distY = 0
	var numClose = 0
	
	for boid in boids:
		var dist = distance(boid)
		if dist < minDist:
			numClose += 1
			var xDiff = (transform.origin.x - boid.transform.origin.x)
			var yDiff = (transform.origin.y - boid.transform.origin.y)
			
			if xDiff >= 0:
				xDiff = sqrt(minDist) - xDiff
			elif xDiff < 0:
				xDiff = -sqrt(minDist) - xDiff
				
			if yDiff >= 0:
				yDiff = sqrt(minDist) - yDiff
			elif yDiff < 0:
				yDiff = -sqrt(minDist) - yDiff
				
			distX += xDiff
			distY += yDiff
			
			if numClose == 0:
				return
				
			velocity = Vector2(velocity.x - distX / 5, velocity.y - distY / 5)
