extends Node
class_name RandomBehavior

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

export var min_patience: float = 1
export var max_patience: float = 5
export var speed_up: float = 0.5
export var speed: float = 175.0

var patience = (min_patience + max_patience) / 2.0
var direction = 0


func _ready() -> void:
	pass

func _physics_process(dt: float) -> void:
	speed += speed_up * dt
	
	var move = get_parent().move_and_slide(DIRECTIONS[direction] * speed)
	
	patience -= dt
	
	if not move or patience < 0:
		if patience < 0:
			patience = min_patience + randf() * (max_patience - min_patience)
		
		direction = (direction + 1) % len(DIRECTIONS)
	
	if DIRECTIONS[direction] == Vector2.UP:
		get_parent().rotation_degrees = 180
	elif DIRECTIONS[direction] == Vector2.RIGHT:
		get_parent().rotation_degrees = -90
	elif DIRECTIONS[direction] == Vector2.DOWN:
		get_parent().rotation_degrees = 0
	elif DIRECTIONS[direction] == Vector2.LEFT:
		get_parent().rotation_degrees = 90
