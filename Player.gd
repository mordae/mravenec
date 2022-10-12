extends KinematicBody2D

const SPEED = 250
var direction = Vector2(0, -1)

func _enter_tree() -> void:
	$Anim.play("walk")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_left'):
		direction = Vector2(-1, 0)
		$Anim.rotation_degrees = 270
	elif event.is_action_pressed('ui_right'):
		direction = Vector2(+1, 0)
		$Anim.rotation_degrees = 90
	elif event.is_action_pressed('ui_up'):
		direction = Vector2(0, -1)
		$Anim.rotation_degrees = 0
	elif event.is_action_pressed('ui_down'):
		direction = Vector2(0, +1)
		$Anim.rotation_degrees = 180

func _physics_process(delta: float) -> void:
	move_and_slide(direction * SPEED)
	
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
