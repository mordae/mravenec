extends KinematicBody2D

const SPEED_UP_PER_BOOST = 20

const UP    = Vector2(0, -1)
const DOWN  = Vector2(0, +1)
const LEFT  = Vector2(-1, 0)
const RIGHT = Vector2(+1, 0)

var dead = false
var speed = 250
var direction = UP

func _enter_tree() -> void:
	$Anim.play('default')
	var score = get_parent().get_node("GUI/Score")
	score.text = str(Game.points)

func die() -> void:
	dead = true
	collision_layer = 0
	$Anim.stop()
	$Ouch.show()

func _input(event: InputEvent) -> void:
	if event.is_action('ui_cancel'):
		get_tree().quit()
	
	if dead:
		if event.is_action('ui_accept'):
			var res = get_tree().change_scene("res://Level1.tscn")
			assert(res == OK)
			Game.reset()
		
		return
	
	if event.is_action_pressed('ui_left'):
		direction = LEFT
		$Anim.rotation_degrees = -90
	elif event.is_action_pressed('ui_right'):
		direction = RIGHT
		$Anim.rotation_degrees = 90
	elif event.is_action_pressed('ui_up'):
		direction = UP
		$Anim.rotation_degrees = 0
	elif event.is_action_pressed('ui_down'):
		direction = DOWN
		$Anim.rotation_degrees = 180

func _physics_process(_delta: float) -> void:
	if dead:
		return
	
	var _moved = move_and_slide(direction * speed)
	
	var collected = $Collector.get_overlapping_bodies()
	
	if collected:
		var items = collected[0]
		var pos = items.world_to_map(global_position)
		var cell = items.get_cellv(pos)
		
		if cell == 0:
			$Chargeup.play()
			speed += SPEED_UP_PER_BOOST
		elif cell == 1:
			$Pickup.play()
			Game.points += 1
		
		items.set_cellv(pos, -1)
	
	var score = get_parent().get_node("GUI/Score")
	score.text = str(Game.points)
	
	var exiting = $Exiter.get_overlapping_areas()
	
	if exiting:
		var scene_name = get_tree().get_current_scene().get_name()
		
		if scene_name == 'Level1':
			var res = get_tree().change_scene("res://Level2.tscn")
			assert(res == OK)
