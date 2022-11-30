extends KinematicBody2D

func _enter_tree() -> void:
	$Anim.play("walk")

func _physics_process(_delta: float) -> void:
	var eaten = $DangerZone.get_overlapping_bodies()
	
	if eaten:
		$Explosion.play()
		eaten[0].die()
	
	var nearby = $DroneZone.get_overlapping_bodies()
	if nearby:
		var distance = abs(position.distance_to(nearby[0].position))
		var radius = $DroneZone/Shape.shape.radius
		$Drone.volume_db = min((distance / radius) * -20 + 20, 6)
	else:
		$Drone.volume_db = -80
