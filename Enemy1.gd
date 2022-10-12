extends KinematicBody2D

const SPEED = 175

const MIN_PATIENCE = 1
const MAX_PATIENCE = 5

const UP    = Vector2(0, -1)
const DOWN  = Vector2(0, +1)
const LEFT  = Vector2(-1, 0)
const RIGHT = Vector2(+1, 0)

const DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

var patience = (MIN_PATIENCE + MAX_PATIENCE) / 2
var direction = 0

func _enter_tree() -> void:
	$Anim.play("walk")

func _physics_process(delta: float) -> void:
	var move = move_and_slide(DIRECTIONS[direction] * SPEED)
	var eaten = $DangerZone.get_overlapping_bodies()
	
	if eaten:
		$Crunch.play()
		eaten[0].die()
	
	patience -= delta
	
	if not move or patience < 0:
		if patience < 0:
			patience = MIN_PATIENCE + randf() * (MAX_PATIENCE - MIN_PATIENCE)
		
		direction = (direction + 1) % len(DIRECTIONS)
		
		if DIRECTIONS[direction] == UP:
			$Anim.rotation_degrees = 0
		elif DIRECTIONS[direction] == RIGHT:
			$Anim.rotation_degrees = 90
		elif DIRECTIONS[direction] == DOWN:
			$Anim.rotation_degrees = 180
		elif DIRECTIONS[direction] == LEFT:
			$Anim.rotation_degrees = 270
