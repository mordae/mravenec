extends Node
class_name SeekingBehavior

export var speed_up: float = 0.5
export var speed: float = 100.0


func _ready() -> void:
	pass

func _physics_process(dt: float) -> void:
	speed += speed_up * dt
	
	var parent = get_parent()
	var player = get_node('../../Player')
	var agent = get_node('../Agent')
	
	agent.max_speed = speed
	agent.set_target_location(player.global_position)
	
	var next = agent.get_next_location()
	var path = agent.get_nav_path()
	
	for i in range(len(path)):
		path[i] = path[i] - parent.global_position
	
	get_node('../Path').points = path
	get_node('../Path').rotation = -parent.rotation
	
	var direction = parent.position.direction_to(next)
	parent.look_at(next)
	agent.set_velocity(direction * speed)
	parent.move_and_slide(direction * speed)
