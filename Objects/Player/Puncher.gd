extends KinematicBody2D

var motion:Vector2

const SPEED=400.0
const FRICTION=7.0
const ACCEL=10.0

var target:Node2D
onready var sprite = $Sprite

func _physics_process(delta):
	var dir=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if is_instance_valid(target):
		sprite.look_at(target.position)
	elif dir!=Vector2.ZERO:
		sprite.rotation=dir.angle()
	if dir==Vector2.ZERO:
		motion=lerp(motion,Vector2.ZERO,FRICTION*delta)
	else:
		motion=lerp(motion,dir*SPEED,ACCEL*delta)
	motion=move_and_slide(motion)
