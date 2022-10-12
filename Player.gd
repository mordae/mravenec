extends KinematicBody2D

const UP    = Vector2(0, -1)
const DOWN  = Vector2(0, +1)
const LEFT  = Vector2(-1, 0)
const RIGHT = Vector2(+1, 0)

var dead = false
var speed = 250
var direction = UP

func _enter_tree() -> void:
	$Anim.play("walk")

func _input(event: InputEvent) -> void:
	if dead:
		return
	
	if event.is_action_pressed('ui_left'):
		direction = LEFT
		$Anim.rotation_degrees = 270
	elif event.is_action_pressed('ui_right'):
		direction = RIGHT
		$Anim.rotation_degrees = 90
	elif event.is_action_pressed('ui_up'):
		direction = UP
		$Anim.rotation_degrees = 0
	elif event.is_action_pressed('ui_down'):
		direction = DOWN
		$Anim.rotation_degrees = 180

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	move_and_slide(direction * speed)
	
	if $Mouth.is_colliding():
		var items = $Mouth.get_collider()
		var hit = $Mouth.get_collision_point()
		var pos = items.world_to_map(hit)
		var tile = items.get_cell_autotile_coord(pos.x, pos.y)

		if tile == Vector2(0, 0):
			$Nom.play()
		elif tile == Vector2(1, 0):
			$NomNomNom.play()
		
		items.set_cellv(pos, -1)

func die() -> void:
	dead = true
	collision_layer = 0
	$Anim.stop()
	$Ouch.show()
