extends KinematicBody2D

const SPEED = 100
var direction = Vector2(0, -1)

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
