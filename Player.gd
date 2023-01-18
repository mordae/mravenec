extends KinematicBody2D

const SPEED_UP_PER_BOOST = 20

var dead = false
var speed = 250
var direction = Vector2.UP

var touch_base = Vector2.ZERO
var touch_enabled = false

func _enter_tree() -> void:
	$Anim.play('default')
	var score = $"../Canvas/GUI/Score"
	score.text = str(Game.points)
	
	if OS.has_touchscreen_ui_hint():
		$Camera.zoom = Vector2(0.5, 0.5)

func die() -> void:
	dead = true
	collision_layer = 0
	$Anim.stop()
	
	if OS.has_touchscreen_ui_hint():
		$OuchTouch.show()
	else:
		$OuchKeyboard.show()

func _input(event: InputEvent) -> void:
	if event.is_action('ui_cancel'):
		get_tree().quit()
	
	if dead:
		if event.is_action('ui_accept') or event is InputEventScreenDrag:
			var res = get_tree().change_scene("res://Level1.tscn")
			assert(res == OK)
			Game.reset()
		
		return
	
	if event is InputEventMouse:
		if event.button_mask:
			if not touch_enabled:
				touch_enabled = true
				touch_base = event.global_position
			else:
				var delta = event.global_position - touch_base
				
				if abs(delta.x) > abs(delta.y):
					if delta.x > 0:
						direction = Vector2.RIGHT
					else:
						direction = Vector2.LEFT
				else:
					if delta.y > 0:
						direction = Vector2.DOWN
					else:
						direction = Vector2.UP
		else:
			touch_enabled = false
		
	if event.is_action_pressed('ui_left'):
		direction = Vector2.LEFT
	elif event.is_action_pressed('ui_right'):
		direction = Vector2.RIGHT
	elif event.is_action_pressed('ui_up'):
		direction = Vector2.UP
	elif event.is_action_pressed('ui_down'):
		direction = Vector2.DOWN
	
	if direction == Vector2.LEFT:
		$Anim.rotation_degrees = -90
	elif direction == Vector2.RIGHT:
		$Anim.rotation_degrees = 90
	elif direction == Vector2.UP:
		$Anim.rotation_degrees = 0
	elif direction == Vector2.DOWN:
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
	
	var score = $"../Canvas/GUI/Score"
	score.text = str(Game.points)
	
	var exiting = $Exiter.get_overlapping_areas()
	
	if exiting:
		var scene_name = get_tree().get_current_scene().get_name()
		
		if scene_name == 'Level1':
			var res = get_tree().change_scene("res://Level2.tscn")
			assert(res == OK)
